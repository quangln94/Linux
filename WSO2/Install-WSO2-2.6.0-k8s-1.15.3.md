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
mkdir -p /data/apim
mkdir -p /data/database
```
Cho phép client có thể truy cập thư mục bằng cách thêm các dòng sau:
```sh
$ vim /etc/exports
/data 10.1.38.128(rw,sync,no_subtree_check)
/data 10.1.38.111(rw,sync,no_subtree_check)
/data 10.1.38.149(rw,sync,no_subtree_check)
/data 10.1.38.144(rw,sync,no_subtree_check)
/data 10.1.38.146(rw,sync,no_subtree_check)
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
Chờ 5 đến 10p để quá trinh deploy xong và kiểm tra trang thái như sau:
```
$ kubectl get pods -o wide

NAME                                                              READY   STATUS    RESTARTS   AGE     IP            NODE      NOMINATED NODE   READINESS GATES
wso2apim-with-analytics-apim-7947fc4565-849l5                     1/1     Running   1          3h22m   10.244.3.10   worker1   <none>           <none>
wso2apim-with-analytics-apim-analytics-deployment-c74464c56ttc5   1/1     Running   1          177m    10.244.3.13   worker1   <none>           <none>
wso2apim-with-analytics-mysql-deployment-84bb65bdf-mfqqq          1/1     Running   1          3h23m   10.244.3.11   worker1   <none>           <none>

```
Chạy lệnh sau để Expose Port:
```sh
kubectl expose deployment wso2apim-with-analytics-apim -n wso2 --type=NodePort
kubectl expose deployment wso2apim-with-analytics-apim-analytics-deployment -n wso2 --type=NodePort
```
Kiểm tra service được expose:
```sh
$ kubectl get svc

NAME                                                TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                                                                                                                                  AGE
wso2apim-with-analytics-apim                        NodePort    10.105.107.141   <none>        8280:30356/TCP,8243:30029/TCP,9763:30324/TCP,9443:30893/TCP,5672:31879/TCP,9711:30444/TCP,9611:31929/TCP,7711:32128/TCP,7611:30101/TCP   157m
wso2apim-with-analytics-apim-analytics-deployment   NodePort    10.110.44.182    <none>        9764:32255/TCP,9444:31322/TCP,7612:30022/TCP,7712:31326/TCP,9091:30293/TCP,7071:30357/TCP,7444:31093/TCP                                 157m
wso2apim-with-analytics-apim-analytics-service      ClusterIP   10.102.228.226   <none>        7612/TCP,7712/TCP,9444/TCP,9091/TCP,7071/TCP,7444/TCP                                                                                    3h14m
wso2apim-with-analytics-apim-service                ClusterIP   10.103.65.35     <none>        8280/TCP,8243/TCP,9763/TCP,9443/TCP                                                                                                      3h14m
wso2apim-with-analytics-rdbms-service               ClusterIP   10.111.95.98     <none>        3306/TCP                                                                                                                                 3h14m
```
Mở trình duyệt và kiểm tra:
```sh
https://10.1.38.128:30893/carbon
https://10.1.38.128:30893/publisher
https://10.1.38.128:30893/store
```
## 3. Một số lỗi hay gặp
**1. Khi kiểm tra bằng lênh `kubectl get pods -o wide` thấy STATUS là: `Pending` , `ErrImagePull`...**

Kiểm tra xem Lỗi do thiếu tài nguyên hay không pull được image bằng lệnh `kubectl describe pods namepod`
- Nếu thiếu tài nguyên thì cấp thêm tài nguyên cho Node
- Nếu không pull được image thì kiểm tra lại tài khoản đăng ký có đúng không và có thành công hay không`

## Tài liệu tham khảo
- https://medium.com/@andriperera.98/how-to-deploy-wso2-api-manager-in-production-grade-kubernetes-268a65a41fa2
