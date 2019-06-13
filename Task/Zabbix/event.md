# I. Event
Có một số loại `event` được tạo trong Zabbix:

- trigger events - bất cứ khi nào 1 trigger thay đổi trạng thái của nó ( OK→PROBLEM→OK )
- discovery events - khi máy chủ hoặc dịch vụ được phát hiện
- auto registration events - khi 1 agent được active hoặc được đăng ký tự động bởi server
- internal events - khi một item/low-level discovery rule không được hỗ trợ hoặc trigger đi vào trạng thái unknown


Internal events được hỗ trợ bắt đầu từ Zabbix 2.2.
Event được time-stamped và có thể là cơ sở của các hành động như gửi e-mail thông báo, v.v.
