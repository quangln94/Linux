## 1. Giới thiệu
WSO2 Dashboard Server (WSO2 DS), cho phép tạo bất kỳ dashboard tùy chỉnh với 1 layout đề nghị, quản lý tập trung và trực quan hóa dữ liệu mà bạn quan tâm.

## 2. Tính năng
- Create powerful, mobile-ready dashboards
- Open, highly scalable architecture	
- Secure, role-based dashboard access	

Tham khảo thêm [tại đây](https://docs.wso2.com/display/DS200/Features)

## 3. Kiến trúc

WSO2 DS là 1 gadget container bao gồm 1 portal application là web application cho phép users có quyển edit để tạo create dashboards thông qua Dashboard Designer và view thông qua dashboard view mode. Dashboard Designer cho phép users customize dashboard layouts, thêm pages tới 1 dashboard, cấu hình inter-gadget communication dựa trên Pub/Sub mechanism, thêm dashboard banners...

WSO2 DS cung cấp 1 programming model dựa trên đặc tả OpenSocial cho phép users tạo customized gadgets là 1 thành phần UI có thể chia sẻ dựa trên các yêu cầu. As the Dashboard Server allows the users to create each gadget as an isolated unit, gadgets can be developed in parallel.

Tạo hoặc updates a dashboard thông qua Dashboard Designer, data được lưu trong original registry. However, when a dashboard viewer personalizes a dashboard, the data is stored in the space allocated to that particular user in the registry. Thereby, enabling per-user dashboard customization; while, also preserving the dashboard editors preferences.

<img src=https://i.imgur.com/qthfgr9.png>

Lõi của WSO2 DS là Carbon Server based on WSO2 Carbon Kernel và nên tảng WSO2 Carbon Dashboard được đóng gói với Jaggery và Apache Shindig  để hỗ trợ portal application. Users can access portal application và cũng có thể giao tiếp với third-party APIs.

**Các thành phần trong Dashboard Server**

***APIs và Pages***

WSO2 DS bao gồm 3 routers: API router, page router và tenant router

Tenant router lọc tất cả incoming requests tới Dashboard Designer bằng cách phân tích request URL context, và chuyển hướng requests tới API hoặc page router, which are routers in WSO2 DS used to  differentiate the incoming API and page requests. 

***Controllers***

WSO2 DS duy trì controllers riêng cho API và page requests. Nếu request là page request, controllers thực hiện request và hướng user tới web page tương ứng. Khi request là API request, controllers thực hiện quá trình tương ứng và trả về 1 kết quả.

***Modules***

Modules chứa chức năng mà WSO2 DS sử dụng để xử lý các registry transactions và thực hiện business logic liên qua đến user requests.

***Store***

WSO2 DS Store chứa dashboard layouts và gadgets

Tenant cần tạo thư mục riêng dựa trên name và đặt trong thư mục `<DS_HOME>/repository/deployment/server/jaggeryapps/portal/store`  để duy trì customized gadgets và layouts.  

***Theme***

WSO2 DS theme được đặt trong thư mục `<DS_HOME>/repository/deployment/server/jaggeryapps/portal` chứa 2 thư mục sau: image và templates. Thư mục image chứa images được sử dụng trong web pages và thư mục templates chứa web views.

***Jaggery***

Jaggery module trong server chứa trình biên dịch Jaggery và tính năng.

***Shindig***

Apache Shindig là server mà Dashboard Server sử dụng để kết xuất gadgets dựa trên đặc tả OpenSocial

***Tham khảo các bản Release [tại đây](https://docs.wso2.com/display/DS200/About+This+Release)***

## Tài liệu tham khảo
- https://docs.wso2.com/display/DS200/Architecture
