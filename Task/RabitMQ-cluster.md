# Set up RabbitMQ Cluster trên CentOS 7
## Step 1: Sửa Setup file /etc/hosts
```sh
cat << EOF >> /etc/hosts

192.168.10.11 controller1
192.168.10.12 controller2
192.168.10.13 controller3
EOF
```
## Step 2: Cài đặt RabbitMQ Server

Cài đặt RabbitMQ Server packages from the EPEL (Extra Packages for Enterprise Linux) repository.

Add the EPEL repository to the CentOS 7 system.
```sh
yum -y install epel-release
```
Install RabbitMQ Server trên tất cả các Node: controller1, controller2, controller3.
```sh
sudo yum -y install rabbitmq-server
```
Start và enable RabbitMQ service.
```sh
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
```
## Step 3: Enable RabbitMQ Management Plugins

Enable RabbitMQ management plugins. Nó là 1 interface cho phép monitor và handle RabbitMQ server từ web browser, chạy mặc định trên TCP port 15672.
```sh
sudo rabbitmq-plugins enable rabbitmq_management
```
Restart và enabled RabbitMQ service.
```sh
sudo systemctl restart rabbitmq-server
```
And the RabbitMQ Management has been enabled.

## Step 4 - Configure CentOS Firewalld

Enable firewalld service cho RabbitMQ server. 

Port 5672 cho RabbitMQ
Port 15672 cho RabbitMQ management
Port 4369, 25672 cho RabbitMQ
```sh
sudo firewall-cmd --add-port=15672/tcp --permanent
sudo firewall-cmd --add-port=5672/tcp --permanent
sudo firewall-cmd --add-port={4369/tcp,25672/tcp} --permanent
```
Reload firewalld và check
```sh
sudo firewall-cmd --reload
sudo firewall-cmd --list-all
```
## Step 5: Set up RabbitMQ Cluster

Để setup RabbitMQ cluster, cần chắc chắn fil `.erlang.cookie` giống nhau trên tất cả các Node. Chúng ta sẽ copy file `.erlang.cookie` trong thư mục `/var/lib/rabbitmq` từ `controller1` đến `controller2` và `controller3`.
```sh
scp /var/lib/rabbitmq/.erlang.cookie root@controller2:/var/lib/rabbitmq/
scp /var/lib/rabbitmq/.erlang.cookie root@controller3:/var/lib/rabbitmq/
```
Setup `controller2` và `controller3` join cluster 'controller1'.

Chạy lệnh sau trên `controller2` và `controller3`
```sh
systemctl restart rabbitmq-server
rabbitmqctl stop_app
```
Join RabbitMQ server vào cluster trên `controller` và start.
```sh
sudo rabbitmqctl join_cluster rabbit@controller1
sudo rabbitmqctl start_app
```
Kiểm tra trạng thái cluster
```sh
sudo rabbitmqctl cluster_status
```
And you will get the results as shown below.

On the 'node02'.

Node 02

On the 'node03'.

Node 03

The RabbitMQ Cluster has been created, with node01, node02, and node03 as members.

Step 6 - Create a New Administrator User
In this tutorial, we will create a new admin user for our RabbitMQ server and delete the default 'guest' user. We will be creating a new user from 'node01', and it will be automatically replicated to all nodes on the cluster.

Add a new user named 'hakase' with password 'aqwe123@'.

sudo rabbitmqctl add_user hakase aqwe123@
Setup the 'hakase' user as an administrator.

sudo rabbitmqctl set_user_tags hakase administrator
And grant the 'hakase' user permission to modify, write, and read all vhosts.

sudo rabbitmqctl set_permissions -p / hakase ".*" ".*" ".*"
Now delete the default 'guest' user.

sudo rabbitmqctl delete_user guest
And check all available users.

sudo rabbitmqctl list_users
And you will get the result as shown below.

Create RabbitMQ admin user

A new RabbitMQ user has been created, and the default 'guest' user is deleted.

Step 7 - RabbitMQ Setup Queue Mirroring
This setup is must, we need to configure the 'ha policy' cluster for queue mirroring and replication to all cluster nodes. If the node that hosts queue master fails, the oldest mirror will be promoted to the new master as long as it synchronized, depends on the 'ha-mode' and 'ha-params' policies.

Following are some example about the RabbitMQ ha policies.

Setup ha policy named 'ha-all' which all queues on the RabbitMQ cluster will be mirroring to all nodes on the cluster.

sudo rabbitmqctl set_policy ha-all ".*" '{"ha-mode":"all"}'
Setup ha policy named 'ha-two' which all queue name start with 'two.' will be mirroring to the two nodes on the cluster.

sudo rabbitmqctl set_policy ha-two "^two\." \
   '{"ha-mode":"exactly","ha-params":2,"ha-sync-mode":"automatic"}'
Setup ha policy named 'ha-nodes' which all queue name start with 'nodes.' will be mirroring to two specific nodes 'node02' and 'node03' on the cluster.

sudo rabbitmqctl set_policy ha-nodes "^nodes\." \
   '{"ha-mode":"nodes","ha-params":["rabbit@node02", "rabbit@node03"]}'
Now check all available policies using the command below.

sudo rabbitmqctl list_policies;
And if you want to remove the policy, use the following command.

sudo rabbitmqctl clear_policy ha-two
RabbitMQ Setup Queue Mirroring

Step 8 - Testing
Open your web browser and type the IP address of the node with port '15672'.

http://10.0.15.21:15672/

Type the username 'hakase' with password 'aqwe123@'.

RabbitMQ Login

And you will get the RabbitMQ admin dashboard as below.

RabbitMQ Dashboard

All cluster nodes status is up and running.

Now click on the 'Admin' tab menu, and click the 'Users' menu on the side.

Admin menu

And you will get the hakase user on the list.

Now click on the 'Admin' tab menu, and click the 'Policies' menu on the side.

Policies

And you will get all RabbitMQ ha policies we've created.

The installation and configuration of RabbitMQ Cluster on CentOS 7 server has been completed successfully.

# Tài liệu tham khảo
- https://www.howtoforge.com/how-to-set-up-rabbitmq-cluster-on-centos-7/
- https://www.rabbitmq.com/documentation.html
