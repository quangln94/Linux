- Logout `registry`
```sh
$ docker logout notaryserver
$ docker tag ubuntu:16.04 notaryserver:5000/ubuntu:v1
$ docker push ubuntu:16.04 notaryserver/ubuntu:v1
$ docker push notaryserver/ubuntu:v1
The push refers to repository [docker.io/notaryserver/ubuntu]
9acfe225486b: Preparing
90109bbe5b76: Preparing
cb81b9d8a6c9: Preparing
ea69392465ad: Preparing
denied: requested access to the resource is denied

[root@server01 ~]# export DOCKER_CONTENT_TRUST=0
[root@server01 ~]# docker push notaryserver:5000/ubuntu:v1
The push refers to repository [notaryserver:5000/ubuntu]
9acfe225486b: Layer already exists
90109bbe5b76: Layer already exists
cb81b9d8a6c9: Layer already exists
ea69392465ad: Layer already exists
v1: digest: sha256:c0ae44d97c088026f44b1a4ef9da06d3fa8e771b95d95bffbcbddea6d1e450b7 size: 1150


```
```sh
[root@server01 ~]# export DOCKER_CONTENT_TRUST=1
[root@server01 ~]# docker tag ubuntu:16.04 notaryserver:5000/ubuntu:v2
[root@server01 ~]# docker push notaryserver:5000/ubuntu:v2
The push refers to repository [notaryserver:5000/ubuntu]
9acfe225486b: Layer already exists
90109bbe5b76: Layer already exists
cb81b9d8a6c9: Layer already exists
ea69392465ad: Layer already exists
v2: digest: sha256:c0ae44d97c088026f44b1a4ef9da06d3fa8e771b95d95bffbcbddea6d1e450b7 size: 1150
Signing and pushing trust metadata
WARN[0000] Error while downloading remote metadata, using cached timestamp - this might not be the latest version available remotely
WARN[0000] Error while downloading remote metadata, using cached timestamp - this might not be the latest version available remotely
ERRO[0000] Could not publish Repository since we could not update: tls: first record does not look like a TLS handshake
failed to sign notaryserver:5000/ubuntu:v2: tls: first record does not look like a TLS handshake
```
```sh
[root@server01 ~]# docker pull notaryserver:5000/ubuntu:v2
WARN[0000] Error while downloading remote metadata, using cached timestamp - this might not be the latest version available remotely
No valid trust data for v2
[root@server01 ~]# docker pull notaryserver:5000/ubuntu:v1
WARN[0000] Error while downloading remote metadata, using cached timestamp - this might not be the latest version available remotely
No valid trust data for v1
```







- Khi `DOCKER_CONTENT_TRUST=0` bạn có thể down bất kỳ image từ bất kì đâu
```sh
export DOCKER_CONTENT_TRUST=0
docker pull ubuntu:16.04 
docker tag ubuntu:16.04 notaryserver:5000/ubuntu:myos
docker push notaryserver:5000/ubuntu:myos
```


- Khi `DOCKER_CONTENT_TRUST=1` bạn chỉ có thể down các image từ `Registry` đã được ký
```sh
export DOCKER_CONTENT_TRUST=1
docker pull notaryserver:5000/ubuntu:myos
WARN[0000] Error while downloading remote metadata, using cached timestamp - this might not be the latest version available remotely
No valid trust data for myos3
```
```sh
docker tag ubuntu:16.04 notaryserver:5000/ubuntu:myos
docker push notaryserver:5000/ubuntu:myos
docker pull ubuntu
```
- Login `registry` 
