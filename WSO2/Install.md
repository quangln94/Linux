# API Manager
## Install API Manager 2.6.0
1. Sử dụng Docker để pull image WSO2 API Manager 2.6.0.
```sh
docker pull wso2/wso2am:2.6.0
```
2. Start 1 Docker container vừa pulled.
```sh
docker run -it -p 8280:8280 -p 8243:8243 -p 9443:9443 --name api-manager wso2/wso2am:2.6.0
```
Port 8280 và 8243 được sử dụng cho API calls (HTTP và HTTPS tương ứng), Port 9443 được sử dụng cho UI và các services nội bộ.

## Tài liệu tham khảo 
- https://docs.wso2.com/display/AM260/Quick+Start+Guide
- https://github.com/wso2/docker-apim/tree/master/dockerfiles/centos/apim
- https://apim.docs.wso2.com/en/latest/SetupAndInstall/InstallationGuide/installation-prerequisites/
