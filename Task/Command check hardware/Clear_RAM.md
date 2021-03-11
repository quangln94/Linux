# Giải phóng RAM
## 1. How to Clear Cache in Linux
Mỗi hệ thống Linux có 3 tùy chọn để clear cache mà không làm gián đoạn processes hay services.

- Clear PageCache only.
```sh
sync; echo 1 > /proc/sys/vm/drop_caches
```
- Clear dentries and inodes.
```sh
sync; echo 2 > /proc/sys/vm/drop_caches
```
- Clear PageCache, dentries and inodes.
```sh
sync; echo 3 > /proc/sys/vm/drop_caches 
```

**sync** sẽ xóa bộ đệm hệ thống (system buffer). Lệnh được chạy tuần tự, phân cách nhau bởi dấu `chấm phấy`(;). Nó sẽ đợi mỗi lênh kết thúc rồi mới thực thi lệnh tiếp theo. Việc ghi vào `drop_cache` (ở đây sử dụng lệnh `echo` ghi vào file) sẽ làm sạch bộ nhớ cache mà không kill bất kỳ application hay service nào.

Nếu phải xóa disk cache, lệnh đầu tiên và an toàn nhất cho enterprise và production. Lệnh sẽ chỉ clear PageCache. Không khuyến khích tùy chọn thứ 3 trên hệ thống Production nếu bản không biết mình đang làm gì. Lệnh sẽ clear PageCache, dentries và inodes.

Linux is designed theo cách mà nó nhìn vào disk cache trước khi nhòn vào disk. Nếu nó tìm thấy tài nguyên trong cache thì yêu cấu sẽ không đến được disk. Nếu clean cache, disk cache sẽ ít hữu dụng hơn vụ OS sẽ tìm tài nguyên trên disk.

Hơn nữa, nó cũng sẽ làm chậm hệ thống trong vài giây trong khi bộ nhớ cache được làm sạch và mọi tài nguyên mà hệ điều hành yêu cầu sẽ được tải lại trong disk-cache..

Bây giờ ta sẽ tạo một tập lệnh shell để tự động xóa bộ nhớ cache RAM hàng ngày vào lúc 2 giờ sáng thông qua cron. Tạo một script shell `clearcache.sh` và thêm các dòng sau.

```sh
#!/bin/bash
# Note, we are using "echo 3", but it is not recommended in production instead use "echo 1"
echo "echo 3 > /proc/sys/vm/drop_caches"
```
Set execute permission cho file `clearcache.sh`.
```sh
chmod 755 clearcache.sh
```

Bây giờ có thể gọi tập lệnh bất cứ khi nào có yêu cầu để xóa RAM cache. Đặt cron để xóa RAM cache hàng ngày vào lúc 2 giờ sáng. Mở `crontab` để chỉnh sửa.
```sh
crontab -e
...
0  2  *  *  *  /path/to/clearcache.sh
```

Trên hệ thống Productione hãy cân nhắc việc clear Ram cache

## Tài liệu tham khảo
- https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/
- https://www.tecmint.com/11-cron-scheduling-task-examples-in-linux/
