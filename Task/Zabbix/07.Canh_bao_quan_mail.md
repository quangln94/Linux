# Cấu hình gửi cảnh báo qua mail

Trước tiên cần cài đặt các gói phụ trợ

```
yum install python2.7
yum install python-pip
```

Để cấu hình gửi cảnh báo qua mail trước hết cần phải cấu kiểm tra trong file cấu hình của zabbix-server để kiểm tra đường dẫn của thư mục chứa script alert

```
cat /etc/zabbix/zabbix_server.conf | grep alert
#	Number of pre-forked instances of alerters.
#	Full path to location of custom alert scripts.
# AlertScriptsPath=${datadir}/zabbix/alertscripts
AlertScriptsPath=/usr/lib/zabbix/alertscripts
``` 

Ta thấy thư mục có đường dẫn

```
/usr/lib/zabbix/alertscripts
```

Vào thư mục đó và tiến hành download scripts về

```
[root@localhost ~]# cd /usr/lib/zabbix/alertscripts/
[root@localhost alertscripts]# wget https://raw.githubusercontent.com/quangln94/Linux/master/Task/zabbix-alert-smtp.sh
```

Chỉnh sửa 2 dòng sau trong file này

```
MAIL_ACCOUNT = 'emailcuaban@gmail.com'
MAIL_PASSWORD = 'password email cua ban'
```

Ở đây bạn khai báo địa chỉ email và password của email của bạn. Email này sẽ được dùng để gửi mail.

Sau khi sửa xong thì lưu lại sau đó cấp quyền cho file này

```
chmod +x zabbix-alert-smtp.sh
```

**Cấu hình trên web**

Đến bước này bạn cấu hình tương tự như cấu hình với gửi telegram ở

Cần lưu ý một vài bước

Bước này bạn chỉ ra tên script dùng để gửi mail

<img src=https://i.imgur.com/kh0b8Vy.png>

Bước này chỉ ra địa chỉ mail nhận cảnh báo

<img src=https://i.imgur.com/Ca0duQw.png>

Khi thông số vợt quá ngưỡng cảnh báo thì cảnh báo sẽ được gửi về mail

## Tài liệu tham khảo
https://www.liquidweb.com/kb/how-to-install-pip-on-centos-7/
