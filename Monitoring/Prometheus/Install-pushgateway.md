# Install PushGateway
## 1. Cấu hình PushGateway
### Download [PushGateway](https://prometheus.io/download/) và giải nén bằng lệnh sau:
```sh
wget https://github.com/prometheus/pushgateway/releases/download/v1.0.1/pushgateway-1.0.1.linux-amd64.tar.gz
tar zxvf pushgateway-1.0.1.linux-amd64.tar.gz
```
### Tạo user `pushgateway`:
```sh
useradd --no-create-home --shell /bin/false pushgateway
```
### Move the binary in place và update permissions:
```sh
cp pushgateway-1.0.1.linux-amd64/pushgateway /usr/local/bin/pushgateway
chown pushgateway:pushgateway /usr/local/bin/pushgateway
```
### Tạo file `systemd`:
```sh
[Service]
User=pushgateway
Group=pushgateway
Type=simple
ExecStart=/usr/local/bin/pushgateway
#   --web.listen-address=":9091" \\
#   --web.telemetry-path="/metrics" \\
#   --persistence.file="/tmp/metric.store" \\
#   --persistence.interval=5m \\
#   --log.level="info" \\
#   --log.format="logger:stdout?json=true"

[Install]
WantedBy=multi-user.target
EOF
```
### Reload systemd và restart the pushgateway service:
```sh
systemctl daemon-reload
systemctl start pushgateway
```
### Kiểm tra status `pushgateway`
```sh
systemctl status pushgateway
```
## 2. Cấu hình Prometheus
### Sửa file `/etc/prometheus/prometheus.yml` để scrape `pushgateway`
```sh
  - job_name: 'pushgateway'
    honor_labels: true
    static_configs:
      - targets: ['ip_pushgateway:9091']
```
## Tài liệu tham khảo
- https://blog.ruanbekker.com/blog/2019/05/17/install-pushgateway-to-expose-metrics-to-prometheus/
