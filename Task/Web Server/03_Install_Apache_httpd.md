# Apache httpd: Install httpd
Install httpd to configure Web Server. HTTP uses 80/TCP.
### 1. Install httpd.
```sh
[root@server1 ~]# yum install httpd -y
# remove welcome page
[root@server1 ~]# rm -f /etc/httpd/conf.d/welcome.conf
```
### 2. Configure httpd. Replace server name to your own environment.
```sh
[root@server1 ~]# vi /etc/httpd/conf/httpd.conf
# line 86: change to admin's email address
ServerAdmin root@srv.world
# line 95: change to your server's name
ServerName www.srv.world:80
# line 151: change
AllowOverride All
# line 164: add file name that it can access only with directory's name
DirectoryIndex index.html index.cgi index.php
# add follows to the end
# server's response header
ServerTokens Prod
# keepalive is ON
KeepAlive On
[root@server1 ~]# systemctl start httpd 
[root@server1 ~]# systemctl enable httpd 
```
### 3.	If Firewalld is running, allow HTTP service. HTTP uses 80/TCP.
```sh
[root@server1 ~]# firewall-cmd --add-service=http --permanent 
success
[root@server1 ~]# firewall-cmd --reload 
success
```
### 4. Create a HTML test page and access to it from client PC with web browser. It's OK if following page is shown.
```sh
[root@server1 ~]# vi /var/www/html/index.html
 <html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
Test Page
</div>
</body>
</html>
```
### 5. To access web test
Type to web browser your IP's Web Server or Name:
Example: 
<img src=https://i.imgur.com/UZsTqs4.png>
