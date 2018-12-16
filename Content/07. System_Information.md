# Command Check System information</br>
## Một số các command để check các thông tin của hệ điều</br>
- Command `cat /etc/*release`
```sh
$ cat /etc/*release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=18.04
DISTRIB_CODENAME=bionic
DISTRIB_DESCRIPTION="Ubuntu 18.04.1 LTS"
NAME="Ubuntu"
VERSION="18.04.1 LTS (Bionic Beaver)"
ID=ubuntu
ID_LIKE=debian
PRETTY_NAME="Ubuntu 18.04.1 LTS"
VERSION_ID="18.04"
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
VERSION_CODENAME=bionic
UBUNTU_CODENAME=bionic
```
*Lệnh này sẽ cho chúng ta thông tin về tên hệ điều hành, phiên bản và distro đang dùng và một số các thông tin trợ giúp khác.*

Command `uname -a` dùng cho cả Ubuntu với CentOS
```sh
$ uname -a
Linux Admin 4.15.0-39-generic #42-Ubuntu SMP Tue Oct 23 15:48:01 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```
*Lệnh này show ra đầy đủ các thông tin của kernel như phiên bản kernel là `4.15.0-39-generic`, 32bit hay 64bit*

Có thể dùng các tùy chọn khác để show ra từng thông tin một</br>
```sh
-a, --all                print all information, in the following order, except omit -p and -i if unknown:
-s, --kernel-name        print the kernel name
-n, --nodename           print the network node hostname
-r, --kernel-release     print the kernel release
-v, --kernel-version     print the kernel version
-m, --machine            print the machine hardware name
-p, --processor          print the processor type (non-portable)
-i, --hardware-platform  print the hardware platform (non-portable)
-o, --operating-system   print the operating system
    --help     display this help and exit
    --version  output version information and exit
 ```
- Command `cat /proc/version`: cũng kiểm tra thông tin kernel
```sh
$ cat /proc/version
Linux version 4.15.0-39-generic (buildd@lgw01-amd64-054) (gcc version 7.3.0 (Ubuntu 7.3.0-16ubuntu3)) #42-Ubuntu SMP Tue Oct 23 15:48:01 UTC 2018
```
Một số các các thông tin khác chưa trong /proc, các lệnh cơ bản
```sh
/proc/meminfo: Ram info
/proc/cpuinfo: hiển thị thông tin CPU
/proc/mounts: xem trạng thái tất cả các file system đã mount
/proc/partitions: thông tin các phân vùng
```
- Command `lsb_release -a` kiểm tra phiên bản hệ điều hành distro của nó, không dùng được trên CentOS
```sh
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 18.04.1 LTS
Release:	18.04
Codename:	bionic
```
- Command `sudo lspci` liệt kê các thiết bị PCI trong máy và Command `sudo lsusb` liệt kê tất cả các thiết bị usb
```sh
$ sudo lspci
00:00.0 Host bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor DRAM Controller (rev 09)
00:01.0 PCI bridge: Intel Corporation Xeon E3-1200 v2/3rd Gen Core processor PCI Express Root Port (rev 09)
00:16.0 Communication controller: Intel Corporation 6 Series/C200 Series Chipset Family MEI Controller #1 (rev 04)
00:1a.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #2 (rev 05)
00:1b.0 Audio device: Intel Corporation 6 Series/C200 Series Chipset Family High Definition Audio Controller (rev 05)
00:1c.0 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 1 (rev b5)
00:1c.4 PCI bridge: Intel Corporation 6 Series/C200 Series Chipset Family PCI Express Root Port 5 (rev b5)
00:1d.0 USB controller: Intel Corporation 6 Series/C200 Series Chipset Family USB Enhanced Host Controller #1 (rev 05)
00:1f.0 ISA bridge: Intel Corporation H61 Express Chipset Family LPC Controller (rev 05)
00:1f.2 IDE interface: Intel Corporation 6 Series/C200 Series Chipset Family 4 port SATA IDE Controller (rev 05)
00:1f.3 SMBus: Intel Corporation 6 Series/C200 Series Chipset Family SMBus Controller (rev 05)
00:1f.5 IDE interface: Intel Corporation 6 Series/C200 Series Chipset Family 2 port SATA IDE Controller (rev 05)
01:00.0 VGA compatible controller: Advanced Micro Devices, Inc. [AMD/ATI] Cape Verde LE [Radeon HD 7730/8730]
01:00.1 Audio device: Advanced Micro Devices, Inc. [AMD/ATI] Cape Verde/Pitcairn HDMI Audio [Radeon HD 7700/7800 Series]
03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
```
- Command `lscpu` hiển thị thông tin về cpu</br>
- Command `free -m` xem thông tin RAM và SWAP</br>
- Command `fdisk -l` xem các thông tin phân vùng ổ cứng</br>
- Command `df -h` hiển thị các thông về không gian sử dụng đĩa</br>
- Command `du -sh` xem dung lượng của thư mục hiện hành, du để xem dung lượng của tất cả các thư mục con bên trong</br>

- Memory Info
```sh
$ head /proc/meminfo 
MemTotal:        8131980 kB
MemFree:         2960732 kB
MemAvailable:    6054040 kB
Buffers:          594056 kB
Cached:          2615596 kB
SwapCached:            0 kB
Active:          2389640 kB
Inactive:        2295872 kB
Active(anon):    1477304 kB
Inactive(anon):    58584 kB
```
- File system
```sh
$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            3,9G     0  3,9G   0% /dev
tmpfs           795M  1,9M  793M   1% /run
/dev/sdb2       457G   19G  415G   5% /
tmpfs           3,9G  121M  3,8G   4% /dev/shm
tmpfs           5,0M  4,0K  5,0M   1% /run/lock
tmpfs           3,9G     0  3,9G   0% /sys/fs/cgroup
/dev/loop0      141M  141M     0 100% /snap/gnome-3-26-1604/74
/dev/loop1       87M   87M     0 100% /snap/core/4917
/dev/loop2       15M   15M     0 100% /snap/gnome-logs/37
/dev/loop3       13M   13M     0 100% /snap/gnome-characters/103
/dev/loop4      2,3M  2,3M     0 100% /snap/gnome-calculator/260
/dev/loop5      3,8M  3,8M     0 100% /snap/gnome-system-monitor/57
/dev/loop6       35M   35M     0 100% /snap/gtk-common-themes/808
/dev/loop7      148M  148M     0 100% /snap/skype/66
/dev/loop9       88M   88M     0 100% /snap/core/5742
/dev/loop10     3,8M  3,8M     0 100% /snap/gnome-system-monitor/51
/dev/loop11      15M   15M     0 100% /snap/gnome-logs/45
/dev/loop12     2,4M  2,4M     0 100% /snap/gnome-calculator/180
/dev/loop13     145M  145M     0 100% /snap/skype/63
/dev/loop14     141M  141M     0 100% /snap/gnome-3-26-1604/70
/dev/loop15      13M   13M     0 100% /snap/gnome-characters/139
/dev/loop16      43M   43M     0 100% /snap/gtk-common-themes/701
/dev/sdb1       511M  6,1M  505M   2% /boot/efi
tmpfs           795M   16K  795M   1% /run/user/121
tmpfs           795M   48K  795M   1% /run/user/1000
/dev/loop17      89M   89M     0 100% /snap/core/5897
/dev/loop18      35M   35M     0 100% /snap/gtk-common-themes/818
```
- Count the number of CPU
```sh
# cat /proc/cpuinfo | grep model | uniq -c
      1 model		: 58
      1 model name	: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
      1 model		: 58
      1 model name	: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
      1 model		: 58
      1 model name	: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
      1 model		: 58
      1 model name	: Intel(R) Core(TM) i5-3470 CPU @ 3.20GHz
```
# The proc Filesystem
Filesystem `/proc` chứa các tệp ảo chỉ tồn tại trong bộ nhớ. Filesystem này chứa các tập tin và thư mục bắt chước cấu trúc kernel và thông tin cấu hình. Nó không chứa các tập tin thực sự nhưng thông tin hệ thống thời gian chạy (e.g. system memory, devices mounted, hardware configuration, etc). Một số file quan trọng trong `/proc`:

/proc/cpuinfo
/proc/interrupts
/proc/meminfo
/proc/mounts
/proc/partitions
/proc/version
/proc/<process-id-#>
/proc/sys
Filesystem `/proc` rất hữu ích vì thông tin mà nó báo cáo chỉ được thu thập khi cần thiết và không bao giờ cần lưu trữ trên đĩa.

# Hostname</br>
Tên máy chủ xác định máy trong miền.

# cat /etc/hostname
Đặt tên máy chủ mới

# hostname NEW_NAME
Điều này sẽ đặt tên máy chủ của hệ thống thành NEW_NAME. Nó sẽ được kích hoạt ngay lập tức và như vậy cho đến khi hệ thống sẽ được khởi động lại. Trên hệ thống dựa trên Debian, sử dụng file `/etc/hostname` để đọc tên máy chur của hệ thống khi khởi động và thiết lập nó bằng cách sử dụng tập lệnh init `/etc/init.d/hostname.sh`. Tên máy chủ lưu trong file `/etc/hostname` sẽ được bảo toàn khi khởi động lại hệ thống và sẽ được đặt bằng cùng một kịch bản chúng ta đã sử dụng.

Trên các hệ thống dựa trên RedHat, sử dụng tiện ích `hostnamectl` để lấy và đặt tên máy chủ.
```sh
   $ hostnamectl status
   Static hostname: Admin
         Icon name: computer-desktop
           Chassis: desktop
        Machine ID: 304591ce3a874de684364c7055c80767
           Boot ID: 27d9455a649842d08d6aec9491cb236b
  Operating System: Ubuntu 18.04.1 LTS
            Kernel: Linux 4.15.0-42-generic
      Architecture: x86-64
```
