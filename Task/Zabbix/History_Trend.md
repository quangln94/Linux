# Phân biệt history và trend
## 1. History
History là cơ chế lưu trữ dữ liệu gốc mà Zabbix agent gửi đến cho Zabbix server và lưu trữ chúng trong các table `history`.

Thường thì ta nên set giá trị ngày lưu trữ `history` ở mức thấp nhất có thể, điều đó sẽ giúp tránh việc quá tải cho database với quá nhiều dữ liệu thu thập được.

Lưu ý:
- Các giá trị lâu hơn thời gian quy định trend sẽ bị xóa đi bởi tiến trình `housekeeper`.
- Nếu mà set **history = 0**, thì các trigger chỉ có thể tính toán expression last(), do lúc này `history` chỉ lưu được 1 giá trị vào thời điểm nhận dữ liệu từ Agent và trigger dựa vào đó tính toán.

## 2. Trend
Cứ mỗi giờ thì Zabbix server sẽ thu gom các giá trị từ các table **history** và tính toán giá trị min, trung bình và max cho khung thời gian 1 giờ. Giá trị đơn vị của **trend** là số duy nhất (numeric). Có thể coi **trend** là 1 kỹ thuật nhằm giảm thiểu số lượng dữ liệu lưu trữ của history bằng cách chỉ tính các giá trị min, max, average và tổng (total) giá trị dữ liệu thu thập được. Nhờ đó ta có được các giá trị cần thiết phục vụ cho việc xem biểu đồ của thời gian cũ.

**Trends** thường được set giá trị lưu trữ lâu hơn **history**. Vi dụ: history 14 ngày, trends 1 năm. Dù bạn giữ giá trị **history** số ngày lưu trữ thấp còn **trends** dài hơn thì bạn vẫn hoàn toàn xem được thông tin biểu đồ thời gian cũ do **graph** sẽ sử dụng các thông tin trong table **trends** nhằm hiển thị cho bạn xem.

Lưu ý:
- Các item chuỗi (string) như character, log, text đều không có khái niệm liên quan đến **trends**
- Các giá trị lâu hơn thời gian quy định trends sẽ bị xóa đi bởi tiến trình **housekeeper**.

## 3. Các table trong CSDL của history và trends như sau:

- history - numeric (float)
- history_unit - numerric (unsigned integers)
- history_str - character (up to 255 bytes)
- history_log - log
- hostory_text - text
- trends - numeric (float)
- trends)unit - numeric (unsigned integers)
## Các khuyến nghị đối với việc set các giá trị history và trends:

- Giá trị**history** nên set ngày lưu không nên cao hơn **7** ngày.
- Tránh set các giá trị interval check của các item thấp hơn 60s.
- Thường xuyên kiểm tra

## Tài liệu tham khảo
- https://cuongquach.com/phan-biet-history-va-trends-trong-zabbix.html
