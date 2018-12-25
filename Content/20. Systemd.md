
Systemd là hệ thống init mới cho các bản phân phối Linux hiện đại thay thế init cũ dựa trên /etc/init.d/script. Nó cung cấp nhiều tính năng mạnh mẽ để bắt đầu, dừng và quản lý các quy trình. Dưới đây là một ví dụ để tạo một dịch vụ MineCraft cho systemd. MainCraft là một trò chơi dựa trên Java từ Mojang.</br>
Đầu tiên, cài đặt trò chơi và môi trường của nó.
```sh
# yum install java-1.8.0-openjdk.x86_64
# which java
/bin/java
# mkdir /root/Minecraft
# cd /root/Minecraft
# wget -O minecraft_server.jar https://s3.amazonaws.com/Minecraft.Download/versions/1.8.6/minecraft_server.1.8.6.jar
# ls -lrt
-rw-r--r--. 1 root root 9780573 May 25 11:47 minecraft_server.jar
-rw-r--r--. 1 root root       2 Jun  1 11:48 whitelist.json
-rw-r--r--. 1 root root     180 Jun  1 12:01 eula.txt
drwxr-xr-x. 2 root root    4096 Jun  1 16:09 logs
-rw-r--r--. 1 root root     785 Jun  1 16:09 server.properties
-rw-r--r--. 1 root root       2 Jun  1 16:09 banned-players.json
-rw-r--r--. 1 root root       2 Jun  1 16:09 banned-ips.json
-rw-r--r--. 1 root root       2 Jun  1 16:09 ops.json
-rw-r--r--. 1 root root     109 Jun  1 16:10 usercache.json
drwxr-xr-x. 8 root root    4096 Jun  1 16:37 world
```
Máy chủ MineCraft có thể được khởi động tại dòng lệnh, bằng cách ban hành lệnh sau:
```
# java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui
```
Cách khác, một file cấu hình systemd có thể được tạo để bắt đầu, dừng và kiểm tra trạng thái của máy chủ như một dịch vụ hệ thống tiêu chuẩn bằng cách sử dụng tiện ích `` systemctl``
```
# vi /lib/systemd/system/minecraftd.service
[Unit]
Description=Minecraft Server
After=syslog.target network.target

[Service]
Type=simple
WorkingDirectory=/root/Minecraft
ExecStart=/bin/java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui
SuccessExitStatus=143
Restart=on-failure

[Install]
WantedBy=multi-user.target

# systemctl start minecraftd
# systemctl status minecraftd
minecraftd.service - Minecraft Server
   Loaded: loaded (/usr/lib/systemd/system/minecraftd.service; disabled)
   Active: active (running) since Mon 2015-06-01 16:00:12 UTC; 18s ago
 Main PID: 20975 (java)
   CGroup: /system.slice/minecraftd.service
           └─20975 /bin/java -Xmx1024M -Xms1024M -jar minecraft_server.jar nogui

# systemctl stop minecraftd
```
Lưu ý: ``SuccessExitStatus=143`` là bắt buộc khi một quá trình không xử lý đúng tín hiệu thoát. Điều này hầu như luôn luôn do lỗi lập trình và khá phổ biến với các loại ứng dụng của Java. Để tránh trạng thái thất bại của MainCraft khi dừng dịch vụ, mã thoát 143 cần được thêm vào tệp đơn vị dưới dạng trạng thái thoát "success".</br>
Tiện ích ``systemctl`` có thể được sử dụng để bật/tắt dịch vụ khi khởi động
```
# systemctl enable minecraftd
ln -s '/usr/lib/systemd/system/minecraftd.service' '/etc/systemd/system/multi-user.target.wants/minecraftd.service'
# systemctl is-enabled minecraftd
enabled
# systemctl disable minecraftd
```
Đây là một ví dụ khác
```
# cat /etc/systemd/system/redmined.service
[Unit]
Description=Redmine Server
After=syslog.target network.target

[Service]
Type=simple
PermissionsStartOnly=true
WorkingDirectory=/home/redmine/redmine
ExecStartPre=/usr/sbin/iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080
ExecStart=/usr/bin/ruby bin/rails server -b 0.0.0.0 -p 8080 webrick -e production
User=redmine
Group=redmine
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=redmined
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

```
