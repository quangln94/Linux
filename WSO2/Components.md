# Components

## 1. Thành phần của API Manager

- **API Publisher:** Cho phép API providers để publish APIs, chia sẻ documentation, cung cấp API keys và thu thập feedback trên các tính năng chất lượng và sử dung. Truy cập Web thông qua `https://<Server Host>:9443/publisher`.
- **API Store (Developer Portal):** Cho phép người dùng API tự đăng ký, khám phá, đánh giá và tương tác với API Publishers. Truy cập Web thông qua `https://<Server Host>:9443/store`.
- API Gateway: Secures, protects, manages, and scales API calls. It is a simple API proxy that intercepts API requests and applies policies such as throttling and security checks. It is also instrumental in gathering API usage statistics. The Web interface can be accessed via https://<Server Host>:9443/carbon .
- Key Manager: Handles all security and key-related operations. The API Gateway connects with the Key Manager to check the validity of subscriptions, OAuth tokens, and API invocations. The Key Manager also provides a token API to generate OAuth tokens that can be accessed via the Gateway.
- Traffic Manager: Helps users to regulate API traffic, make APIs and applications available to consumers at different service levels and secures APIs against security attacks. The Traffic Manager features a dynamic throttling engine to process throttling policies in real-time.
- WSO2 API Manager Analytics:  Provides a host of statistical graphs and an alerting mechanism on predetermined events.


## Tài liệu tham khảo 
- https://docs.wso2.com/display/AM260/Quick+Start+Guide#543cb4e4ca8342f391f66652e4a1686c
