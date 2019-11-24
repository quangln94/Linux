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
## 1.4 Applications
## 1.5 Throttling tiers
## 1.6 API keys
## 1.7 API resources











## Tài liệu tham khảo 
- https://docs.wso2.com/display/AM260/Quick+Start+Guide#543cb4e4ca8342f391f66652e4a1686c
