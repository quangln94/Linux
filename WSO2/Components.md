## 1. Components

## 1.1 Thành phần của API Manager

- **API Publisher:** Cho phép API providers để publish APIs, chia sẻ documentation, cung cấp API keys và thu thập feedback trên các tính năng chất lượng và sử dung. Truy cập Web thông qua `https://<Server Host>:9443/publisher`.
- **API Store (Developer Portal):** Cho phép người dùng API đăng ký, khám phá, đánh giá và tương tác với API Publishers. Truy cập Web thông qua `https://<Server Host>:9443/store`.
- **API Gateway:** Secures, protects, manages, và scales API calls. Nó là 1 simple API proxy chắn các API requests và applies policies Như điều chỉnh và kiểm tra security. Nó cũng là công cụ thu thập số liệu thống kê sử dụng API. Truy cập qua `https://<Server Host>:9443/carbon `.
- **Key Manager**: Xử lý tất cả các hoạt động liên quan đến security và key. API Gateway kết nối với Key Manager để check tính hợp lệ của subscriptions, OAuth tokens, và API invocations. Key Manager cũng cung cấp 1 token API để generate OAuth tokens có thể được truy cập thông qua Gateway.
- **Traffic Manager:** Giúp người dùng điều tiết API traffic, cung cấp APIs và applications để người dùng ở các cấp độ dịch vụ khác nhau và bảo vệ APIs chống lại các tấn công bảo mật. Traffic Manager tự động điểu chỉnh để xử lý các chính sách điểu chỉnh trong real-time.
- **SO2 API Manager Analytics:** Cung cấp các biểu đồ thống kê và cơ chế cảnh báo về các sự kiện được xác định trước.

<img src=https://i.imgur.com/Or4F9cZ.png>

## 1.2 Users and roles

API manager đề nghị 3 role distinct community áp dụng cho hầu hết các doanh nghiệp:
 - **Creator:** 1 creator là 1 người có vai trò technical hiểu các khía cạnh của API (interfaces, documentation, versions, cách nó exposed bới Gateway...) và sử dụng API publisher để cung cấp APIs tói API Store. Creator sử dụng API Store để tham khảo xếp hạng và feedback được cung cấp bởi API users. Creators có thể thêm APIs tới store nhưng không thể quản lý vòng đời của chúng (vd: làm chúng hiển thị với thế giới bên ngoài).
 - **Publisher:** 1 publisher quản lý 1 bộ APIs trên toàn doanh nghiệp hoặc đơn vị kinh doanh và kiểm soát vòng đời của API và các khía cạnh kiếm tiền. 
- **Consumer:** Người dùng sử dụng API Store để khám phá APIs, xem documentation và forums, đánh giá/nhận xét trên APIs. Người dùng đăng ký APIs để lấy API keys.

## 1.3 API lifecycle

API là interface được published trong khi service đang chạy trong backend. APIs có vòng đời riêng độc lập với backend services mà chúng dựa vào. Vòng đời được exposed trong API Publisher và dược quản lý bởi publisher role.

Vòng đời API mặc định có sẵn các giai đoạn sau:
 - **CREATED:** API metadata được thêm vào API Store nhưng nó chưa hiển thị để cho người đăng ký cũng như không được deployed cho API Gateway.
- **PROTOTYPED:** API Được deployed và published trong API Store như 1 nguyen mẫu. API prototyped thường là 1 triển khai giả đươc public để lấy feedback về khả năng sử dụng của nó. Users có thể sử dụng API prototyped mà không cần đăng ký.
- **PUBLISHED:** API hiển thị trong API Store và có sẵn để đăng ký.
- **DEPRECATED:** API vẫn được deployed trong API Gateway nhưng không hển thị cho người đăng ký. Bạn có thể tự động loại bỏ API khi verson mới được published.
- **RETIRED:** API chưa được published từ API Gateway và deleted từ Store.
- **BLOCKED:** Truy cập API tạm thời bị chặn. Runtime calls bị blocked, và API không hiển thị trong API Store.

## 1.4 Applications

Mọt application chủ yếu được sử dụng để tách người dùng khỏi APIs. Nó cho phép bạn làm như sau:
- Generate và sử dụng 1 single key cho nhiều APIs.
- Đăng ký nhiều lần tới 1 single API với SLA levels khác nhau.

Bạn có thế tạo 1 ứng dụng để đăng ký API. API Manager đi kèm với 1 ứng dụng mặc định, bạn cũng có thể tạo bao nhiêu ứng dụng tùy thích.

## 1.5 Throttling tiers

Các tầng điều tiết được liên kết với API tại thời điểm đăng ký và có thể được xác định ở 1 API-level, resource-level, subscription-level và application-level (per token). Chúng xác định các giới hạn điều chỉnh được thi hành bởi API Gateway, ví dụ: 10 TPS (transactions per second). Giới hạn điều chỉnh cuối cùng được cấp cho một người dùng nhất định trên một API nhất định cuối cùng được xác định bởi output của tất cả các throttling tiers cùng nhau. API Manager đi kèm với 3 tiers được xác định trước cho mỗi level và 1 tier đặc biệt được gọi là Unlimited có thể disable bằng cách editing `<ThrottlingConfigurations>` của `<API-M_HOME>/repository/conf/api-manager.xml file`. 











## 1.6 API keys
## 1.7 API resources











## Tài liệu tham khảo 
- https://docs.wso2.com/display/AM260/Quick+Start+Guide#543cb4e4ca8342f391f66652e4a1686c
