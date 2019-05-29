# Xem lượng RAM đã dùng trên Linux đúng cách

Để xem lượng RAM đã sử dụng chúng ta có rất nhiều lệnh khác nhau như:
```sh
free -m
```
```sh
cat /proc/meminfo
```
```sh
top
```
```sh
vmstat -s
```
Tuy nhiên, thông số MemFree trả về không phải là lượng bộ nhớ hệ thống còn trống.

Bởi vì Total memory ở Linux được tính bằng Active memory + Inactive memory (không tính Swap). Vấn đề ở chỗ Inactive memory, là vùng nhớ khi ta run 1 process và tắt đi, system sẽ cache lại vùng nhớ này để khi gọi lại process này lần nữa, nó sẽ sử dụng vùng nhớ inactive này ngay lập tức thay vì phải cấp phát lại. Nên khi ta mở càng nhiều process, sau đó tắt đi, inactive memory càng chiếm nhiều(kỹ thuật Disk Caching của Linux)

Khi mở lên 1 process mới, nếu hệ thống thiếu RAM thì Linux sẽ tự động chuyển vùng bộ nhớ Inactive vào Swap và dành toàn bộ memory cho active process. Như vậy, hệ thống không bị quá tải.

Kết luận, dấu hiệu để nhận biết hệ thống có đang thiếu RAM hay không đó là bạn hãy nhìn vào Swap, nếu Swap sử dụng nhiều chứng tỏ đang bị thiếu RAM, lúc này cần nâng cấp bộ nhớ cho VPS/Server.

Trong trường hợp không có swap, các bạn hãy sử dụng lệnh free -h và nhìn vào dòng-/+ buffers/cache để xem hệ thống đang thực sự free bao nhiêu memory.

Đối với CentOS 6


Hệ thống có tổng cộng 996MB RAM, mới dùng 193MB (19.37%) và còn trống 802MB. Swap 2GB chưa được dùng đến.

Đối với CentOS 7


Hệ thống có tổng cộng 488MB RAM, sử dụng thực tế chỉ 125MB. Còn trống 6MB và 357MB (sử dụng làm buff/cache). Swap 1GB chưa được dùng đến. Điều bạn cần quan tâm là lượng RAM trống thực tếmà các ứng dụng có thể sử dụng (available) – 286MB

Như vậy, tín hiệu để bạn lo lắng là khi:

Available memory hoặc free của -/+ buffers/cache tiến đến 0
Mức sử dụng swap gia tăng
Hy vọng, qua bài viết này, các bạn có cái nhìn đúng đắn về tình trạng tải của server cũng như có các quyết định kịp thời trong việc nâng cấp server(nếu cần thiết).
