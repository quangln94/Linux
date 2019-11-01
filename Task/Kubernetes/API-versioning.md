# API versioning
Để loại bỏ các trường hoặc cơ cấu lại resource 1 cách dễ dàng, k8s hỗ trợ nhiều API versions

Các API versions khác nhau có độ ổn định và hỗ trợ khác nhau. 

**Alpha level:**
- Tên version chứa `alpha` (e.g. v1alpha1).
- Có thể có lỗi. Enabling tính năng có thể expose bugs. Mạc định Disabled.
- Support cho tính năng có thể bị loại bỏ mà thông báo.
- API có thể thay đổi trong bản phát hành phần mềm sau này mà không thông báo.
- Khuyễn nghị chỉ dùng trong testing clusters ngắn hạn, do tăng nguy cơ lỗi và không hỗ trợ dài hạn.

**Beta level:**
- Tên version chứa beta (e.g. v2beta3).
- Code được kiểm tra tốt. Enabling tính năng an toàn. Mặc định.
- Hỗ trợ tính năng tổng thế không bị bỏ mặc dù chi tiết có thể thay đổi.
- Khuyễn nghị sử dụng cho non-business-critical vì có khả năng thay đổi trong bản phát hành tiếp theo.

**Stable level:**
- Tên version là `vX` trong đó `X` là số nguyên
- Phiên bản ổn định của tính năng sẽ áp dụng trong các bản phát hành phần mềm tiếp theo.
