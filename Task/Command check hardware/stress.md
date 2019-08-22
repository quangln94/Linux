# Comand `stress`
Stress là một câu lệnh được sử dụng để áp một mức tải cho hệ thống để kiểm tra khả năng chịu tải của nó trong thực tế. Nó sẽ tạo ra các process sử dụng rất nhiều tài nguyên của hệ thống như CPU, RAM hay disk để ta có thể kiểm tra được khả năng và ngưỡng mà hệ thống của ta hoạt động tốt nhất. Nó cũng rất có ích để tái hiện lại trạng thái tải cao gây ra lỗi hệ thống để ta có thể tìm cách xử lý.
## 1.  Cài đặt
- Trến CentOS 7:
```sh
yum install stress -y
```
- Trên Ubuntu:
```sh
apt-get install stress
```
##. Sử dụng
- Gõ lệnh `stress` để xem các tùy chọn như sau:

```sh
[root@client01 ~]# stress
`stress' imposes certain types of compute stress on your system

Usage: stress [OPTION [ARG]] ...
 -?, --help         show this help statement
     --version      show version statement
 -v, --verbose      be verbose
 -q, --quiet        be quiet
 -n, --dry-run      show what would have been done
 -t, --timeout N    timeout after N seconds
     --backoff N    wait factor of N microseconds before work starts
 -c, --cpu N        spawn N workers spinning on sqrt()
 -i, --io N         spawn N workers spinning on sync()
 -m, --vm N         spawn N workers spinning on malloc()/free()
     --vm-bytes B   malloc B bytes per vm worker (default is 256MB)
     --vm-stride B  touch a byte every B bytes (default is 4096)
     --vm-hang N    sleep N secs before free (default none, 0 is inf)
     --vm-keep      redirty memory instead of freeing and reallocating
 -d, --hdd N        spawn N workers spinning on write()/unlink()
     --hdd-bytes B  write B bytes per hdd worker (default is 1GB)

Example: stress --cpu 8 --io 4 --vm 2 --vm-bytes 128M --timeout 10s

Note: Numbers may be suffixed with s,m,h,d,y (time) or B,K,M,G (size).
```

# Tài liệu tham khảo
- https://blog.cloud365.vn/linux/huong-dan-su-dung-stress/

