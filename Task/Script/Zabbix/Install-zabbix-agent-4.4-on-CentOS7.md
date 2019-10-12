#!bin/bash
echo "Install Zabbix-agent"
rpm -Uvh https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-release-4.4-1.el7.noarch.rpm
yum -y install zabbix-agent
service zabbix-agent start
systemctl enable zabbix-agent

read -p "SourceIP=IP-agent: " IPagent
sed -i "s/# SourceIP=/SourceIP=$IPagent/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/# ListenIP=0.0.0.0/ListenIP=$IPagent/" /etc/zabbix/zabbix_agentd.conf

read -p "Server=IP-server: " IPserver
sed -i "s/Server=127.0.0.1/Server=$IPserver/" /etc/zabbix/zabbix_agentd.conf
sed -i "s/ServerActive=127.0.0.1/ServerActive=$IPserver/"  /etc/zabbix/zabbix_agentd.conf

systemctl restart zabbix-agent
