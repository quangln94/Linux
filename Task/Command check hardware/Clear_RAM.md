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

Linux is designed in such a way that it looks into disk cache before looking onto the disk. If it finds the resource in the cache, then the request doesn’t reach the disk. If we clean the cache, the disk cache will be less useful as the OS will look for the resource on the disk.

## Tài liệu tham khảo
- https://www.tecmint.com/clear-ram-memory-cache-buffer-and-swap-space-on-linux/
