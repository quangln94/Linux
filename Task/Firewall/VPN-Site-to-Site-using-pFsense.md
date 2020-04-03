# VPN Site to Site
## 1.	Mô hình triển khai
Hệ thống VPN Site to Site sẽ được cài đặt theo mô hình sau:
<img src=https://i.imgur.com/ZISYC9k.png>

## Hệ thống sẽ bao gồm:
|Site SmartCloud|Site người dùng|
|---------------|---------------|
|Pfsense|IP Public|123.4.5.1	vFirewall	IP Public	123.4.5.2
|IP Private|	192.168.1.2/24		IP Private	172.16.0.2/24
|VM1|	IP Private	192.168.1.3/24	SRV1	IP Private	172.16.0.3/24
## 2.	Cài đặt Pfsense trên SmartCloud
### 2.1. Khởi tạo VM pfsense với image pfsense trên SmartCloud
•	Khởi tạo VM pfsense
•	Mở Port HTTPS trên SmartCloud
### 2.2.	Kiểm tra Pfsense đã nhận đúng IP hay chưa

Kiểm tra IP WAN và IP LAN tương ứng

Đúng theo mô hình thì IP như sau:
- IP WAN: 123.4.5.1
- IP LAN: 192.168.1.2

Nếu sai thực hiện như sau:
-	Chọn Option 4 Reset cấu hình và để gán lại Interface cho Pfsense
<img src=https://i.imgur.com/672ESx8.png> 

-	Lựa chọn card mạng cho WAN và LAN (mặc định Pfsense shell chỉ cho phép khai báo 1 card LAN, các card LAN khác sẽ khai báo trên Pfsense web)

Chọn card mạng gắn với card WAN: ở đây chọn là card vtnet0

<img src=https://i.imgur.com/N6kfBXf.png> 

Chọn card mạng gắn với card LAN: ở đây chọn là card vtnet1

<img src=https://i.imgur.com/sXiQP7T.png>

Xác nhận việc thực hiện

<img src=https://i.imgur.com/vrshevI.png>

Sau khi tạo xong, thông tin truy cấp Web qua IP LAN và IP WAN tương tự như sau:
- IP WAN: 123.4.5.1
- IP LAN: 192.168.1.2

## 3.	Cấu hình Pfsense trên SmartCloud
### 3.1.	Đăng nhập vào giao diện Web của Pfsense
Đăng nhập vào Web quản trị theo IP WAN hoặc IP LAN

https://192.168.1.2 hoặc https://123.4.5.1

## 3.2.	Cấu hình IPsec VPN
### 3.2.1.	Thực hiện Add Phase 1
•	Tại Web quản trị, chọn VPN -> IPsec
<img src=https://i.imgur.com/U3H32Ul.png>

•	Chọn Add P1
<img src=https://i.imgur.com/fTfTlsA.png>

Nhập vào các thông tin như sau:
Chú ý: Các thông số này phải giống nhau trên cả 2 Site
•	Key Exchange version: IKEv1
•	Remote Gateway: IP WAN của Site 2
•	Pre-Shared Key: key VPN, chú ý copy để điền tại Site người dùng
•	Encryption Algorithm: 3DES
•	Hash: MD5
•	DH Group: 2

<img src=https://i.imgur.com/42mDnB1.png>

<img src=https://i.imgur.com/oFdmHDL.png>
 
Lưu ý: Trường Pre-Shared Key: Sử dụng Pre-Shared Key có sẵn hoặc tự tạo bằng cách Generate new Pre-Shared Key sẽ tạo ra chuỗi Pre-Shared Key. Chuỗi Pre-Shared Key này giống nhau trên Pfsense và thiết bị vFirewall của Người dùng

**Sau khi cấu hình xong chọn Save ở dưới cùng của Page**

### 3.2.2.	Thực hiện Add Phase 2

•	Chon Show Phase 2 Entries -> Add P2. 
<img src=https://i.imgur.com/Hp1Jy3D.png>

<img src=https://i.imgur.com/v4m9LHd.png>

•	Điền thông tin như sau:
<img src=https://i.imgur.com/Sv8QCwF.png>
Trong đó:
-	Local Network: Chọn Private Lan. Nếu hệ thống có nhiều dải Private Lan thì chú ý chọn đúng dải. Private Lan ở dây là Lan subnet
-	Remote Network: Chọn dải Private Lan cần Remote đến. Ở đây là 172.16.0.0/24
-	Tiếp tục nhập vào các thông số sau:
-	Protocol: ESP
-	Encrytion Algorithms: 3DES
-	Hash algorithms: MD5
-	PFS key group: 2 (1024 bit)
-	Lifetime: 3600

<img src=https://i.imgur.com/HSkErX6.png>

=>	Sau đó chọn Save -> Apply Changes

## 3.3.	Cấu hình Firewall trên Pfsense
### 3.3.1.	Cấu hình Rule cho WAN Interface
-	Chọn Firewall -> Rules 
<img src=https://i.imgur.com/Bh8w04U.png>

**Setup WAN Firewall Rule: Mở port 4500 và 500 (TCP/UDP)**

-	Chọn sang tab WAN -> Add
<img src=https://i.imgur.com/TCBXUdS.png>

**Chọn Save dưới cùng của Page. Tiếp tục mở Port 500 -> chọn Add**
<img src=https://i.imgur.com/IAqJt5W.png>

Kết quả tương tư như sau: 
<img src=https://i.imgur.com/5tlEKmB.png>

### 3.3.2.	Cấu hình Rule cho LAN Interface
Setup LAN Firewall Rule: Mở all cho LAN
•	Chọn sang tab LAN -> Add
<img src=https://i.imgur.com/ljGucRS.png>

Kết quả như sau:
<img src=https://i.imgur.com/CDsRFjL.png>

#### 3.3.3.	Cấu hình Rule cho IPsec
**Chọn sang tab IPsec -> Add**
<img src=https://i.imgur.com/iHvp2tM.png>

**Thực hiện Edit Rules để NAT giữa dải LAN của 2 Pfsense**
<img src=https://i.imgur.com/ku7RMEs.png>

Trong đó:
- Protocol: Any – Cho phép toàn bộ giao thức
- Source: 172.16.0.0/24 – Dải LAN phía Người dùng
- Destination: LAN net – Dải LAN của VM trên SmartCloud

**Sau đó chọn Save -> Apply Changes**
### 3.4.	Kết nối IPsec VPN giữa 2 Site
**Vào Status -> IPsec -> Connect**

## 4.	Cấu hình trên OpenStack 
### 4.1.	Thực hiện trên Node Controller
**Lấy thông tin id-port của Pfsense thuộc LAN Private (IP: 192.168.1.2)**
```sh
neutron port-list --insecure| grep 192.168.1.2
```
Kết quả tương tự như sau
```sh| 97282f6a-17ff-4e4b-b53f-27756efda9f7 |      | fa:16:3e:fe:09:26 | {"subnet_id": "08cf18ff-66c4-489a-b857-1f2d01fbb043", "ip_address": "192.168.1.2"}    |
```
=> ID Port là: 97282f6a-17ff-4e4b-b53f-27756efda9f

**Cho phép nhiều VLAN được đi qua port này**
```sh
neutron port-update 97282f6a-17ff-4e4b-b53f-27756efda9f7 --allowed-address-pairs list=true type=dict ip_address=0.0.0.0/0 --insecure
```
Kết quả:
```sh
Updated port: 97282f6a-17ff-4e4b-b53f-27756efda9f
```
**Kiểm tra thông tin port**
```sh
neutron port-show 97282f6a-17ff-4e4b-b53f-27756efda9f7 --insecure
```
## 5.	Thực hiện định tuyến phía SmartCloud đến phía Người dùng và ngược lại
### 5.1.	Phía SmartCloud đến phía Người dùng
**Ví dụ với VM CentOS 7 trên Smart Cloud**

Sử dụng lệnh sau với quyền root
```sh
ip route add 172.16.0.0/24 via 192.168.1.2 dev eth1
```
Trong đó:
-	172.16.0.0/24: Dải Private LAN phía người dùng
-	192.168.1.2: IP LAN của Pfsense
-	eth1: Interface của IP LAN trên VM

Thực hiện Ping từ VM1 trên SmartCloud để kiểm tra
```sh
ping 172.16.0.3
```
### 5.2.	Phía Người dùng đến phía SmartCloud
Phía Người dùng thực hiện

## Tài liệu tham khao
- https://www.google.com/search?q=vpn+site+to+site+pfsense&rlz=1C1CHBD_enVN874VN874&oq=vpn+&aqs=chrome.1.69i57j35i39j0l3j69i60l3.4486j0j7&sourceid=chrome&ie=UTF-8
- http://svuit.vn/threads/site-to-site-vpn-pfsense-va-draytek-878/
