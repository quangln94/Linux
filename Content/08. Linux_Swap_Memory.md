# Linux swap memory</br>
Linux chia RAM thành các vùng nhớ được gọi là pages. Swapping là quá trình trao đổi một page của memmory được sao chép vào một không gian đã được cấu hình sẵn trên hard disk, được gọi là swap space, để tự giải phóng chính nó khỏi memory, tiết kiệm bộ nhớ cho RAM. Dung lượng RAM và các swap space là dung lượng bộ nhớ ảo có sẵn. Swap là cần thiết vì hai lý do sau:</br>
- Khi hệ thống cần nhiều RAM hơn so với các memory có sẵn thì kernel sẽ di chuyển các page ít được sử dụng và swap space, lấy đi bộ nhớ đã được giải phóng để cấp thêm cho tiến trình đang chạy.</br>
- Một số lượng đáng kể các page được các application sử dụng trong quá trình khởi động sau đó sẽ không bao giờ sử dụng nữa</br>

Hệ thống có thể sử dụng swaps trên các pages và giải phóng bộ nhớ cho các ứng dụng khác hoặc thậm chí là bộ đệm đĩa. Tuy nhiên, swaps có một nhược điểm. So với RAM, các đĩa chậm hơn nhiều. Tốc độ của bộ nhớ được đo bằng nano giây, trong khi bộ nhớ trong mili giây, do đó việc truy cập vào đĩa chậm hơn hàng chục nghìn lần so với bộ nhớ RAM. Các hoạt động trao đổi nhiều hơn xảy ra, hệ thống của bạn sẽ chậm hơn. Đôi khi việc trao đổi quá mức tạo ra tắc nghẽn, một tình huống cụ thể xảy ra: một pages được đặt trong swap và sau đó được đưa đến ram rất nhanh và liên tục. Trong những tình huống như vậy, hệ thống phải đấu tranh để tìm bộ nhớ trống và giữ cho các ứng dụng khác nhau chạy cùng một lúc. Trong trường hợp này, thêm nhiều RAM hơn sẽ giúp hệ thống có tính ổn định
So với RAM thì SWAP space trên hard disk có tốc độ chậm hơn nhiều (khoảng 10000 lần) nên càng swapping nhiều thì càng làm các tiến trình bị chậm.</br>
Có hai phương pháp swap space:</br>
- Swap partition: là một phân vùng độc lập dành cho việc swap và không dữ liệu nào được lưu ở đó.</br>
- Swap file: là một file đặc biệt được lưu trong filesystem ở một vị trí tạm thời trên disk, nó sẽ lưu thông tin và các file mà RAM không sử dụng để giải phóng RAM. Để xem cách nó được thực hiện và nơi được đặt, sử dụng lệnh `swapon`
```sh
# swapon -s
Filename                                Type            Size    Used    Priority
/dev/dm-0                               partition       4079612 0       -1
```

Mỗi dòng liệt kê một phân vùng trao đổi riêng biệt được hệ thống sử dụng. Một đặc thù của các swux trên linux là nếu bạn gắn hai (hoặc nhiều hơn) không gian trao đổi (tốt nhất là trên hai thiết bị khác nhau) với cùng một ưu tiên, linux chia các hoạt động trao đổi giữa chúng. Điều này chuyển thành một sự gia tăng đáng chú ý về hiệu suất. Để thêm phân vùng trao đổi vào hệ thống của bạn, trước tiên bạn phải chuẩn bị phân vùng đó.

Thêm swap area dưới dạng file
```sh
dd if=/dev/zero of=/var/swapfile bs=1M count=2048
chmod 600 /var/swapfile
mkswap /var/swapfile
echo /var/swapfile none swap defaults 0 0 | sudo tee -a /etc/fstab
swapon -a
```
Để thêm một swap file:</br>
```sh
sudo dd if=/dev/sda2 of=/var/swapfile bs=1M count=4194304
```
Kiểm tra số phân vùng swap trên hệ thống, dùng lệnh swapon -s:
```sh
$ swapon -s
Filename				Type		Size	Used	Priority
/dev/sda5                              	partition	1046524	0	-1
```

