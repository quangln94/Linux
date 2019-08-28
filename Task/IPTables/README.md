# IPTABLES
## 1. Firewall là gì
Trong Network, Firewall là bức tường chống lại những xâm nhập trái phép bên ngoài và hạn chế những truy cấp từ bên trong một Area.

Firewall sẽ kiểm soát các luồng traffic vào ra theo các Rule được thiết lập sẵn.
## 2. Iptables là gì
Iptables là 1 ứng dụng tường lửa được tích hợp trong hầu hết các bản phân phối của hệ điều hành Linux (CentOS, Ubuntu…). Tuy nhiên từ phiên bản CentOS 7. Tường lừa mặc định trên CentOS 7 là `Firewalld`. Nếu bạn muốn dùng `Iptables` thì thực hiện như sau: 
- Cài đặt các gói Iptables
```sh
yum install -y iptables-services
```
- Disable dịch vụ firewalld
```sh
systemctl mask firewalld
```
 - Stop dịch vụ firewalld
 ```sh
 systemctl stop firewalld
```
- Để iptables và ip6tables tự khởi động khi boot
```sh
systemctl enable iptables
systemctl enable ip6tables
```
- Start iptables và ip6tables
```sh
systemctl start iptables
systemctl start ip6tables
```
