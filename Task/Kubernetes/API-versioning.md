# API versioning
- K8s hỗ trợ nhiều API versions để loại bỏ các trường hoặc cơ cấu lại resource 1 cách dễ dàng.
- Các API versions khác nhau có độ ổn định và hỗ trợ khác nhau. 

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

## API groups

IPI groups để mở rộng Kubernetes API. API group chỉ định trong REST path và trong trường  `apiVersion` của 1 object.

Một số API groups hay sử dụng: 
- Core group thường gọi là *legacy group* trong REST path `/api/v1` và sử dụng `apiVersion: v1`.
- Groups được đặt tên tại REST path `/apis/$GROUP_NAME/$VERSION`, và sử dụng `apiVersion: $GROUP_NAME/$VERSION` (e.g. `apiVersion: batch/v1`).

## Enabling API groups

Chắc chắn resources và API groups mặc định enabled. Có thể enabled hoặc disabled bằng setting `--runtime-config` trên apiserver. `--runtime-config`  accepts comma separated values. For ex: to disable batch/v1, set --runtime-config=batch/v1=false, to enable batch/v2alpha1, set --runtime-config=batch/v2alpha1. The flag accepts comma separated set of key=value pairs describing runtime configuration of the apiserver.

IMPORTANT: Enabling or disabling groups or resources requires restarting apiserver and controller-manager to pick up the --runtime-config changes.

## Enabling resources trong groups

Mặc định DaemonSets, Deployments, HorizontalPodAutoscalers, Ingresses, Jobs và ReplicaSets được enabled. Các resources khác có thể được enabled bằng setting `--runtime-config` trên apiserver ví dụ: `--runtime-config=extensions/v1beta1/deployments=false,extensions/v1beta1/ingresses=false`




