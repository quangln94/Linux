# Iperf

Iperf là một công cụ miễn phí, dùng để đo lường lượng dữ liệu mạng (throughput) tối đa mà một server có thể xử lý.Công cụ này rất hữu ích để truy tìm ra các vấn đề đối với hệ thống mạng bởi Iperf có thể xác định được server nào không xử lý được lượng dữ liệu mạng (throughput) mà người quản trị mạng mong đợi.

Iperf rất hữu ích và có thể được sử dụng để đo lường throughput giữa hai máy chủ có sự khác biết về vị trí địa lý.

## 1. Cài đặt Iperf trên CentOS 7
```sh               
yum install epel-release -y
yum install iperf -y
```
## 2. Sử dụng Iperf

Iperf phải được cài đặt trên hai máy chủ sử dụng cho việc kiểm tra network throughput. Trong trường hợp bạn sử dụng Iperf để kiểm tra giữa máy chủ tại vHost và máy tính cá nhân của bạn, bạn phải cài đặt Iperf trên máy tính của bạn. Bạn nên sử dụng Iperf để kiểm tra giữa máy chủ của vHost và một máy chủ tại đặt tại nhiều vị trí khác nhau để có đánh giá chính xác nhất bởi kết quả của việc kiểm tra có thể bị tác động bởi sự giới hạn của các nhà mạng (ISP).

**TCP Clients & Servers**

Iperf yêu cầu cần có hai máy chủ để kiểm tra, một sẽ đóng vai trò và hoạt động như server, máy chủ còn lại sẽ là client kết nối tới máy chủ mà bạn đang kiểm tra tốc độ mạng.

1) Trên máy chủ tại vHost, bạn cho chạy Iperf như là Server
```sh
iperf -s
```
Bạn sẽ thấy kết quả xuất ra trên màn hình như sau:



2) Trên máy chủ còn lại đóng vài trò là client, kết nối tới máy chủ thứ nhất. Thay thế IP "172.16.40.247" với IP của server mà bạn đang kiểm tra

```sh
iperf -c 172.16.40.247
```
Bạn sẽ thấy kết quả xuất ra gần giống như sau:



3) Bạn cũng sẽ thấy kết quả tương tự trên Iperf server



4) Để stop Iperf trên server, nhấn `CTRL + C`

**UDP Clients & Servers**

Với Iperf, bạn có thể kiểm tra lượng dữ liệu mạng có thể đạt được thông qua kết nối UDP

1) Chạy Iperf trên server

```sh
iperf -s -u
```

2) Kết nối client tới Iperf server, thay thế "172.16.40.247" với IP của server mà bạn kiểm tra. Tham số -u mang ý nghĩa chỉ định thực hiện kết nối thông qua giao thức UDP

```sh
iperf -c 172.16.40.247 -u
```

Kết quả trả về là 1.05 Mbits/sec thấp hơn khá nhiều so với việc kiểm tra với kết nối TCP trước đó. Có điều này là bởi mặc định Iperf giới hạn băng thông cho kết nối UDP là 1 Mb/s

3) Bạn có thể tùy chỉnh kết quả trên với tham số -b, thay thế với giá trị băng thông tối đa mà bạn muốn kiểm tra

```sh
iperf -c 172.16.40.247 -u -b 100m
```
Câu lệnh trên thực hiện kiểm tra với băng thông 100Mb nếu có thể đạt được. Tham số -b chỉ sử dụng cho kết nối UDP, bởi mặc định Iperf không giới hạn với việc kiểm tra bằng kết nối TCP


**Kiểm tra kết nối 2 chiều**

Với tham số -d bạn có thể thực hiện kiểm tra tốc độ mạng hai chiều, sau khi kiểm tra tốc mạng lần nhất giữa client và server, thì hai máy chủ này sẽ đổi vai trò cho nhau và thực hiện lại việc kiểm tra lần hai.

```sh
iperf -c 172.16.40.247 -d
```
