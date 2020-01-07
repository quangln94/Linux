## Alertmanager

Một số alerts có thể có labels và môt số khác thì không. Ví dụ sau là `Instance Down alert` với labels `{{ $labels.instance }}`, `{{ $labels.job }}` và cái còn lại thì không có labels:
```sh
groups:
- name: example
  rules:
  - alert: InstanceDownLabels
    expr: up
    for: 5m
    labels:
      severity: page
    annotations:
      summary: "Instance {{ $labels.instance }} down"
      description: "{{ $labels.instance }} of job {{ $labels.job }} has been down for more than 5 minutes."
  - alert: InstanceDownNoLabels
    expr: up
    for: 5m
    labels:
      severity: critical
    annotations:
      summary: "Instance down"
      description: "Something has been down for more than 5 minutes."
```
Tạo `slack receiver`.
```sh
- name: 'team-x'
  slack_configs:
  - channel: '#alerts'
    text: "<!channel> \nsummary: {{ .CommonAnnotations.summary }}\ndescription: {{ .CommonAnnotations.description }}"
```
`receiver config` lấy thông báo chung với `summary` và `description`.

<img src=https://i.imgur.com/H2BKYQm.png>

`InstanceDownNoLabels` thì ok nhưng `InstanceDownLabels`thì `summary` và `description` bị trống bởi vì mỗi time series là duy nhất và được định danh bởi metric name của nó và một bộ labels.

Chúng ta sử dụng biến `{{ $labels.instance }}` và `{{ $labels.job }}` trong `description` và `summary`, và kết quả là không có gia trị chung cho chúng.

Có thử thử ranging cho alerts (see example):
```sh
- name: 'default-receiver'
  slack_configs:
  - channel: '#alerts'
    title: "{{ range .Alerts }}{{ .Annotations.summary }}\n{{ end }}"
    text: "{{ range .Alerts }}{{ .Annotations.description }}\n{{ end }}"
```
Với cấu hình này, Slack sẽ như sau: 

<img src=https://i.imgur.com/jdfQCqk.png>

Bây giờ alerts không bị trống nhưng nội dung bị trụng lặp trong Slack title và text.

Giải pháp là checking cả 2 trường hợp. Ví dụ tạo template và lưu trong file `my.tmpl`:
```sh
{{ define "slack.my.title" -}}
    {{- if .CommonAnnotations.summary -}}
        {{- .CommonAnnotations.summary -}}
    {{- else -}}
        {{- with index .Alerts 0 -}}
            {{- .Annotations.summary -}}
        {{- end -}}
    {{- end -}}
{{- end }}
{{ define "slack.my.text" -}}
    {{- if .CommonAnnotations.description -}}
        {{- .CommonAnnotations.description -}}
    {{- else -}}
        {{- range $i, $alert := .Alerts }}
            {{- "\n" -}} {{- .Annotations.description -}}
        {{- end -}}
    {{- end -}}
{{- end }}
```
Nếu sử dụng template này cho Slack notifications:
```sh
- name: 'default-receiver'
  slack_configs:
  - channel: '#alerts'
    title: '{{ template "slack.my.title" . }}'
    text: '{{ template "slack.my.text" . }}'
templates:
- 'my.tmpl'
```
Thông báo Slack sẽ như sau:

<img src=https://i.imgur.com/RNeT8vQ.png>

Để làm template look nice, sử dụng `—` trước và sau bên trái và bên phải `{{` và `}}`. Với dòng mới  thì sử dụng `{{"\n"}}`.

Với `title` chúng ta check nếu có 1 `common summary` và sử dụng nó, nếu không thì sử dụng `summary` từ alert đầu tiên để giữ `summary short`. 

Với `text` chúng ta sử dụng `common description` nếu tồn tại hoặc bao gồm tất cả các alerts và in description cho mỗi alert. Nhưng có thể có nhiều values khác nhau cho labels và nhiều descriptions khác nhau. Ví dụ cho 10 descriptions đầu tiên:
```sh
{{- range $i, $alert := .Alerts -}}
    {{- if lt $i 10 -}}
        {{- "\n" -}} {{- index $alert.Annotations "description" -}}
    {{- end -}}
{{- end -}}
```
Tương tự cho alerting rules với `{{$value}}` bên trong `annotations`.

## Tài liệu tham khảo
- https://www.weave.works/blog/labels-in-prometheus-alerts-think-twice-before-using-them
