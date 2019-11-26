## 1. Helm là gì
Deploy một ứng dụng lên Kubernetes cluster - đặc biệt là các ứng dụng phức tạp - đòi hỏi việc tạo một loạt các resource của ứng dụng đó, ví dụ như Pod, Service, Deployment, ReplicaSet ... . Mỗi resource lại yêu chúng ta phải viết một file YAML chi tiết cho nó để deploy. Điều đó dẫn đến các thao tác CRUD trên một loạt các resource này trở nên phức tạp, mất thời gian, dễ bị bỏ sót và gặp vấn đề về tái sử dụng hay chia sẻ cho người khác.

Như Ubuntu có apt, Centos có yum, tương tự Helm đóng vai trò là một Package Manager cho Kubernetes. Việc cài đặt các resource Kubernetes sẽ được thông qua và quản lý trên Helm.

Hiện tại Helm là project chính thức của hệ sinh thái Kubernetes và được quản lý bởi Cloud Native Computing Foundation.

## 2. Các chứng năng của Helm
Hầu hết các ngôn ngữ lập trình và hệ điều hành đều có package manager riêng để đơn giản hóa việc cài đặt và bảo trì các gói phần mềm. Helm trên Kubernetes cluster cũng tương tự như vậy, nó cung cấp một số tính năng cơ bản mà một package manager cần phải có như sau:
- Cài đặt các resource và tự động cài đặt các resource phụ thuộc.
- Update và rollback các resource đã release.
- Cấu hình.
- Kéo các package từ các repository

## 3. Concept và kiến trúc
Trước hết ta cần phải biết qua 3 concept chính của Helm
- Chart: là một cây thông tin cần cần thiết để mô tả một ứng dụng chạy trên Kubernetes cluster.
- Config: chứa các thông tin cấu hình khi kết hợp với Chart tạo thành một đối tượng có thể release - phát hành hay cài đặt - trên Kubernetes.
- Release: là một "running instance" của Chart kết hợp với Config.

Để cho dễ hiểu chúng ta có thể xem Chart như một Class trong lập trình hướng đối tượng, Config là các biến truyền vào consturctor của Class và Release là một đối tượng của Class.

Các chứng năng của Helm được thực hiện thông qua thành phần như sau:

**Helm Client**: cung cấp giao diện command-line để làm việc với Helm Chart:

- Tạo chart ở local.
- Quản lý các repository.
- Tương tác với Tilter server.
      * Gửi chart để cài đặt
      * Truy vấn thông tin của các release.
      * Gửi yêu cầu upgrade hay uninstall các release đã cài.

**Tiller server**: được cài đặt trong cluster k8s, tương tác với Helm Client và Kubernetes API, chịu trách nhiệm cho việc:
- Lắng nghe các request từ Helm Client.
- Kết hợp Chart và Config để tạo nên một Release.
- Cài đặt các Chart vào Kubernetes cluster, và theo dõi các Release tiếp theo.
- Upgrade và Uninstall các Chart bằng các tương tác với Kubernetes cluster.

Tóm lại là Helm client chịu trách nhiệm quản lý các Chart, còn Tilter server chịu trách nhiệm quản lý các Release.

**Helm Charts**: Helm quản lý các resource packags thông qua Chart.

## 4. Chart
Chart là một cây thông tin cho các package, nó bao gồm một vài YAML file dành cho việc định nghĩa chart và một số template file dành cho việc tạo các file manifest trong Kubernetes theo một số config riêng biệt. Sau đây là một Chart cơ bản:
```sh
package-name/
  charts/
  templates/
  Chart.yaml
  LICENSE
  README.md
  requirements.yaml
  values.yaml
```
Vai trò của các file và thư mục như sau:
- **charts/:** những chart phụ thuộc có thể để vào đây tuy nhiên vẫn nên dùng requirements.yaml để link các chart phụ thuộc linh động hơn.
- **templates/:** chứa những template file để khi kết hợp với giá trị config (từ `values.yaml` và command-line) tạo thành các manifest file cho Kubernetes. Lưu ý: template file sử dụng format của ngôn ngữ lập trình Go.
- **Chart.yaml/:** file yaml với metadata chứa các thông tin như name, version...
- **LICENSE/:** license cho việc sử dụng Chart.
- **README.md/:** thông tin cho users của chart.
- **requirements.yaml/:** file yaml chứa danh sách các chart phụ thuộc.
- **values.yaml/:** file yaml chứa giá trị config mặc định cho Chart.

Lệnh `helm` có hể được cài đặt một chart từ một local directory hoặc từ một packaged version `.tar.gz` của kiến trúc thư mục này. Các packaged chart có thể tự động download và cài đặt từ chart repositories hoặc repos.

## 5. Chart Configuration
Các config mặc định của một Chart nằm ở file `values.yaml` và có thể được thay đổi.

Các config của một Chart có thể được thay đổi thông qua command-line flag hoặc bằng cách tạo ra file config.yaml nằm ngoài thư mục Chart. Khi đó các biến của `config.yaml` sẽ ghi đè lên `values.yaml`.

## 6. Release
Khi cài đặt Chart, Helm kết hợp các template của Chart với các config (mặc định hoặc user ghi đè lên) để tạo nên các manifest file được deploy thông qua Kubernetes API. Khi đó một Release sẽ được tạo ra, đây là một "running instance" của Chart trên Kubernetes cluster.

Việc chia ra các Release rất hữu ích khi chúng ta muốn deploy hàng loạt các ứng dụng cùng loại trên cùng một cluster. Ví dụ như chúng ta muốn nhiều MySQL servers với các config khác nhau. Khi đó các Release sẽ giúp deploy nhanh chóng và giúp tránh việc xung đột các metadata của các resource (điển hình nhất là việc đặt tên). Việc upgrade/rollback hay uninstall từng Release cũng dễ dàng khi thông tin từng Release được lưu cụ thể.

## 7. Creating Charts
Có thể tự tạo chart. Helm có thể xuất ra output của 1 chart directory với `helm create chart-name`. Nó sẽ tạo ra 1 folder với files và directories.

## Tài liệu tham khảo
- https://www.digitalocean.com/community/tutorials/an-introduction-to-helm-the-package-manager-for-kubernetes
