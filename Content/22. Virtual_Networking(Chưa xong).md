# Linux Virtual Networking
Linux Virtual Networkin được thực hiện dễ dàng bằng libvirt và  linux virtual bridge</br>
Install, start and enable the libvirt
```
# yum install libvirt
# systemctl start libvirtd
# systemctl enable libvirtd
```
Libvirt hỗ trợ loại mvirtual networking sau:
    1. Network Address Translation mode
    2. Routed mode
    3. Isolated mode
    4. Bridged Mode
    
## Virtual Networking in NAT Mode</br>
Khi trình nền libvirt lần đầu tiên được cài đặt trên máy chủ, nó đi kèm với cấu hình chuyển đổi virtual network mặc định ban đầu. Vrtual switch mặc định này ở chế độ NAT và được sử dụng bởi Virtual Machines được cài đặt để liên lạc với mạng bên ngoài thông qua máy vật lý chủ. Cấu hình được lưu trữ trong file XML</br>
`/etc/libvirt/qemu/networks/default.xml`. Giao diện `virbr0` cũng được tạo trên máy chủ.
```
cat /etc/libvirt/qemu/networks/default.xml
<network>
  <name>default</name>
  <uuid>4300679a-baa4-45d7-983b-c5c1586e31d7</uuid>
  <bridge name="virbr0"/>
  <forward/>
  <ip address="192.168.122.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.122.2" end="192.168.122.254"/>
    </dhcp>
  </ip>
</network>
```
