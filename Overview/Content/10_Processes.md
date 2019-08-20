# Linux processes</br>
Một `processes` đơn giản là một thể hiện của một hay nhiều luồng(threads) liên quan được thực hiện trên cùng một máy. Nó không giống như một chương trình hoặc một lệnh; một chương trình duy nhất thực sự có thể bắt đầu một số tiến trình cùng một lúc. Một số tiến trình độc lập với nhau và những quy trình khác có liên quan. Lỗi của một tiến trình có thể hoặc không thể ảnh hưởng đến các tiến trình khác đang chạy trên hệ thống. Các tiến trình sử dụng nhiều tài nguyên hệ thống, như bộ nhớ, CPU và các thiết bị ngoại vi như máy in và màn hình. Hệ điều hành(đặc biệt là kernel) chịu trách nhiệm phân bổ một phần thích hợp các tài nguyên này cho mỗi tiến trình và đảm bảo sử dụng tối ưu tổng thể.</br>
Một terminal window là một tiến trình chạy miễn là cần thiết. Nó cho phép người dùng thực thi các chương trình và truy cập tài nguyên trong môi trường tương tác. Bạn cũng có thể chạy các chương trình trong nền, điều đó có nghĩa là chúng bị tách ra khỏi shell. Các tiến  trình có thể có nhiều loại khác nhau tùy theo nhiệm vụ đang được thực hiện.</br>

|Type|Description|
|----|-----------|
|Interactive|Cần phải được bắt đầu bởi người dùng, tại một dòng lệnh hoặc thông qua giao diện đồ họa như biểu tượng hoặc lựa chọn menu.|
|Batch|Các tiến trình tự động được lên lịch từ đó và sau đó ngắt kết nối khỏi thiết bị đầu cuối. Các tác vụ này được xếp hàng và hoạt động trên cơ sở FIFO (First In, First Out).|
|Daemons|Tiến trình máy chủ chạy liên tục. Nhiều thứ được khởi chạy trong quá trình khởi động hệ thống và sau đó chờ người dùng hoặc yêu cầu hệ thống chỉ ra rằng dịch vụ của họ là bắt buộc.|
|Threads|Các tiến trình nhẹ. Đây là các tác vụ chạy dưới tiến trình chính, chia sẻ bộ nhớ và các tài nguyên khác, nhưng được hệ thống lên lịch và chạy trên cơ sở cá nhân.|
|Kernel Threads|Các tác vụ Kernel mà người dùng không bắt đầu cũng không chấm dứt và có ít quyền kiểm soát. Chúng có thể thực hiện các hành động như di chuyển một luồng từ CPU này sang CPU khác hoặc đảm bảo các hoạt động input/output vào đĩa được hoàn thành.|

Khi một tiến trình ở trạng thái đang chạy, điều đó có nghĩa là nó hiện đang thực thi các hướng dẫn trên CPU hoặc đang chờ chia sẻ (hoặc lát thời gian) để nó có thể chạy. Một thường trình nhân quan trọng được gọi là bộ lập lịch liên tục chuyển các tiến trình vào và ra khỏi CPU, chia sẻ thời gian theo mức độ ưu tiên tương đối, cần bao nhiêu thời gian và bao nhiêu đã được cấp cho một tác vụ. Một Kernel quan trọng hàng ngày được gọi là bộ lập lịch liên tục chuyển các tiến trình vào và ra khỏi CPU, chia sẻ thời gian theo mức độ ưu tiên tương đối, cần bao nhiêu thời gian và bao nhiêu đã được cấp cho một nhiệm vụ. Tất cả các tiến trình trong trạng thái này nằm trên một hàng đợi chạy và trên một máy tính có nhiều CPU có một hàng đợi chạy trên mỗi hàng. Đôi khi các quá trình đi vào trạng thái ngủ, thường là khi chúng đang chờ điều gì đó xảy ra trước khi chúng có thể tiếp tục, có lẽ để người dùng gõ một cái gì đó. Trong điều kiện này, một tiến trình đang ngồi trong một hàng đợi. Có một số trạng thái tiến trình ít thường xuyên hơn, đặc biệt là khi một tiến trình đang kết thúc. Đôi khi một tiến trình con hoàn thành nhưng quá trình cha mẹ của nó không được hỏi về trạng thái của nó. Quá trình như vậy được cho là ở trạng thái zombie; nó không thực sự sống nhưng vẫn xuất hiện trong danh sách các tiến trình của hệ thống.</br>
Tại bất kỳ thời điểm nào, luôn có nhiều tiến trình được thực thi. Hệ điều hành theo dõi chúng bằng cách gán ID cho mỗi trình hoặc số PID duy nhất. PID được sử dụng để theo dõi trạng thái tiến trình, cpu sử dụng, bộ nhớ sử dụng, chính xác nơi tài nguyên được đặt trong bộ nhớ và các đặc điểm khác. Các bộ vi xử lý mới thường được chỉ định theo thứ tự tăng dần khi các tiến trình được sinh ra. Do đó, PID 1 biểu thị tiến trình init (tiến trình khởi tạo) và các tiến trình thành công dần dần được gán số cao hơn.</br>
Tại bất kỳ thời điểm nào, nhiều tiến trình đang chạy trên hệ thống. Tuy nhiên, CPU thực sự chỉ có thể chứa một nhiệm vụ tại một thời điểm, giống như một chiếc xe có thể chỉ có một người lái xe tại một thời điểm. Một số quy trình quan trọng hơn các quy trình khác vì vậy Linux cho phép bạn thiết lập và thao tác ưu tiên tiến trình. Các quy trình ưu tiên cao hơn được cấp nhiều thời gian hơn trên bộ xử lý. Mức độ ưu tiên cho một quy trình có thể được đặt bằng cách chỉ định một giá trị đẹp hoặc độ đẹp cho quy trình. Giá trị tốt đẹp càng thấp, mức độ ưu tiên càng cao. Giá trị thấp được gán cho các quy trình quan trọng, trong khi giá trị cao được gán cho các quy trình có thể chờ lâu hơn. Một quy trình có giá trị cao đẹp đơn giản chỉ cho phép các quy trình khác được thực hiện trước. Trong Linux, giá trị đẹp là -20 đại diện cho mức ưu tiên cao nhất và 19 đại diện cho mức thấp nhất. Bạn cũng có thể chỉ định mức độ ưu tiên theo thời gian thực cho các tác vụ nhạy cảm với thời gian, chẳng hạn như điều khiển máy hoặc thu thập dữ liệu đến. Đây chỉ là một ưu tiên rất cao và không bị nhầm lẫn với cái được gọi là thời gian thực cứng khác biệt về mặt khái niệm và có nhiều việc phải làm để đảm bảo một công việc được hoàn thành trong một cửa sổ thời gian được xác định rõ.

Hệ điều hành sẽ theo dõi các tiến trình thông qua một ID có 5 chứ số mà được biết như là**pid** hay **process ID**. Mỗi tiến trình có duy nhất một **pid**.</br>
Tại cùng một lúc không thể có 2 tiến trình có cùng **pid**.</br>
Khi bạn bắt đầu một tiến trình (đơn giản là chạy một lệnh), có 2 các để chạy nó:</br>
* Foreground Process: Mặc định khi bắt đầu các tiến trình là Foreground, nhận input từ bàn phím và output tới màn hình. Trong khi chương trình chạy thì không thể chạy bất cứ tiến trình nào khác
* Background Process: chạy mà không kết nối với bàn phím của bạn. Lợi thế là khi đó đang chạy tiến trình background vẫn có thể chạy các tiến trình khác.

Để bắt đầu một tiến trình Background thì thêm dấu `&` vào cuối câu lệnh. Ví dụ:</br>
```sh
$ ls &
```
Ở đây lệnh `ls` muốn có một đầu vào, nó tiến vào trạng thái dừng tới khi bạn chuyển nó vào trong foreground.</br>
Liệt kê các tiến trình đang chạy</br>
```sh
$ ps
  PID TTY          TIME CMD
 7869 pts/1    00:00:00 bash
 8197 pts/1    00:00:00 ps
[1]+  Done                    ls --color=auto
$ ps -f
UID        PID  PPID  C STIME TTY          TIME CMD
ngocqua+  7869  7860  0 23:12 pts/1    00:00:00 bash
ngocqua+ 10749  7869  0 23:23 pts/1    00:00:00 ps -f
[1]+  Done                    ls --color=auto
```
Trong đó:

|Thông số|Miêu tả|
|--|--|
|UID|ID người sử dụng mà tiến trình này thuộc sở hữu (người chạy nó).|
|PID|Process ID.|
|PPID|Process ID gốc (ID của tiến trình mà bắt đầu nó).|
|C|CPU sử dụng của tiến trình.|
|STIME|Thời gian bắt đầu tiến trình.|
|TTY|Kiểu terminal liên kết với tiến trình.|
|TIME|Thời gian CPU bị sử dụng bởi tiến trình.|
|CMD|Lệnh mà bắt đầu tiến trình này.|

Một số lệnh với `ps`:</br>
* `ps -ef` – Liệt kê process đang chạy bây giờ. (Một command tương tự là ps aux)
* `ps -f -u user1,user2` – Sẽ hiển thị tất cả process dựa rên UID (user id hoặc username).
* `ps -f –pid ID` – Hiển thị tất cả processes dựa trên process ID (pid). Điền PID hoặc PPID thay vào chỗ id. Có thể được dùng với PPID để lọc process dựa trên parent ID.
* `ps -C command/name` – Lọc Processes dựa trên tên của nó hoặc command
* `ps aux –sort=-pcpu,+pmem` – Hiển thị process đang dùng nhiều tài nguyên nhất của CPU.
* `ps -e -o pid,uname,pcpu,pmem,comm` – Được dùng để lọc column được chỉ định.
* `ps -e -o pid,comm,etime` – Việc này sẽ hiển thị thời gian đã được dùng của process.

Thêm một chút về [quản lý tiến trình](https://studylinux.wordpress.com/2012/03/02/10-cau-l%E1%BB%87nh-d%E1%BB%83-qu%E1%BA%A3n-ly-ti%E1%BA%BFn-trinh-tren-linux-b%E1%BA%B1ng-terminal/)</br>
Dừng tiến trình</br>
```sh
kill <pid>
hoặc
killall <pname>
```
Nếu tiến trình này quá cứng đầu thì hay sử dụng `kill -p <pid>`

# Running processes</br>
Lệnh `ps` cung cấp thông tin về các tiến trình hiện đang chạy, được khóa bởi PID. Nếu bạn muốn cập nhật lặp lại trạng thái này, bạn có thể sử dụng lệnh `top` cùng hoặc các biến thể thường được cài đặt như `htop` hoặc `atop` từ dòng lệnh. Lệnh `ps` có nhiều tùy chọn để chỉ định chính xác các nhiệm vụ cần kiểm tra, thông tin nào sẽ hiển thị về chúng và chính xác định dạng đầu ra nào sẽ được sử dụng.</br>
Không có tùy chọn `ps` sẽ hiển thị tất cả các tiến trình đang chạy trong shell hiện tại. Bạn có thể sử dụng `ps -u` để hiển thị thông tin của các tiến trình cho tên người dùng được chỉ định. Lệnh `ps -ef` hiển thị tất cả các tiến trình trong hệ thống một cách chi tiết. Lệnh `ps -eLf` tiến thêm một bước và hiển thị một dòng thông tin cho mỗi luồng (một quá trình có thể chứa nhiều luồng).
```sh
# ps -u user1
  PID TTY          TIME CMD
  847 ?        00:00:00 sshd
  848 pts/2    00:00:00 bash
 1070 ?        00:00:00 sshd
 1071 pts/3    00:00:00 bash
 6475 pts/3    00:00:00 top
 ```
Lệnh `pstree` hiển thị các quy trình đang chạy trên hệ thống dưới dạng sơ đồ cây cho thấy mối quan hệ giữa một quy trình và quy trình mẹ của nó và bất kỳ quy trình nào khác mà nó tạo ra. Các mục lặp lại của một quá trình không được hiển thị và các luồng được hiển thị trong dấu ngoặc nhọn.
```sh
# yum install -y psmisc
# pstree
# systemd─┬─agetty
          ├─auditd───{auditd}
          ├─avahi-daemon───avahi-daemon
          ├─crond
          ├─dbus-daemon───{dbus-daemon}
          ├─firewalld───{firewalld}
          ├─iprdump
          ├─iprinit
          ├─iprupdate
          ├─lvmetad
          ├─master─┬─pickup
          │        └─qmgr
          ├─polkitd───5*[{polkitd}]
          ├─rsyslogd───2*[{rsyslogd}]
          ├─sshd───sshd───bash───pstree
          ├─systemd-journal
          ├─systemd-logind
          ├─systemd-udevd
          └─tuned───4*[{tuned}]
```
Để chấm dứt một quá trình, bạn có thể gõ `kill -SIGKILL <pid>` hoặc `kill -9 <pid>`. Tuy nhiên, lưu ý, bạn chỉ có thể giết các quy trình của riêng mình: những quy trình thuộc về người dùng khác sẽ vượt quá giới hạn trừ khi bạn root.</br>
Mặc dù chế độ xem tĩnh về những gì hệ thống đang làm là hữu ích, việc theo dõi hiệu suất hệ thống trực tiếp theo thời gian cũng có giá trị. Một tùy chọn sẽ là chạy lệnh `ps` trong khoảng thời gian đều đặn. Một cách khác tốt hơn là sử dụng hàng đầu để nhận được cập nhật theo thời gian thực liên tục (cứ sau hai giây theo mặc định). Lệnh trên cùng nêu rõ các quá trình đang tiêu tốn nhiều chu kỳ và bộ nhớ CPU nhất.	  
```sh
top - 15:40:31 up 4 days,  2:13,  1 user,  load average: 0.77, 0.66, 0.45
Tasks: 244 total,   2 running, 241 sleeping,   0 stopped,   1 zombie
%Cpu(s):  6.5 us,  1.3 sy,  0.0 ni, 88.3 id,  3.7 wa,  0.0 hi,  0.2 si,  0.0 st
KiB Mem:   3801380 total,  3642652 used,   158728 free,       24 buffers
KiB Swap:  4079612 total,     3072 used,  4076540 free.   326620 cached Mem

  PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 1367 glance    20   0  351800  54996   5928 S   1.3  1.4  64:32.28 glance-api
 1373 nova      20   0  383444  73304   6768 S   1.3  1.9  68:25.51 nova-api
 1365 keystone  20   0  353108  58340   6192 S   1.0  1.5  67:16.01 keystone-all
 1369 cinder    20   0  365404  60120   6632 S   1.0  1.6  68:38.74 cinder-api
 1371 cinder    20   0  287924  30584   4924 S   1.0  0.8  68:08.01 cinder-volume
 1380 nova      20   0  348120  46568   6580 S   1.0  1.2  68:19.02 nova-conductor
 1408 ceilome+  20   0  254312  20560   4260 R   1.0  0.5  64:28.69 ceilometer-agen
...
```
Dòng đầu tiên của `top` hiển thị một bản tóm tắt nhanh chóng về những gì đang xảy ra trong hệ thống bao gồm:</br>
- 1. Hệ thống đã hoạt động được bao lâu rồi</br>
- 2. Có bao nhiêu người dùng đang đăng nhập</br>
- 3. Trung bình tải là gì

Trung bình tải xác định mức làm việc của hệ thống. Trung bình tải của 1.00 trên mỗi CPU cho biết hệ thống được đăng ký đầy đủ, nhưng không bị quá tải. Nếu trung bình tải vượt quá giá trị này, nó chỉ ra rằng các quy trình đang cạnh tranh về thời gian của CPU. Nếu trung bình tải rất cao, nó có thể chỉ ra rằng hệ thống đang gặp sự cố, chẳng hạn như quá trình chạy trốn (một quá trình ở trạng thái không phản hồi).

Dòng thứ hai của `top` hiển thị tổng số tiến trình, số lượng tiến trình chạy, ngủ, dừng và zombie. So sánh số lượng các tiến trình đang chạy với trung bình tải giúp xác định xem hệ thống đã đạt đến công suất hay có lẽ một người dùng cụ thể đang chạy quá nhiều tiến trình. Các tiến trình dừng nên được kiểm tra để xem mọi thứ có chạy đúng không.

Dòng thứ ba của `top` cho biết thời gian CPU được phân chia giữa user(us) và kernel(sy) bằng cách hiển thị phần trăm thời gian CPU được sử dụng cho mỗi lần. Tỷ lệ phần trăm công việc user đang chạy ở mức ưu tiên thấp hơn(ni) sau đó được liệt kê. Chế độ không tải (id) nên ở mức thấp nếu trung bình tải cao và ngược lại. Tỷ lệ phần trăm công việc đang chờ (wa) cho I/O được liệt kê. Ngắt bao gồm tỷ lệ phần cứng(hi) so với ngắt phần mềm(si). Steal time(st) thường được sử dụng với các máy ảo, có một số thời gian CPU nhàn rỗi của nó dành cho các mục đích sử dụng khác.</br>

Dòng thứ tư và thứ năm của `top` cho biết mức sử dụng bộ nhớ, được chia thành hai loại:
- 1. Bộ nhớ vật lý (RAM) - hiển thị trên dòng 4.
- 2. Hoán đổi không gian - hiển thị trên dòng 5.
- 3. Cả hai loại đều hiển thị tổng bộ nhớ, bộ nhớ đã sử dụng và không gian trống.

Bạn cần theo dõi việc sử dụng bộ nhớ rất cẩn thận để đảm bảo hiệu năng hệ thống tốt. Khi bộ nhớ vật lý cạn kiệt, hệ thống bắt đầu sử dụng không gian trao đổi dưới dạng nhóm bộ nhớ mở rộng và do việc truy cập đĩa chậm hơn nhiều so với truy cập bộ nhớ, điều này sẽ ảnh hưởng tiêu cực đến hiệu suất hệ thống. Nếu hệ thống bắt đầu sử dụng trao đổi thường xuyên, bạn có thể thêm nhiều không gian trao đổi. Tuy nhiên, thêm bộ nhớ vật lý cũng nên được xem xét.

Mỗi dòng trong danh sách tiến trình của đầu ra `top` hiển thị thông tin về một tiến trình. Theo mặc định, các tiến trình được sắp xếp theo mức sử dụng CPU cao nhất. Thông tin sau đây về mỗi quy trình được hiển thị:
- Số nhận dạng quá trình (PID)
- Chủ sở hữu quy trình (USER)
- Ưu tiên (PR) và giá trị tốt đẹp (NI)
- Ảo (VIRT), vật lý (RES) và bộ nhớ dùng chung (SHR)
- Trạng thái (S)
- Tỷ lệ phần trăm của CPU (% CPU) và bộ nhớ (% MEM) được sử dụng
- Thời gian thực hiện (TIME +)
- Lệnh (COMMAND)

Để kiểm soát sức khỏe của một hệ thống, trước tiên phải kiểm tra tải trung bình của hệ thống. Giả sử hệ thống của chúng tôi là một hệ thống CPU đơn, 0.25 có nghĩa là trung bình trong một phút qua, hệ thống đã được sử dụng 25%. 0.12 ở vị trí tiếp theo có nghĩa là trung bình trong 5 phút qua, hệ thống đã được sử dụng 12%; và 0.15 ở vị trí cuối cùng có nghĩa là trung bình trong 15 phút qua, hệ thống đã được sử dụng 15%. Nếu chúng ta thấy giá trị 1.00 ở vị trí thứ hai, điều đó có nghĩa là hệ thống CPU đơn được sử dụng 100%, trung bình trong 5 phút qua; Điều này là tốt nếu chúng ta muốn sử dụng đầy đủ một hệ thống. Giá trị trên 1.00 cho một hệ thống CPU đơn ngụ ý rằng hệ thống đã được sử dụng quá mức: có nhiều quy trình cần CPU hơn CPU có sẵn. Nếu chúng ta có nhiều CPU, giả sử hệ thống bốn CPU, chúng ta sẽ chia số lượng trung bình tải cho số lượng CPU. Trong trường hợp này, ví dụ, nhìn thấy trung bình tải 1 phút là 4.00 ngụ ý rằng toàn bộ hệ thống được sử dụng 100% (4.00/4) trong phút cuối. Tăng ngắn hạn thường không phải là một vấn đề. Một đỉnh cao mà bạn thấy có khả năng là một sự bùng nổ của hoạt động, không phải là một cấp độ mới. Ví dụ, khi khởi động, nhiều quá trình bắt đầu và sau đó hoạt động lắng xuống. Nếu một đỉnh cao được nhìn thấy trong trung bình tải 5 và 15 phút, nó có thể là nguyên nhân gây lo ngại.

# Background and foreground processes</br>
Linux hỗ trợ xử lý công việc Background và foreground processes. Các công việc foreground processes chạy trực tiếp từ shell và khi một công việc background trước đang chạy, các công việc khác cần chờ truy cập shell cho đến khi hoàn thành. Điều này là tốt khi công việc hoàn thành nhanh chóng. Nhưng điều này có thể có tác động bất lợi nếu công việc hiện tại sẽ mất nhiều thời gian để hoàn thành. Trong những trường hợp như vậy, bạn có thể chạy công việc trong background và giải phóng shell cho các tác vụ khác. Công việc background sẽ được thực hiện ở mức ưu tiên thấp hơn, do đó, sẽ cho phép thực hiện trơn tru các tác vụ tương tác và bạn có thể nhập các lệnh khác trong terminal window trong khi công việc background đang chạy. Theo mặc định, tất cả các công việc được thực hiện ở background trước. Do đó bạn có thể đặt một công việc trong nền:
```sh
# updatedb &
[1] 7437
# jobs
[1]+  Done                    updatedb
#
```
## Scheduling processes</br>
Chương trình tiện ích được sử dụng để thực thi bất kỳ lệnh không tương tác nào tại một thời điểm nhất định. Các công việc được chọn bởi dịch vụ `atd`.
```sh
# yum install -y at
# systemctl start atd
# systemctl enable atd
# at now + 5 minutes
at> pstree
at> <EOT>
job 9 at Sat Feb 21 16:28:00 2015
```
Lệnh `atq` được sử dụng để liệt kê các công việc được lên lịch bởi lênh `at`.
```sh
# atq
9       Sat Feb 21 16:28:00 2015 a root
```
Tiện ích `cron` là một chương trình tiện ích lập lịch dựa trên thời gian. Nó có thể khởi chạy các công việc background thường lệ vào thời gian và ngày cụ thể trên cơ sở đang diễn ra. `cron` được điều khiển bởi một tệp cấu hình có tên `/etc/crontab` chứa các lệnh shell khác nhau cần được chạy vào thời gian được lên lịch chính xác. Có cả tệp `crontab` trên toàn hệ thống và các tệp dựa trên người dùng cá nhân. Mỗi dòng của tệp `crontab` đại diện cho một công việc và bao gồm một biểu thức, theo sau là một lệnh shell để thực thi. Lệnh `crontab -e` sẽ mở trình soạn thảo `crontab` để chỉnh sửa các công việc hiện có hoặc để tạo các công việc mới. Mỗi dòng của tệp `crontab` sẽ chứa 6 trường:
	1. MIN	Minutes	0 to 59
	2. HOUR	Hour field	0 to 23
	3. DOM	Day of Month	1-31
	4. MON	Month field	1-12
	5. DOW	Day Of Week	0-6 (0 = Sunday)
	6. CMD	Command	Any command to be executed

Ví dụ: Nhập
```sh
* * * * * /usr/local/bin/execute/this/script.sh
```
sẽ sắp xếp một công việc để thực hiện kịch bản mỗi phút của mỗi giờ của mỗi ngày trong tháng, và mỗi tháng và mỗi ngày trong tuần. Mục nhập
```sh
30 08 10 06 * /home/sysadmin/full-backup
```
sẽ lên lịch sao lưu toàn bộ vào 8h30, ngày 10 tháng 6 bất kể ngày trong tuần.

# Delaying processes</br>
Đôi khi một lệnh hoặc công việc phải bị trì hoãn hoặc bị đình chỉ. Giả sử, ví dụ, một ứng dụng đã đọc và xử lý nội dung của tệp dữ liệu và sau đó cần lưu báo cáo trên hệ thống sao lưu. Nếu hệ thống sao lưu hiện đang bận hoặc không có sẵn, ứng dụng có thể được thực hiện để ngủ cho đến khi nó có thể hoàn thành công việc. Một sự chậm trễ như vậy có thể là gắn thiết bị dự phòng và chuẩn bị cho nó viết. Lệnh ngủ tạm dừng thực thi trong ít nhất khoảng thời gian đã chỉ định, có thể được cung cấp dưới dạng số giây (mặc định), phút, giờ hoặc ngày. Sau khi thời gian đó trôi qua, việc thực hiện sẽ tiếp tục.
```sh
# vi script.sh
#!/bin/bash
echo "The system will go to sleep fo 30 seconds ..."
sleep 15
echo "The system is awaked"
# chmod u+x script.sh
# ./script.sh
The system will go to sleep fo 30 seconds ...
The system is awaked
#
```
# Command top</br>
Lệnh `top` hiển thị các thông tin để có thể giám sát các thông số CPU, RAM,... các tiến trình đang hoặt động trên hệ thống
```sh
top - 09:28:52 up 154 days, 23:04,  2 users,  load average: 0.00, 0.00, 0.00
Tasks: 113 total,   1 running, 112 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.3 us,  0.0 sy,  0.0 ni, 99.7 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem :  1014648 total,   204156 free,    65596 used,   744896 buff/cache
KiB Swap:        0 total,        0 free,        0 used.   727912 avail Mem 

  PID USER      PR  NI    VIRT    RES    SHR S %CPU %MEM     TIME+ COMMAND                        
    1 root      20   0  185436   5344   3272 S  0.0  0.5   0:42.19 systemd                        
    2 root      20   0       0      0      0 S  0.0  0.0   0:00.00 kthreadd                       
    3 root      20   0       0      0      0 S  0.0  0.0   0:16.85 ksoftirqd/0                    
    5 root       0 -20       0      0      0 S  0.0  0.0   0:00.00 kworker/0:0H                   
    7 root      20   0       0      0      0 S  0.0  0.0   0:10.29 rcu_sched                      
    8 root      20   0       0      0      0 S  0.0  0.0   0:00.00 rcu_bh  
```
Command `pstree` hiển thị các tiến trình đang chạy trên hệ thống dưới dạng một sơ đồ cây thể hiện mối quan hệ của các tiến trình con và tiến trình cha cùng toàn bộ các tiến trình khác mà nó tạo ra. Các luồng được thể hiện bằng dấu ngoặc nhọn
```sh
$ pstree
systemd─┬─accounts-daemon─┬─{gdbus}
        │                 └─{gmain}
        ├─acpid
        ├─2*[agetty]
        ├─atd
        ├─cron
        ├─dbus-daemon
        ├─2*[dhclient]
        ├─2*[iscsid]
        ├─lvmetad
        ├─lxcfs───10*[{lxcfs}]
        ├─mdadm
        ├─polkitd─┬─{gdbus}
        │         └─{gmain}
        ├─rsyslogd─┬─{in:imklog}
        │          ├─{in:imuxsock}
        │          └─{rs:main Q:Reg}
        ├─snapd───6*[{snapd}]
        ├─sshd─┬─sshd───sshd───bash───pstree
        │      └─sshd───sshd───bash───sudo───bash───su───bash
        ├─systemd───(sd-pam)
        ├─systemd-journal
        ├─systemd-logind
        └─systemd-udevd
```
# Scheduling processes
Lệnh `at` được sử dụng để thực thi 1 chương trình được chỉ định thời gian cụ thể, cần cài đặt `atd` để sử dụng. Trên Ubuntu 16 đã được cài đặt mặc định.

Lệnh `atq`  được sử dụng để liệt kê danh sách các job đang được đặt lịch bởi command `at`

Tiền ích `cron` là một chương trình lập lịch dựa trên thời gian. Cron được định hướng bởi một file câu hính là `/etc/crontab` chưa các lệnh shell khác nhau cần chạy vào đứng thời điểm đã được lên lịch. Mỗi dòng trong file này đại diện cho một công việc. Lệnh `crontab -e` sẽ mở crontab editor để chỉnh sửa hoặc thêm các jobs mới. Mỗi dòng sẽ gồm 6 dòng.

* MIN minutes 0-59
* HOUR Hour field 0-23
* DOM Day of month 1-31
* MON	Month field	1-12
* DOW	Day Of Week	0-6 (0 = Sunday)
* CMD	Command	bất kỳ một command nào được thực thi

Ví dụ 

	* * * * * /usr/local/bin/execute/this/script.sh

Lệnh trên nghĩa là thực hiện lệnh mỗi phút một lần.

	30 08 10 06 * /home/sysadmin/full-backup

sẽ đặt lịch cho full-backup lúc 8h30 ngày 10 tháng 6 không quan tâm là ngày nào trong tuần

### Delaying processes

Khi có một công việc nào đó cần trì hoãn hoặc tạm dùng thì ta có thể sử dụng lệnh `sleep` sẽ dùng lệnh thực thi trong một thời gian cụ thể rồi chạy tiếp.

```sh
$ cat script.sh
#!/bin/bash
echo "The system will go to sleep fo 30 seconds ..."
sleep 15
echo "The system is awaked"
$ chmod u+x script.sh
$ ./script.sh
The system will go to sleep fo 30 seconds ...
The system is awaked
```

Tổng quan về sự chuyển đổi giữa các tiến trình

<img src = "img/1.png">
