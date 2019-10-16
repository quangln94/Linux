```sh
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' container_name_or_id
docker inspect -f '{{.Name}} - {{.NetworkSettings.IPAddress }}' $(docker ps -aq)
```


<img src=https://i.imgur.com/LLwUkxO.png>

<img src=https://i.imgur.com/YJ7FLR7.png>
