```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```
Liệt kê `network` trong docker
```sh
docker network ls
```
<img src=https://i.imgur.com/LLwUkxO.png>

Kết quả hiển thị cho thấy cụm cluster kết nối với cùng 1 `overlaynetwork`

Đào sâu hơn vào `overlaynetwork`
```sh
docker network inspect network-name
```

<img src=https://i.imgur.com/YJ7FLR7.png>
