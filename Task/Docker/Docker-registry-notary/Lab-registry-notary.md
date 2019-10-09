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
