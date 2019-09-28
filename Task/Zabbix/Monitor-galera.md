# Monitor Galera MariaDB

## 1. Clone Repo về máy

- Cài Git
```sh
yum install git -y
```
- Clone Repo về máy
```sh 
git clone https://github.com/MogiePete/zabbix-galera-template.git
```
- Sau đó `cd zabbix-galera-template`

<img src=https://i.imgur.com/pNRyhDU.png>

- Trong này có 2 file :
`App-Galera_Cluster.xml`: Là file Template để Import </br>
`userparameter_galera.conf`:

- Copy file `userparameter_galera.conf` vào `/etc/zabbix/zabbix_agentd.d/`
```sh
cp userparameter_galera.conf /etc/zabbix/zabbix_agentd.d
```
- Vào file `/etc/my.cnf.d/server.cnf` thêm các dòng sau:
```sh
vim /etc/my.cnf.d/server.cnf
[client]
user:zabbix
password:zabbix
```
<img src=https://i.imgur.com/ITIjqL9.png>

Trong đó:
user:usermonitor
password:passusermonitor



- Restart lại zabbix-agent
```sh
systemctl restart zabbix-agent`
```
- Vào Zabbix-web để Import Template
- Tải Tempalte về máy. File này là `file.xml`
- Vào `Configuration` -> `Template` -> `Import` -> Chọn file `App-Galera_Cluster.xml` mới tải về -> chọn `Import`
- Vào `Monitoring` -> `Lastest data` để xem kết quả

<img src=https://i.imgur.com/Z2xhvI8.png>








## Tài liệu tham khảo
- https://github.com/zarplata/zabbix-agent-extension-mysql
- https://github.com/zarplata/zabbix-agent-extension-rabbitmq/issues/1
- https://share.zabbix.com/databases/mysql/zabbix-extension-for-monitoring-mysql-galera-slave

- https://share.zabbix.com/databases/mysql/galera-cluster-monitoring
- https://github.com/MogiePete/zabbix-galera-template
