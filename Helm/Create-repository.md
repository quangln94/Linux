# Create a public Helm chart repository with GitHub Pages

## Tạo Repository trên Github

<img src=https://i.imgur.com/5DdJXdn.png>

## Clone Repo vừa tạo 
```sh
git clone https://github.com/quangln94/Helm-Repository.git
```
## Tạo Helm chart và đóng gói
```sh
helm create myapp
helm package myapp
```
## Published Repo
Vào Repo chọn setting chọn `master branch`
<img src=https://i.imgur.com/bfkXXnD.png>

## Tạo file `index.yaml`
```sh
helm repo index --url https://quangln94.github.io/Helm-Repository/ .
```
## Commit và Push toàn bộ thư mục lên Github
```sh
git add index.yaml
git add myapp-0.1.0.tgz
git commit -m 'helm repo'
git push -u origin master
```
## Add Repo cho helm
```sh
helm repo add myhelmrepo https://quangln94.github.io/Helm-Repository/
```
## Kiểm tra Repo vừa add
Kiểm tra package
```sh
helm search myapp
```
Chạy thử bản release
```sh
helm install myhelm/myapp
```
## Tài liệu tham khảo
- https://medium.com/@mattiaperi/create-a-public-helm-chart-repository-with-github-pages-49b180dbb417
