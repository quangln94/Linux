# 1. Giới thiệu Linux bridge
## 1.1. Kiến trúc
Linux bridge là một soft-switch, một trong ba công nghệ cung cấp switch ảo trong hệ thống Linux (bên cạnh macvlan và OpenvSwitch), giải quyết vấn đề ảo hóa network bên trong các máy vật lý.<br>
Bản chất, linux bridge sẽ tạo ra các switch layer 2 kết nối các máy ảo (VM) để các VM đó giao tiếp được với nhau và có thể kết nối được ra mạng ngoài. Linux bridge thường sử dụng kết hợp với hệ thống ảo hóa KVM-QEMU.
### 1.2. Các thành phần
<img src="http://i.imgur.com/GKs6wWF.png">
Kiến trúc linux bridge minh họa như hình vẽ trên. Một số khái niệm liên quan tới linux bridge:

- **Port**: tương đương với port của switch thật
- **Bridge**: tương đương với switch layer 2
- **Tap**: hay <b>tap interface</b> có thể hiểu là giao diện mạng để các VM kết nối với bridge cho linux bridge tạo ra
- **fd**: forward data - chuyển tiếp dữ liệu từ máy ảo tới bridge

## 1.3. Các tính năng
- <b>STP</b>: Spanning Tree Protocol - giao thức chống loop gói tin trong mạng
- <b>VLAN</b>: chia switch (do linux bridge tạo ra) thành các mạng LAN ảo, cô lập traffic giữa các VM trên các VLAN khác nhau của cùng một switch.
- <b>FDB</b>: chuyển tiếp các gói tin theo database để nâng cao hiệu năng switch

# 2. Lab tính năng Linux bridge
## 2.1. Topology
<img src="http://i.imgur.com/zswlIDa.jpg">

- Một máy tính với 2 card eth1, eth2 (có thể sử dụng máy ảo), cài ubuntu 14.04.
- Trường hợp 1: Tạo một switch ảo và gán interface eth1 vào switch đó, tạo một máy ảo bên trong máy host, gắn vào tap interface của switch và kiểm tra địa chỉ được cấp phát. (Có thể tạo 2 VM trong host cùng gắn vào tap interface của switch, ping kiểm tra kết nối).
- Trường hợp 2: Gắn cả 2 card mạng eth1, eth2 của host vào switch ảo, set priority cho hai port ứng với 2 card. Kiểm tra xem máy ảo (gắn vào tap interface của switch ảo) nhận ip cùng dải với card mạng vật lý nào.
## 2.2. Cài đặt và cấu hình
**Trường hợp 1**</br>
- Bước 1: Tạo switch ảo br1. Nếu đã tồn tại có thể xóa switch này đi và tạo lại:
```sh
brctl delbr br0 # xóa đi nếu đã tồn tại
brctl addbr br0 # tạo mới
```
- Bước 2: Gán port eth1 vào swith br1
```sh
brctl addif br0 eno1 
brctl stp br0 on # enable tính năng STP nếu cần
```
- Bước 3: Khi tạo một switch mới <b>br1</b>, trên máy host sẽ xuất hiện thêm 1 NIC ảo trùng tên switch đó (br1). Ta có thể cấu hình xin cấp phát IP cho NIC này sử dụng command hoặc cấu hình trong file <b>/etc/network/interfaces</b> để giữ cấu hình cho switch ảo sau khi khởi động lại:
```sh
dhclient br0
```
Nếu trước đó trong file `/etc/network/interfaces` đã cấu hình cho NIC eth1, ta phải comment lại cấu hình đó hoặc xóa cấu hình đó đi và thay bằng các dòng cấu hình sau:
```sh
/etc/network/interfaces
auto br0
iface br0 inet dhcp
bridge_ports eno1
bridge_stp on
bridge_fd 0
bridge_maxwait 0
```
- Bước 4: Khởi động lại các card mạng và kiểm tra lại cấu hình bridge:
```sh
ifdown -a && ifup -a # khởi động lại tất cả các NIC
brctl show # kiểm tra cấu hình switch ảo
```
Kết quả kiểm tra cấu hình sẽ tương tự như sau:
```sh
bridge name	bridge id		STP enabled	interfaces
br0		8000.000c29586f24	yes		eno1
```
Kết quả cấu hình thành công gắn NIC eth1 vào switch ảo br1 sẽ hiển thị như đoạn mã trên

- Bước 5: Để kiểm tra, ta có thể tạo một máy ảo và tạo một NIC kết nối với switch

**Trường hợp 2**: Gắn 2 NIC eth1 và eth2 vào cùng switch **br1**. Đồng thời thiết lập mức độ ưu tiên của các port tương ứng với các NIC đã gán vào switch br1
```sh
brctl addif br1 eth1 # gán NIC eth1 vào sw br1
brctl addif br1 eth2 # gán NIC eth2 vào sw br1
# Thiết lập mức ưu tiên cho các port
brctl setportprio br1 eth1 1
brctl setportprio br1 eth2 2
```
Theo lý thuyết, port nào có độ ưu tiên cao hơn thì các VM khi gắn vào tap interface của switch ảo sẽ nhận IP cùng dải với NIC của máy host đã gán vào switch ảo đó. Theo như cấu hình trên, port tương ứng với NIC eth2 có độ ưu tiên cao hơn. Như vậy VM sẽ nhận IP cùng dải với eth2.<br>
Trong bài lab này, card **eth1** thuộc dải mạng ***10.10.10.0/24*** và card **eth2** thuộc dải mạng ***10.0.2.0/24***. Như vậy VM sẽ nhận IP thuộc dải ***10.0.2.0/24***. Minh họa:

<img src="http://i.imgur.com/p6dNZV8.png">

<img src="http://i.imgur.com/gWcAeq1.png">

## 3. Tham khảo
- http://www.innervoice.in/blogs/2013/12/02/linux-bridge-virtual-networking
- https://github.com/hocchudong/Linux-bridge
