# 1. The Update Framework (TUF)
TUF là 1 software update framework được bắt đầu vào năm 2009. Nó đã dựa trên Thandy, ứng dụng cập nhật cho Tor browser.

Trái ngược với Thandy hoặc các ứng dụng hoặc trình quản lý gói khác, TUF nhắm đến mục tiêu trở thành một phần mở rộng chung của bất kỳ software update system nào muốn sử dụng nó, hơn là một công cụ cập nhật phần mềm độc lập. Đặc tả TUF cũng như triển khai điều chỉnh có thể được tìm thấy trên Github.

## 1.1 Roles, keys and files
Chúng tôi đã thấy rằng cách tiếp cận GPG dễ tấn công do 1 khóa ký duy nhất được giữ trực tuyến và do đó nó tiềm ẩn nguy cơ bị tấn công lớn. Để khắc phục vấn đề đó TUF xác định một hệ thống phân cấp các khóa khác nhau với các đặc quyền khác nhau và ngày hết hạn khác nhau thay vì dựa vào một khóa duy nhất. Các khóa này được ràng buộc với các vai trò cụ thể, chủ sở hữu của root key có vai trò root trong hệ thống. Trên hết, TUF xác định 1 metadata files phải có trong thư mục cấp cao nhất của repository. Cùng xem xét kỹ hơn về kiến trúc khung.

<img src=https://i.imgur.com/zEX2yS8.png>

- The root key is root of all trust. Nó ký vào root metadata file, liệt kê ID của root, targets, snapshot, and timestamp public keys. Clients  sử dụng public keys để xác minh chữ ký trên tất cả metadata files trong repository. Khóa này được giữ bởi chủ sở hữu collection và phải được giữ offline và an toàn nhiều hơn bất kỳ khóa nào khác.

- The snapshot key ký snapshot metadata file, liệt kê filenames, sizes, và hashes của root, targets, and delegation metadata files cho collection. File này sử dụng để xác minh tính toàn vẹn của các metadata files khác. The snapshot key được giữ bởi collection owner/administratoris hoặc được giữ bởi Notary-service để tạo điều kiện cho nhiều người cộng tác ký thông qua vai trò ủy quyền.

- The timestamp key ký timestamp metadata file, cung cấp đảm bảo độ mới cho collection bằng cách có shortest expiry time của bất kì metadata cụ thể nào và bằng cách chỉ định filename, size, và hash của hấu hết snapshot for the collection gần nhất. Nó được sử dụng để xác thức tính toàn vẹn của snapshot file. The timestamp key được giữ bởi Notary-service để timestamp có thể được tự đông tạo lại khi nó được yêu cầu từ server thay vì yêu cầu owner mỗi mỗi lần timestamp expiry.

- The targets key ký targets metadata file, liệt kê filenames trong collection, kích thước và giá trị hashes tương ứng. File này được sử dụng để xác thực tính toàn vẹn của 1 vài hoặc tất cả contents của repository. Nó cũng được sử dụng để ủy quyền tin cậy cho collaborators thông qua vai trò ủy quyền. The targets key được giữ bời collection owner hoặc administrator.

- Delegation keys ký delegation metadata files, liệt kê filenames trong collection, và kích thước và giá trị hashes tương ứng. File này được sử dụng để xác thực tính toàn vẹn của 1 số hoặc tất cả contents của. Nó cũng được sử dụng để ủy quyền tin cậy cho collaborators thông qua vai trò ủy quyển cấp thấp hơn. Delegation keys được giữ bởi bất kỳ ai từ collection owner hoặc administrator đển collection collaborators.

# Docker Notary
Vậy làm thế nào Docker có thể hưởng lợi từ TUF để phân phối image an toàn hơn? Câu trả lời khá đơn giản: The Docker team stuck to the TUF specification and built its own update system on top of it. Đây là lúc Notary đi vào hoạt động, trên thực tế là một triển khai có ý kiến của TUF. Nhiệm vụ chính của Notary là cho phép clients đảm bảo tính toàn vẹn của Docker-image cũng như xác minh danh tính của publisher.

Hãy nhớ rằng công việc của Notary không phải là kiểm tra nội dung của image theo bất kỳ cách nào hoặc thực hiện bất kỳ phân tích code nào. Ta chỉ nói về tính toàn vẹn và danh tính publisher là mối quan tâm chính của Notary. Từ góc độ OOP, người ta có thể nói rằng Notary tuân theo Nguyên tắc Trách nhiệm duy nhất: Nó thực hiện chính xác một điều, và ký tên image đó.

Nó cũng đề cập đến việc Notary, mặc dù đã được Docker triển khai, nhưng không bị hạn chế để áp dụng trên Docker-image dưới bất kỳ hình thức nào. Thay vào đó, Notary là một công cụ hoàn toàn độc lập, có thể hoạt động trên repositories hoặc collections dữ liệu.

## Notary Architecture and components

Notary gồm 2 thành phần chính: Notary server và Notary signer. Notary clients chỉ tương tác với Notary-server bằng cách pulling hoặc pushing metadata. Nó lưu trữ TUF metadata files cho 1 hoặc nhiều collections đáng tin cậy trong cơ sở dữ liệu được liên kết.

Notary signer có thể được coi là một thực thể độc lập, lưu trữ tất cả các TUF private keys trong cơ sở dữ liệu riêng biệt (signer DB) và ký metadata cho Notary-server. Hình dưới đây cung cấp một cái nhìn tổng quan về kiến trúc.

<img src=https://i.imgur.com/pRzpJWp.png>

**Notary server**

Như đã đề cập, Notary-server lưu trữ và phục vụ metadata cho Notary-clients. Khi clients hỏi Notary-server về metadata, thành phần này đảm bảo rằng các phiên bản mới nhất của metadata files được tìm nạp từ TUF database và được gửi đến clients. Ngoài ra, Notary-server kiểm tra tất cả các metadata được clients tải lên về tính hợp lệ cũng như chữ ký hợp pháp. Ngay sau khi metadata hợp lệ mới được cung cấp bởi 1 clients, Notary-server cũng tạo ra timestamp metadata được ký bởi Notary signer.

**Notary signer**

Notary signer giống như 1 back-end, lưu trữ private timestamp key (và có thể là snapshot key) và chờ đợi các yêu cầu ký tên của Notary server. Notary server là thành phần duy nhất kết nối trực tiếp với signer. Ngược lại, Notary-server trực tiếp phục vụ clients và do đó hoạt động nhiều hơn với tư cách là một front-end.

Thiết kế kiến trúc Notary như thế này đi kèm với những lợi thế rất quan trọng. Đầu tiên, TUF  metadata được gửi cho clients không bị lẫn với TUF keys trong một cơ sở dữ liệu. Thứ hai, TUF private keys không cần phải được lưu trữ trên 1 front-end dễ bị tấn công tiếp xúc trực tiếp với clients.

 **Tương tác giữa Client-Server-Signer**
 
Với kiến trúc cơ bản của Notary, chúng tôi sẽ kiểm tra những gì diễn ra giữa 1 client, Notary server và Notary signer ngay khi client bắt đầu tương tác với Notary. Mô tả ngắn gọn các hành động được tạo ra bởi các bên liên quan. 

<img src=https://i.imgur.com/8vccjG3.png>

1. Notary-server tùy chọn hỗ trợ xác thực từ clients sử dụng JWT tokens. Điều này yêu cầu server xác thực quản lý các điều khiển truy cập và cert bundle từ server xác thực này chứa public key mà nó sử dụng để ký tokens.

Nếu xác thực token được bật trên Notary-server thì mọi clients kết nối không có token sẽ được chuyển hướng đến server xác thực.

2. Client sẽ đăng nhập vào server xác thực thông qua xác thực cơ bản qua HTTPS, nhận token và sau đó xuất trình token cho Notary-server theo các yêu cầu trong tương lai.

3. Khi client tải lên metadata files mới, Notary-server sẽ kiểm tra chúng dựa trên bất kỳ phiên bản nào trước đó để tìm xung đột và xác minh chữ ký, checksums và tính hợp lệ của metadata đã tải lên.

4. Khi tất cả metadata tải lên đã được xác thực, Notary-server sẽ tạo timestamp (and maybe snapshot) metadata. Nó sẽ gửi metadata được tạo này cho Notary signer để được ký.

5. Notary signer lấy private keys được mã hóa cần thiết từ cơ sở dữ liệu của nó nếu có, giải mã keys và sử dụng chúng để ký metadata. Nếu thành công, nó sẽ gửi chữ ký trở lại Notary server.

6. MNotary server là source of truth cho trạng thái của 1 collection of data đáng tin cậy, lưu trữ metadata trong TUF database của cả client-uploaded và server tạo. Timestamp và snapshot metadata tạo ra xác nhận rằng metadata files mà clients đã tải lên là mới nhất cho collection đáng tin cậy đó.

Cuối cùng, Notary server sẽ thông báo cho client rằng quá trình tải lên của họ đã thành công.

7. Bây giờ client có thể tải metadata mới nhất từ server bằng cách sử dụng token vẫn còn hiệu lực để kết nối. Notary server chỉ cần lấy metadata từ cơ sở dữ liệu, vì không có metadata nào hết hạn.

Trong trường hợp timestamp đã hết hạn, Notary server sẽ đi qua toàn bộ chuỗi nơi timestamp mới, yêu cầu Notary signer cho một chữ ký, lưu trữ timestamp mới được ký trong cơ sở dữ liệu. Sau đó, nó sẽ gửi timestamp mới này cùng với phần còn lại của metadata được lưu trữ đến client yêu cầu.

**Threat model**



## Tài liệu tham khảo
- https://blog.mi.hdm-stuttgart.de/index.php/2016/09/13/exploring-docker-security-part-3-docker-content-trust/
- https://github.com/theupdateframework/notary/blob/master/docs/service_architecture.md
