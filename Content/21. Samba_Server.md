# Samba server and Windows file sharing</br>
Samba hoàn toàn là mã nguồn mở chạy trên nền giao thức SMB/CIFS. Nó cho phép hệ thống Microsoft Windows®, Linux, UNIX và các hệ thống khác kết nối với nhau. Samba cho phép Linux/Unix Server xuất hiện dưới dạng Windows Server với các Windows Clients để chia sẻ file và máy in với các máy chạy Windows.</br>
Với samba, người quản trị có thể:

1. Phục vụ cây thư mục và dịch vụ in cho các máy Clients chạy Linux,Unix và Windows.
2. Hỗ trợ duyệt mạng có hoặc không có NetBIOS
3. Xác thực thông tin đăng nhập Domain Windows
4. Cung cấp giải pháp phân giải tên máy chủ WINS Name Server.

Samba là sự kết hợp của smb, nmb, và winbind services.

`smbd` server cung cấp dịch vụ in và chia sẻ dữ liệu cho các máy Windows clients. Nó có trách nhiệm xác thực người dùng, khóa tài nguyên và chia sẻ dữ liệu thông qua giao thức SMB. Port mặc định mà server dùng cho SMB là các cổng TCP 139 và 445.</br>
`nmbd` server có thể hiểu và trả lời các requests từ SMB. Port mặc định của dịch vụ này là UDP 137.</br>
`winbindd` sẽ giải quyết thông tin người dùng tới từ những server chạy Windows. Điều này sẽ làm cho thông tin của các Windows clients có thể được "hiểu" bởi các máy chủ chạy Linux và UNIX. Cả `winbindd` và `smbd` đều đi kèm trong các bản phân phối của Samba. Tuy vậy chúng được kiểm soát riêng biệt với nhau.</br>
## Cài đặt</br>
### Installation</br>
Chúng ta sẽ thiết lập một máy chủ Samba để chia sẻ tệp Linux cho các máy khách Windows. Cài đặt gói Samba, kích hoạt và bắt đầu dịch vụ `smbd` và `nmbd`
```
# yum install samba
# systemctl enable smb
# systemctl enable nmb
# systemctl start smb
# systemctl start nmb
```
Cấu hình samba sử dụng `/etc/samba/smb.conf`</br> 
Backup file config lại đề phòng lỗi
```
# cp /etc/samba/smb.conf /etc/samba/smb.conf.orig
# vi /etc/samba/smb.conf

# =============== Global configuration ===============
[global]
workgroup = WORKGROUP # Windows workgroup name and server description
server string = My SMB Server %v
netbios name = MYSMBSERVER # NetBIOS name as the Linux machine will appear in Windows clients
interfaces = lo ens32 # interfaces where the service is listening: localhost and ens32 interfaces
passdb backend = smbpasswd # users passwords database backend and location
smb passwd file = /etc/samba/smbpasswd
hosts allow = 127. 10.10.10. # permitted hosts to use the Samba server: localhost and all host belonging to 10.10.10.0/24 subnet
max protocol = SMB3 # protocol version
security = user # type of security
printing = bsd # no printing services
printcap name = /dev/null

# =============== Shares configuration ===============
[share1]
comment = Private Documents
path = /samba/admin/data # path of files to share
valid users = admin # users admitted to use the file sharing service
invalid users = user2 user3
guest ok = no # no guest user is admitted
writable = yes # make the share writable as Samba make it as readonly by default
browsable = yes # make the share visible as shared folder

[share2]
comment = Public Documents
path = /samba/user2/data
valid users = user2 admin
guest ok = no
writable = yes
browsable = yes

[share3]
comment = Public Documents
path = /samba/user3/data
valid users = user3 admin
guest ok = no
writable = yes
browsable = yes

[share4]
comment = Public Documents
path = /samba/share4
guest ok = yes
writable = yes
browsable = yes
```
`share1` chỉ được truy cập bởi admin</br>
`share2` được truy cập bởi admin và user2</br>
`share3` thì được truy cập bởi admin và user3</br>
`share4` được truy cập bởi tất cả mọi người.</br>
Kiểm tra cấu hình sử dụng lệnh:
```
testparm
```
Tạo 4 thư mục như trên trên và tạo 3 user: admin, user2, user3.
```sh
mkdir -p /samba/admin/data
mkdir -p /samba/user2/data	
mkdir -p /samba/user3/data
mkdir -p /samba/share4
useradd admin
useradd user2
useradd user3 
```
Lưu ý: Kết nối đến chia sẻ của cùng một máy khách Windows cần sử dụng cùng tên người dùng. Trong trường hợp trên, một máy Windows client có thể truy cập tất cả các "chia sẻ" ở trên dưới dạng "quản trị viên" nhưng không thể truy cập vào "share2" dưới dạng "user2" và truy cập vào "share3" dưới dạng "user3". Nếu máy Windows client cần truy cập với những người dùng khác nhau, thì nó cần phải đăng xuất khỏi người dùng trước và sau đó đăng nhập lại với một người dùng khác. Vì Windows lưu trữ người dùng đăng nhập, nó cần đăng xuất bằng cách sử dụng lệnh: `net use * / delete` từ Windows command shell
```
Microsoft Windows [Versione 10.0.10240]
(c) 2015 Microsoft Corporation. Tutti i diritti sono riservati.
C:\Users\Adriano>net use * /delete
Connessioni remote presenti:
                    \\10.10.10.12\IPC$
Continuando si annulleranno le connessioni.
Continuare questa operazione? (S/N) [N]: S
Esecuzione comando riuscita.
```
Samba sử dụng loại bảo mật khác nhau. Trong trường hợp trên, phương pháp dựa trên cấp độ người dùng (mặc định). Với phương pháp này, mỗi `chia sẻ` được chỉ định người dùng cụ thể có thể truy cập nó. Khi người dùng yêu cầu kết nối với chia sẻ, Samba xác thực bằng cách xác thực tên người dùng và mật khẩu đã cho với người dùng được ủy quyền trong tệp cấu hình và mật khẩu trong cơ sở dữ liệu mật khẩu của máy chủ Samba.</br>
Samba sử dụng các phụ trợ cơ sở dữ liệu khác nhau để lưu trữ mật khẩu người dùng. Đơn giản nhất là lưu trữ mật khẩu trong một tệp có tên `smbpasswd` tương tự như tệp `/etc/passwd`. Thông thường tệp này nằm dưới `/var/lib/samba/private/smbpasswd` nhưng vị trí có thể được thay đổi.</br>
Lệnh `pdbedit` liệt kê cơ sở dữ liệu người dùng Samba
```
# pdbedit -L
admin:1000:
user1:1001:
user2:1002:
user3:1003:
```
Các phương pháp bảo mật khác: bảo mật cấp miền và máy chủ không được chấp nhận trong Samba mới nhất.</br>
Với phụ trợ cơ sở dữ liệu `smbpasswd`, người dùng Samba nên tồn tại như người dùng hợp lệ trong máy Linux. Để bảo mật máy Linux ngăn chặn đăng nhập từ người dùng Samba, bạn nên vô hiệu hóa đăng nhập từ những người dùng này
```
# useradd -d /samba/share user1
# usermod -s /bin/false user1
# cat /etc/passwd | grep user1
user1:x:1003:1002::/samba/share:/sbin/nologin
#
# ssh user1@localhost
user1@localhost's password:
Last login: Tue Sep 15 11:50:08 2015
This account is currently not available.
Connection to localhost closed.
#
# sftp user1@localhost
user1@localhost's password:
subsystem request failed on channel 0
Couldn't read packet: Connection reset by peer
```
Ngoài ra, bạn có thể rời khỏi ssh nhưng nên kiểm tra thư mục chính của người dùng.</br>
## Quyền và thuộc tính tệp</br>
Trong ví dụ trên, chúng ta sẽ chia sẻ các tệp và thư mục Linux cho các máy Windows client. Vì Windows và Linux sử dụng cách tiếp cận khác nhau để cấp quyền và thuộc tính tệp, Samba sẽ đảm nhiệm việc ánh xạ hai cách tiếp cận.</br>
Tất cả các tệp Linux đã đọc, ghi và thực thi các bit cho ba phân loại người dùng: chủ sở hữu (u), nhóm (g) và phần còn lại (o). Mặt khác, Windows có 4 bit chính mà nó sử dụng với bất kỳ tệp nào: chỉ đọc, hệ thống, ẩn và lưu trữ:

- Read-only. Nội dung của tệp có thể được đọc bởi người dùng nhưng không thể ghi vào.
- System. Tập tin này có một mục đích cụ thể theo yêu cầu của hệ điều hành.
- Hidden. Tập tin này đã được đánh dấu là vô hình cho người dùng, trừ khi các hệ điều hành được thiết lập rõ ràng để hiển thị nó.
- Archive. Tập tin này đã được chạm vào kể từ lần sao lưu cuối cùng được thực hiện trên nó.

Không có bit nào để chỉ định rằng một tệp có thể thực thi được do Windows xác định các tệp thực thi bằng cách xem phần mở rộng tệp. Các tệp Windows được lưu trữ trên chia sẻ Linux Samba có các thuộc tính riêng cần được bảo tồn. Samba bảo tồn các bit này bằng cách sử dụng lại các bit cho phép thực thi của tệp Linux, nếu nó được hướng dẫn làm như vậy. Tuy nhiên, ánh xạ các bit này có tác dụng phụ: nếu người dùng Windows lưu trữ tệp trong chia sẻ Samba, ở phía Linux, một số bit thực thi được đặt.</br>
Các tùy chọn Samba quyết định ánh xạ
```
[share]
...
store dos attributes = yes
map archive = yes ;default is yes
map system = yes  ;default is no
map hidden = yes  ;default is no
```
Ba tùy chọn cuối cùng ánh xạ các thuộc tính lưu trữ, hệ thống và ẩn cho chủ sở hữu, nhóm và thế giới thực hiện các bit của tệp, tương ứng. Trong ví dụ trên, các tùy chọn được sử dụng trên cơ sở cho mỗi cổ phần. Đặt chúng trên toàn cầu làm cho chúng trở thành mặc định cho tất cả các chia sẻ. Tùy chọn đầu tiên cũng đảm bảo rằng Samba không thay đổi các bit quyền của Windows.</br>
Lưu ý: Các tùy chọn này có thể được sử dụng nếu hệ thống tệp Linux hỗ trợ các thuộc tính mở rộng và các thuộc tính đó được bật, thường thông qua tùy chọn gắn kết user_xattr trong tệp / etc / fstab. Không giống như ext3 và ext4, hệ thống tệp xfs cho phép tùy chọn user_xattr theo mặc định.</br>
Samba có mặt nạ tạo và các tùy chọn mặt nạ thư mục để giúp tạo tệp và thư mục. Mặt nạ tạo giúp xác định các quyền một tệp hoặc thư mục tại thời điểm nó được tạo. Về phía Linux, bạn có thể kiểm soát những quyền mà tập tin hoặc thư mục có khi nó được tạo. Về phía Windows, bạn cũng có thể vô hiệu hóa các thuộc tính chỉ đọc, lưu trữ, hệ thống và ẩn của một tệp.
```
[share]
...
store dos attributes = yes
map archive = yes            ;default is yes
map system = yes             ;default is no
map hidden = yes             ;default is no
create mask = 0744           ;default is 0744
directory mask = 0755        ;default is 0755
```

Về phía Linux, các tệp và thư mục mới sẽ trông như
```
# ll /samba/share/user1
total 0
-rwxr--r-- 1 user1 samba 0 Sep 15 13:00 mydocument.txt
drwxr-xr-x 2 user1 samba 6 Sep 15 13:00 myfolder
```
Có thể buộc các bit khác nhau với các tùy chọn chế độ tạo lực và chế độ thư mục lực. Với các tùy chọn tạo mặt nạ và tạo mặt nạ thư mục, quản trị viên cho phép các bit quyền được thiết lập bởi người dùng được yêu cầu. Mặt khác, chế độ tạo lực lượng và chế độ thư mục lực sẽ buộc một bit cụ thể được thiết lập, ngay cả khi đó không phải là yêu cầu của người dùng.</br>
Đồng thời, có thể buộc các thuộc tính nhóm và người dùng Linux của một tệp được tạo ở phía Windows bởi người dùng bắt buộc và các tùy chọn nhóm lực lượng.
```
[share]
...
store dos attributes = yes
map archive = yes            ;default is yes
map system = yes             ;default is no
map hidden = yes             ;default is no
create mask = 0744           ;default is 0744
directory mask = 0755        ;default is 0755
force create mode = 0000     ;default is 0000
force directory mode = 0000  ;default is 0000
force user = user1
force group samba
```
Để thư mục `/samba/share4` cho phép mọi người đều truy cập được thì phải đổi user và group sở hữu là nobody
```
chown nobody:nogroup /samba/share4/
```
Giờ hãy thử vào một máy windows rồi gõ `\\192.168.60.130` và nhập username pass của bạn cho từng thư mục muốn vào.</br>
Nếu sử dụng nhiều và thuận tiện hơn, bạn có thể map nó như một ổ của windows để sử dụng.
### Một số lưu ý:</br>
From a Windows machine, just browse the folder and try to create a text file, but you will get an error of permission denied.</br>
Check the permission of the shared folder.
```
ls -l
drwxr-xr-x. 2 root root 6 Jul 17 13:41 shared4
```
To allow access by the anonymous user, set the permissions as follows:
```
cd /samba
chmod -R 0755 shared4/
chown -R nobody:nobody shared4/
ls -l shared4/
total 0
drwxr-xr-x. 2 nobody nobody 6 Jul 17 13:41 shared4
```
Further, we need to allow the SELinux for the samba configuration as follows:
```
chcon -t samba_share_t share4/
```
Now the anonymous user can browse & create the folder contents.</br>
 You can cross check the content at the server also.
```
ls -l share4/
total 0
-rwxr--r--. 1 nobody nobody 0 Jul 17 16:05 anonymous.txt
```
### Secured samba server
Therefore, I will create a group `smbgrp` & user `srijan` to access the samba server with proper authentication.
```
groupadd smbgrp
useradd srijan -G smbgrp
smbpasswd -a srijan
smbpasswd -a srijan
New SMB password:<--yoursambapassword
Retype new SMB password:<--yoursambapassword
Added user srijan.
```   
Now create a folder with the name secured in the /samba folder and give permissions like this:
```
mkdir -p /samba/secured
```
Again we will have to allow to listen through SELinux:
```
cd /samba
chmod -R 0777 secured/
chcon -t samba_share_t secured/
```
Again edit the configuration file as :
```
vi /etc/samba/smb.conf
[...]
[secured]
 path = /samba/secured
 valid users = @smbgrp
 guest ok = no
 writable = yes
 browsable = yes
```
```
systemctl restart smb.service
systemctl restart nmb.service
```
Further, check the settings as follows:
```
testparm
Load smb config files from /etc/samba/smb.conf
rlimit_max: increasing rlimit_max (1024) to minimum Windows limit (16384)
Processing section "[Anonymous]"
Processing section "[secured]"
Loaded services file OK.
Server role: ROLE_STANDALONE
Press enter to see a dump of your service definitions <--ENTER
```
```
[global]
	netbios name = CENTOS
	server string = Samba Server %v
	map to guest = Bad User
	dns proxy = No
	idmap config * : backend = tdb

[Anonymous]
	path = /samba/anonymous
	read only = No
	guest ok = Yes

[secured]
	path = /samba/secured
	valid users = @smbgrp
	read only = No
[root@server1 samba]# 
```
Now at windows machine check the folder now with the proper credentials</br>
You will again face the issue of permissions to give write permission to the user srijan do:
```
cd /samba
chown -R srijan:smbgrp secured/
```
Now samba users have the permissions to write into the folder. Cheers, you have done with samba server in CentOS 7
