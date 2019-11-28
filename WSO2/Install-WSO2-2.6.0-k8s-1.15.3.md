## Thực hiện trên NFS
```sh
sudo groupadd --system -g 802 wso2
sudo useradd --system -g 802 -u 802 wso2carbon

mkdir /data/apim
mkdir /data/database

sudo chown -R wso2carbon:wso2 /data/apim
sudo chown -R wso2carbon:wso2 /data/database

sudo chmod -R 757 /data/apim
sudo chmod -R 757 /data/database
```

## Thực hiện trên k8s Master Node
```sh
export username=ngocquang.ptit@gmail.com
export password=123456aA@

./deploy.sh --wu=$username --wp=$password
````
## Tài liệu tham khảo
- https://medium.com/@andriperera.98/how-to-deploy-wso2-api-manager-in-production-grade-kubernetes-268a65a41fa2
