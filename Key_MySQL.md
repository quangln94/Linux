# Khác biệt giữa khóa chính và khóa ngoại trong SQL
Các khoá chính và khóa ngoại là hai loại ràng buộc có thể được sử dụng để thực thi toàn vẹn dữ liệu trong các bảng SQL Server và đây là những đối tượng cơ sở dữ liệu quan trọng.

Trong SQL Server, có hai khóa - khóa chính và khoá ngoại dường như giống nhau, nhưng thực tế cả hai đều khác nhau về các tính năng và hành vi. Các khoá chính và khóa ngoại là hai loại ràng buộc có thể được sử dụng để thực thi toàn vẹn dữ liệu trong các bảng SQL Server và đây là những đối tượng cơ sở dữ liệu quan trọng.

## Khóa chính là gì
Khóa chính (hay ràng buộc khóa chính) được sử dụng để định danh duy nhất mỗi record trong table của cơ sở dữ liệu.</br>
Ngoài ra, nó còn dùng để thiết lập quan hệ 1-n (hay ràng buộc tham chiếu) giữa hai table trong cơ sở dữ liệu.</br>
Dữ liệu (value) của field khóa chính phải có tính duy nhất. Và không chứa các giá trị Null.</br>
Mỗi table nên chỉ có một khóa chính, khóa chính có thể tạo ra từ nhiều field của table.
## Khóa ngoại là gì
Khóa ngoại của một table được xem như con trỏ trỏ tới khóa chính của table khác.</br>
Nếu trường MaSV của table DiemSV được sử dụng để tạo ràng buộc tham chiếu đến table HSSV, thông qua khóa chính là MaSV thì MaSV của table DiemSV được gọi là khóa ngoại của bảng này. Đây cũng chính là lý do mà ta nói, khóa ngoại được xem như con trỏ trởi tới khóa chính.</br>
Để hiểu rõ hơn về ý nghĩa sử dụng của khóa chính, khóa ngoại chúng ta hãy xét ví dụ sau: Giả sử cơ sở dữ liệu QLDiemSV có hai table: HSSV và DiemSV như sau:</br>
Table HSSV gồm 6 field, trong đó MaSV được chọn làm khóa chính của table này.</br>
<img src=https://i.imgur.com/pi5JA4G.png>
Table DiemSV gồm 6 field, trong đó STT là khóa chính và MaSV được chọn làm khóa ngoại của table này.


Như vậy, hai table HSSV và DiemSV quan hệ dữ liệu với nhau thông qua field MaSV của mỗi table (đây là quan hệ 1 – n). Hay nói cách khác, ràng buộc tham chiếu đã được tạo giữa hai table (từ table DiemSV đến table HSSV).

Với ràng buộc này thì, việc người sử dụng vô tình hay cố ý phá hủy các liên kết sẽ bị ngăn chặn. Và, người sử dụng cũng không thể nhập vào cột khóa ngoại một giá trị mà giá trị đó không xuất hiện ở cột khóa chính mà khóa này trỏ tới (không thể nhập điểm cho một sinh viên, vào table DiemSV, mà mã của họ không xuất hiện ở cột MaSV ở table HSSV).

3. Thiết lập khóa chính
Để tạo khóa chính ngay trong khi tạo table ta có thể sử dụng câu lệnh SQL Create Table như sau:

(
MaSV varchar (8) NOT NULL,
Holot varchar(20), Ten varchar(8),
NgaySinh Date, MaLop varchar(8) NOT NULL,
Lienhe varchar(11) NOT NULL,
PRIMARY KEY (MaSV)
);

Câu lệnh này dùng để tạo table HSSV, đồng thời chỉ định field MaSV làm khóa chính cho nó.

Trong trường hợp khóa chính được thành lập từ nhiều field và ta cần đặt tên cho ràng buộc khóa này thì có thể sử dụng câu lệnh Create Table như sau:

(
MaSV varchar (8) NOT NULL,
Holot varchar(20), Ten varchar(8),
NgaySinh DATE, MaLop varchar(8) NOT NULL,
Lienhe varchar(11) NOT NULL,
CONSTRAINT Ma PRIMARY KEY (MaSV, MaLop)
);

Vậy khóa chính table này được thành lập từ hai field: MaSV và MaLop và tên của ràng buộc này là Ma.

3.1 Tạo khóa chính cho table đã tạo
Sử dụng câu lệnh sau:

ALTER TABLE HSSV ADD PRIMARY KEY (MaSV)

Hoặc:

ALTER TABLE HSSV ADD CONSTRAINT Ma PRIMARY KEY (MaSV, MaLop)

Rõ ràng, trong trường hợp này các field MaSV, MaLop phải đã được khai báo ràng buộc NOT NULL (trng khi tạo table).

3.2 Xóa khóa chính
Sử dụng câu lệnh sau:

ALTER TABLE HSSV DROP PRIMARY KEY;

Hoặc:

ALTER TABLE HSSV DROP CONSTRAINT Ma

4. Thiết lập khóa ngoại
Để tạo khóa ngoại ngay trong khi tạo table ta có thể sử dụng câu lệnh SQL Create Table như sau:

(
STT INT NOT NULL AUTO_INCREMENT,
MaSV varchar(8) NOT NULL,
MonHoc varchar(6) NOT NULL,
HKI, HKII, ĐTB_Nam INT,
PRIMARY KEY (STT),
FOREIGN KEY (MaSV) REFERENCES HSSV(MaSV)
)

Câu lệnh này: Tạo table DiemSV gồm 6 field, trong đó khóa chính là field STT và field khóa ngoại là MaSV. Table này tạo ràng buộc tham chiếu đến table HSSV thông qua field MaSV.

Dạng khác:

(
STT INT NOT NULL AUTO_INCREMENT,
MaSV varchar(8) NOT NULL,
MonHoc varchar(6) NOT NULL,
HKI, HKII, ĐTB_Nam INT,
PRIMARY KEY (STT),
CONSTRAINT Ma FOREIGN KEY (MaSV) REFERENCES HSSV(MaSV)
)

Khi cần đặt tên cho ràng buộc khóa ngoại và khóa ngoại được hình thành từ nhiều field thì ta phải sử dụng câu lệnh Create Table theo dạng này.

4.1 Tạo khóa ngoại cho table đã tạo
Ví dụ:


REFERENCES HSSV(MaSV)

Hoặc:


FOREIGN KEY (MaSV) REFERENCES HSSV(MaSV)

Câu lệnh này được sử dụng trong trường hợp cần đặt tên cho ràng buộc khóa ngoại và khóa ngoại được hình thành từ nhiều field.

4.2 Xóa khóa ngoại
Ví dụ:

ALTER TABLE DiemSV DROP FOREIGN KEY Ma

Câu lệnh MySQL ALTER được sử dụng rất phổ biến trong các trường hợp thay đổi tên của table, tên của field hoặc thêm/xóa các field trong một table nào đó. Vì vậy, chúng ta sẽ trở lại câu lệnh này ở các bài sau.

5. Bảng so sánh
Khóa chính	Khóa ngoại
Khóa chính xác định duy nhất một bản ghi trong bảng.	Khóa ngoại là một trường trong bảng và là khóa chính trong một bảng khác.
Khóa chính không chấp nhận các giá trị rỗng.	Khóa ngoại có thể chấp nhận nhiều giá trị rỗng.
Theo mặc định, khoá chính là chỉ mục được nhóm và dữ liệu trong bảng cơ sở dữ liệu được tổ chức theo thứ tự của dãy chỉ mục nhóm.	Khóa ngoại không tự động tạo ra một chỉ mục, nhóm hoặc không nhóm. Bạn có thể tự tạo một chỉ mục trên khoá ngoại.
Chúng ta chỉ có thể có một khóa chính trong một bảng.	Chúng ta có thể có nhiều khoá ngoại trong một bảng.
6. Tổng kết
Chúng ta chỉ sử dụng các cách trên để tạo khóa chính trong MySQL và không chỉ có ở MySQL mà ở SQL Server cũng có cú pháp tương tự vì chúng đều sử dụng ngôn ngữ T-SQL.

Thông thường khi làm việc với các ứng dụng web thì ta ít khi sử dụng khóa ngoại bởi vì sẽ rất chậm, vì vậy người ta sẽ cố gắng thiết kế CSDL làm sao tối ưu để không tồn tại khóa ngoại.
