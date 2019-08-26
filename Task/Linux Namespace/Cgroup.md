# Control Group
## Cài đặt libcgroup
Gói libcgroup được cài đặt theo mặc định. Một số bộ điều khiển cho mỗi subsystem mặc định sẽ được mount vào /sys/fs/cgroup. Subsystem trên Cgroups có nghĩa là một số tài nguyên như CPU, RAM, ...
```
[root@client01 ~]# ls -l /sys/fs/cgroup/
total 0
drwxr-xr-x 5 root root  0 Aug 13 18:19 blkio
lrwxrwxrwx 1 root root 11 Aug 13 18:19 cpu -> cpu,cpuacct
lrwxrwxrwx 1 root root 11 Aug 13 18:19 cpuacct -> cpu,cpuacct
drwxr-xr-x 5 root root  0 Aug 13 18:19 cpu,cpuacct
drwxr-xr-x 3 root root  0 Aug 13 18:19 cpuset
drwxr-xr-x 5 root root  0 Aug 13 18:19 devices
drwxr-xr-x 3 root root  0 Aug 13 18:19 freezer
drwxr-xr-x 2 root root  0 Aug 13 18:19 hugetlb
drwxr-xr-x 5 root root  0 Aug 13 18:19 memory
lrwxrwxrwx 1 root root 16 Aug 13 18:19 net_cls -> net_cls,net_prio
drwxr-xr-x 3 root root  0 Aug 13 18:19 net_cls,net_prio
lrwxrwxrwx 1 root root 16 Aug 13 18:19 net_prio -> net_cls,net_prio
drwxr-xr-x 3 root root  0 Aug 13 18:19 perf_event
drwxr-xr-x 5 root root  0 Aug 13 18:19 pids
drwxr-xr-x 5 root root  0 Aug 13 18:19 systemd
```
|blkio|	Giới hạn quyền truy cập đầu vào/đầu ra và từ các block devives.|
|-------|------------|
|cpu|	Sử dụng bộ lập lịch để cung cấp cho các task cgroup truy cập vào CPU.|
|cpuacct|	Tự động tạo ra các các báo cáo về tài nguyên CPU.|
|cpuset|	Giới hạn việc sử dụng CPU trên hệ thống nhiều CPU.|
|devices|	It allows or denies access to devices by tasks.|
|freezer|	It suspends or resumes tasks in a cgroup.|
|hugetlb|	It limits to use HugeTLB.|
|memory|	Giới hạn việc sử dụng bộ nhớ bởi các task và tự tạo báo cáo về tài nguyên bộ nhớ.|
|net_cls|	Đánh số classid cho từng gói tin nhằm giúp Linux Traffic Controller(tc) có thể biết gói tin đến từ cgroup nào.|
|net_prio|	Giới hạn băng thông mạng theo độ ưu tiên.|
|perf_event|	It identifies cgroup membership of tasks and can be used for performance analysis.|
|pids|	Giới hạn số lượng processes.|

# Tài liệu tham khảo 
- https://www.server-world.info/en/note?os=CentOS_7&p=cgroups&f=1
