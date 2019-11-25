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

API là interface được published trong khi service đang chạy trong backend. APIs có vòng đời riêng độc lập với backend services mà chúng dựa vào. Lifecycle được exposed trong API Publisher và dược quản lý bởi publisher role.

Vòng đời API mặc định có sẵn các giai đoạn sau:
 - **CREATED:** API metadata được thêm vào API Store nhưng nó chưa hiển thị để cho người đăng ký cũng như không được deployed cho API Gateway.
- **PROTOTYPED:** API Được deployed và published trong API Store như 1 nguyên mẫu. API prototyped thường là 1 triển khai giả được public để lấy feedback về khả năng sử dụng của nó. Users có thể sử dụng API prototyped mà không cần đăng ký.
- **PUBLISHED:** API hiển thị trong API Store và có sẵn để đăng ký.
- **DEPRECATED:** API vẫn được deployed trong API Gateway nhưng không hiển thị cho người đăng ký. Bạn có thể tự động loại bỏ API khi verson mới được published.
- **RETIRED:** API chưa được published từ API Gateway và deleted từ Store.
- **BLOCKED:** Truy cập API tạm thời bị chặn. Runtime calls bị blocked, và API không hiển thị trong API Store.

## 1.4 Applications

Mọt application chủ yếu được sử dụng để tách người dùng khỏi APIs. Nó cho phép bạn làm như sau:
- Generate và sử dụng 1 single key cho nhiều APIs.
- Đăng ký nhiều lần tới 1 single API với SLA levels khác nhau.

Bạn có thế tạo 1 ứng dụng để đăng ký API. API Manager đi kèm với 1 ứng dụng mặc định, bạn cũng có thể tạo bao nhiêu ứng dụng tùy thích.

## 1.5 Throttling tiers

Các tầng điều tiết được liên kết với API tại thời điểm đăng ký và có thể được xác định ở 1 API-level, resource-level, subscription-level và application-level (per token). Chúng xác định các giới hạn điều chỉnh được thi hành bởi API Gateway, ví dụ: 10 TPS (transactions per second). Giới hạn điều chỉnh cuối cùng được cấp cho một người dùng nhất định trên một API nhất định cuối cùng được xác định bởi output của tất cả các throttling tiers cùng nhau. API Manager đi kèm với 3 tiers được xác định trước cho mỗi level và 1 tier đặc biệt được gọi là Unlimited có thể disable bằng cách editing `<ThrottlingConfigurations>` của `<API-M_HOME>/repository/conf/api-manager.xml file`. 

Từ API Manager 2.0.0, Advanced Throttling được enabled mặc định với cấu hình trong `<API-M_HOME>/repository/conf/api-manager.xml.```
```
<ThrottlingConfigurations>
        <EnableAdvanceThrottling>true</EnableAdvanceThrottling>
     ......
<ThrottlingConfigurations>
```
Nếu muốn disable `Advanced Throttling` bắng cách setting giá trị của `<EnableAdvanceThrottling> false`, Advanced Throttling sẽ được disabled và basic Throttling được enabled. Nếu muốn disable Unlimited Throttling tier của cấu hình cơ bản, bạn cần disable nó dưới `<TierManagement>` bằng setting `<EnableUnlimitedTier>` sang `false`.
```sh
<TierManagement>       
        <EnableUnlimitedTier>true</EnableUnlimitedTier>
</TierManagement>
```
Các tầng dăng ký được xác định:

|Throttling Tier|Description|
|---------------|-----------|
|Unlimited|Allows unlimited requests|
|Gold|Allows 5000 requests per minute|
|Silver|Allows 2000 requests per minute|
|Bronze|Allows 1000 requests per minute|

## 1.6 API keys
API Manager hỗ trợ 2 kich bản cho việc authentication:
- Một access token được sử dụng để identify và authenticate toàn bộ ứng dụng
- Một access token được sử dụng để identify user và ứng dụng (vd: người dùng của 1 ứng dụng mobil được deployed trên nhiều thiết bị).

**Application access token:** Application access tokens được generated bới người dùng API và phải được thông qua trong các incoming API requests. API Manager sử dụng chuẩn OAuth2 để cung cấp key management. API key là 1 simple string bạn pass với 1 HTTP header (vd: "Authorization: Bearer NtBQkXoKElu0H1a1fQ0DWfo6IX4a,") và nó làm việc tốt như nhau cho cả SOAP và REST calls.

Application access tokens được generated bởi application level và valid cho tất APIs bạn liên kết với application. Các tokens có 1 fixed expiration time được set mặc định 60m và có thể thay đổi. Người dùng có thể regenerate access token trực tiếp từ API Store. Để thay đổi default expiration time thực hiện mở file `<API-M_HOME>/repository/conf/identity/identity.xml` và thay đổi giá trị của `<AccessTokenDefaultValidityPeriod>`. Nếu set giá trị âm, token sẽ không bao giờ hết hạn. Thay đổi các giá trị này được áp dụng với các ứng dụng mới mà bạn tạo.

**Application user access token:** Bạn generate access tokens trên như cầu sử dụng Token API. Trong trường hợp 1 token hết hạn, bạn sử dụng Token API để làm mới nó.

Token API lấy các parameters sau để tạo access token:
- Grant Type
- Username
- Password
- Scope

Để generate 1 access token mới, bạn call 1 Token API với các tham số ở trên trong `grant_type=password`. Token API sau đó trả về 2 tokens: 1 là access token và 1 refresh token. Access token được lưu trong phiên ở phía client (bản thân ứng dụng không cần quản lý user vè passwords). Trên phía API Gateway side, access token được xác thực cho mỗi API call. Khi token hết hạn, bạn làm mới token bằng cách call API với tham số ở trên trong `grant_type=refresh_token` và chuyển token mới làm tham số.

## 1.7 API resources

Một API được tạo thành từ 1 hoặc nhiều resources. Mỗi resource xử lý 1 loại yêu cầu cụ thẻ và tương tự như 1 phương thức (function) trong API lớn hơn. API resources chấp nhân các thuộc tính sau:
- verbs: Chỉ định HTTP verbs mà 1 resource cụ thể chấp nhận. Các giá trị được phép là GET, POST, PUT, DELETE, PATCH, HEAD, và OPTIONS. Bạn có thể đưa ra nhiều giá trị cùng 1 lúc.  
- uri-template: Một URI template được định nghĩa trong `http://tools.ietf.org/html/rfc6570`. (vd `/phoneverify/<phoneNumber>`).
- url-mapping: Ánh xạ URL được xác định theo thông số kỹ thuật của servlet (extension mappings, path mappings, và exact mappings).
- Throttling tiers: Giới hạn cố lần truy cập vào tài nguyên trong 1 khoảng thời gian nhất định.
- Auth-Type: Chỉ định xác thực Resource level authentication theo HTTP verbs. Auth-type có thể là None, Application, Application User, hoặc Application & Application User.  
           - None: Có thể truy cập API resource mà không cần bất kỳ access tokens.
           - Application: Một application access token yêu cầu truy cập API resource.
           - Application User: Một user access token được yêu cầu để truy cập API resource.
           - Application & Application User: Một application access token cùng với một user access token được yêu cầu đẻ truy cập API resource.

## Tài liệu tham khảo 
- https://docs.wso2.com/display/AM260/Quick+Start+Guide#543cb4e4ca8342f391f66652e4a1686c
