**Mô hình LAB**

|Server|IP|
|------|--|
|master1|10.1.38.128|
|master2|10.1.38.111|
|master3|10.1.38.149|
|worker1|10.1.38.144|
|worker2|10.1.38.146|
|NFS|10.1.38.129|

## 1. Thực hiện trên NFS
Tạo system group tên `wso2`với group id 802.
```sh
sudo groupadd --system -g 802 wso2
```
Tạo Linux system user account tên `wso2carbon` với user id 802 và Add user `wso2carbon` vào group `wso2`.
```sh
sudo useradd --system -g 802 -u 802 wso2carbon
```
Tạo thư mục chia sẻ cho mỗi Kubernetes Persistent Volume
```sh
mkdir /data/apim
mkdir /data/database
```
Gán quyền sở hữu và phân quyền cho mỗi thư mục vừa tạo ở trên
```sh
sudo chown -R wso2carbon:wso2 /data/apim
sudo chown -R wso2carbon:wso2 /data/database
sudo chmod -R 757 /data/apim
sudo chmod -R 757 /data/database
```
## 2. Thực hiện trên k8s Master Node
Clone thư mục trên git
```sh
git clone https://github.com/wso2/samples-apim.git
```
Truy cập file `persistent-volumes.yaml` trong thư mục vừa clone và nội dung như sau:
```sh
$ vim samples-apim/kubernetes-demo/kubernetes-apim-2.6.x/pattern-1/extras/rdbms/volumes/persistent-volumes.yaml`
------------------------
 server: 10.1.38.129                     # IP Server NFS
    path: "/data/apim"                  # Thư mục chia sẻ trên NFS
```
Truy cập file `persistent-volumes.yaml` trong thư mục vừa clone và nội dung như sau:
```sh
$ vim samples-apim/kubernetes-demo/kubernetes-apim-2.6.x/pattern-1/volumes/persistent-volumes.yaml
------------------------
server: 10.1.38.129                     # IP Server NFS
    path: "/data/database"              # Thư mục chia sẻ trên NFS
```
Đăng ký tài khoản để pull image từ WSO2 Docker Registry [tại đây](https://wso2.com/subscription) chọn `GET A FREE 15-DAY TRIAL`

Export WSO2 Username và password vừa đăng ký để pull tất cả docker images trong WSO2 Docker Registry.
```sh
export username=youraccount
export password=yourpassword
```
Thực hiện chạy script deploy:
```
cd samples-apim/kubernetes-demo/kubernetes-apim-2.6.x/pattern-1/scripts
./deploy.sh --wu=$username --wp=$password
````
## Tài liệu tham khảo
- https://medium.com/@andriperera.98/how-to-deploy-wso2-api-manager-in-production-grade-kubernetes-268a65a41fa2
