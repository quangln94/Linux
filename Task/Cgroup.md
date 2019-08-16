# Control Group
## Cài đặt libcgroup
Vì Systemd sử dụng Cgroups, mặc dù vậy, gói [libcgroup] được cài đặt theo mặc định. Một số bộ điều khiển cho mỗi hệ thống con được gắn kết theo [/ sys / fs / cgroup] như sau theo mặc định. Hệ thống con trên Cgroups có nghĩa là một tài nguyên như CPu hoặc bộ nhớ, v.v.
