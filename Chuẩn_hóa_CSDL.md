# Chuẩn hóa trong cơ sở dữ liệu
## Chuẩn hóa là gì ?
Chuẩn hóa là để giúp cho việc tổ chức dữ liệu trong cơ sở dữ liệu một cách hiệu quả. Có hai mục đích chính để chuẩn hóa dữ liệu:</br>
Giảm lượng dữ liệu dư thừa (ví dụ như lưu trữ cùng một dữ liệu trong 1 bảng)</br>
Đảm bảo độc lập dữ liệu (dữ liệu liên quan đặt trong cùng 1 bảng) Cả 2 mục đích trên đều giúp giảm thiểu không gian sử dụng trong cơ sở dữ liệu và đảm bảo dữ liệu được lưu trữ một cách logic.
## Mục đích của chuẩn hóa cơ sở dữ liệu
- Giảm thiểu dư thừa dữ liệu
- Loại bỏ các bất thường khi cập nhật cơ sở dữ liệu
*Nhưng chuẩn hoá làm tăng thời gian truy vấn.*
## Các Chuẩn thông thường
Chuẩn hoá là quá trình tách bảng (phân rã) thành các bảng nhỏ hơn dựa vào các phụ thuộc hàm. Các dạng chuẩn là các chỉ dẫn để thiết kế các bảng trong CSDL.</br>
Cộng đồng những người phát triển cở sở dữ liệu đã đưa ra 5 chuẩn được đánh số từ 1 (chuẩn 1 hoặc 1NF-Normal form) đến 5 (chuẩn 5 hoặc 5NF). Trong thực tế làm việc, chúng ta sẽ thường xuyên gặp 1NF, 2NF, 3NF và 4NF. Tuy nhiên, chuẩn 5 gần như là không gặp nên sẽ không bàn luận trong bài viết này.
### Dạng chuẩn 1NF
Ví dụ 1 bảng chưa chuẩn hóa: Bảng có 3 khóa chính là `customer_id`, `order_id` và `product_id`.
<img src=https://i.imgur.com/Gm5KXyJ.png>

Bảng dữ liệu này vi phạm cả điều kiện của chuẩn 1NF vì: `address` chứa các giá trị trùng lặp, hơn thế nữa, giá trị `address` trong từng hàng không phải là đơn trị (chỉ có 1 giá trị), thêm vào đó, thuộc tính `total_amount` hoàn toàn có thể tính toán được bằng cách `quantity * unit_price`, không nhất thiết phải đưa vào bảng, gây ra dư thừa dữ liệu. Qua nhận xét trên, ta có thể hình dung ra **3 điều kiện** cần phải tuân theo đó là:
- Các thuộc tính của bảng phải là nguyên tố
- Giá trị của các thuộc tính trên các hàng phải là đơn trị, không chứa nhóm lặp
- Không có một thuộc tính nào có giá trị có thể tính toán được từ một thuộc tính khác

Từ đó, ta có thể thiết kế lại bảng dữ liệu trên như sau:

- Tách các thuộc tính lặp trong bảng như: `customer_name`, `phone` ra thành một bảng mới là `customers`
- Tách `address` thành một bảng riêng có khóa là `customer_id` để biết địa chỉ đó thuộc về `customer` nào.
- Loại bỏ thuộc tính `total_amount` Kết quả như sau: 
<img src=https://i.imgur.com/lUwg1pd.png>

### Dạng chuẩn 2NF
Quy tắc chuẩn hóa từ chuẩn 1NF thành 2NF:</br>
- Bước 1: Loại bỏ các thuộc tính không khóa phụ thuộc vào một bộ phận khóa chính và tách ra thành một bảng riêng, khóa chính của bảng là bộ phận của khóa mà chúng phụ thuộc vào.
- Bước 2: Các thuộc tính còn lại lập thành một quan hệ, khóa chính của nó là khóa chính ban đầu.

Bảng dữ liệu mới mà ta thiết kế vẫn chưa đạt chuẩn 2NF là vì: một số thuộc tính như description , unit_price phụ thuộc vào 1 phần của khóa là product_id chứ không cần phụ thuộc cả vào tập khóa (customer_id, order_id, product_id), hay thuộc tính customer_name và phone cũng chỉ phụ thuộc vào customer_id, thuộc tính order_date phụ thuộc vào customer_id và order_id, thuộc tính quantity phụ thuộc vào order_id và product_id.

Vậy nên để đạt chuẩn 2NF thì ta sẽ thiết kế tiếp bảng dữ liệu chuẩn 1NF như sau:

Tách các thuộc tính (product_id, description, unit_price) thành một bảng riêng là products.
Các thuộc tính (customer_id, order_id, order_date) làm thành một bảng, mình đặt tên là orders.
Còn lại các thuộc tính (order_id, product_id, quantity) làm thành một bảng trung gian giữa products và orders, mình đặt là order_products.
Chỉ cần tuân thủ 2 chuẩn mà ta đã được cơ sở dữ liệu chuẩn hóa như sau: 

<img src=https://i.imgur.com/fiTAxr8.png>

Dạng chuẩn 3NF
Điều kiện:

Phải đạt chuẩn 2NF

Mọi thuộc tính không khóa phụ thuộc bắc cầu vào thuộc tính khóa (nghĩa là tất cả các thuộc tính không khóa phải được suy ra trực tiếp từ thuộc tính khóa)

Quy tắc chuẩn hóa từ 2NF thành 3NF:

Bước 1: Loại bỏ các thuộc tính phụ thuộc bắc cầu ra khỏi quan hệ và tách chúng thành quan hệ riêng có khóa chính là thuộc tính bắc cầu.

Bước 2: Các thuộc tính còn lại lập thành một quan hệ có khóa chính là khóa ban đầu.

Để ý thấy cơ sở dữ liệu mà ta thiết kế ở chuẩn 2NF cũng đã đạt chuẩn 3NF. Thế nên mình sẽ lấy một ví dụ khác để các bạn tham khảo như sau:

Ví dụ bảng sau vi phạm chuẩn 3NF: 

Ta thấy thuộc tính country_name phụ thuộc vào country_id, mà country_id lại phụ thuộc vào khóa chính là id. Vì vậy ta nên tách bảng trên thành 2 bảng sau:



Dạng chuẩn Boyce-Codd
Điều kiện:

Phải đạt chuẩn 3NF

Không có thuộc tính khóa nào phụ thuộc vào thuộc tính không khóa

Quy tắc chuẩn hóa 3NF thành Boyce-Codd:

Bước 1: Loại bỏ các thuộc tính khóa phụ thuộc hàm vào thuộc tính không khóa ra khỏi quan hệ

Bước 2: Tách thuộc tính vừa loại bỏ thành một quan hệ riêng có khoá chính là thuộc tính không khóa gây ra phụ thuộc.
