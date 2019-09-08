# Check free disk sử dụng bashshell
## 1. Tạo file bashshell check free disk như sau:
Tạo file checkfreedisk.sh thêm vào nội dung sau và lưu lại:
```sh
vim checkfreedisk.sh
```
```sh
#!/bin/bash
df $PWD | awk '/[0-9]%/{print $(NF-2)}'
```
## Tài liệu tham khảo
- https://stackoverflow.com/questions/8110530/check-free-disk-space-for-current-partition-in-bash/8110535
