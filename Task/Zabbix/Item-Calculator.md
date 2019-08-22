# Item Calculator
Đây là 1 loại Item được sử dụng để tính toán dựa trên các Item khác
## Cách add Item Calculator như sau:
- Vào `Configuration` -> `Host` -> `Item` -> `Create Item`
<img src=https://i.imgur.com/ldd0Wms.png>

**Trong đó:**</br>
***Name:*** Tên Item</br>
***Type:*** Chọn Calculator</br>
***Key:*** Đặt 1 tên bất kỳ</br>
***Formula:*** Biểu thức tính toán (quan trọng nhất)

- Chọn Add. Sau đó vào `Lastest data` xem kết quả.
## Một số ví dụ về `Formual`:

- Check `Total disk free` bằng cách check `disk free` trên từng phân vùng( `/` và `/boot`)
```sh
last("vfs.fs.size[/,free]") + last("vfs.fs.size[/boot,free]")
```
- Calculating percentage of free disk space on '/'.
```sh
100*last("vfs.fs.size[/,free]")/last("vfs.fs.size[/,total]")
```
- Calculating a 10-minute average of the number of values processed by Zabbix.
```sh
avg("Zabbix Server:zabbix[wcache,values]",600)
```
- Calculating total bandwidth on eth0.
```sh
last("net.if.in[eth0,bytes]")+last("net.if.out[eth0,bytes]")
```
- Calculating percentage of incoming traffic.
```sh
100*last("net.if.in[eth0,bytes]")/(last("net.if.in[eth0,bytes]")+last("net.if.out[eth0,bytes]"))
```
```sh
last("grpsum[\"video\",\"net.if.out[eth0,bytes]\",\"last\"]") / last("grpsum[\"video\",\"nginx_stat.sh[active]\",\"last\"]") 
```
