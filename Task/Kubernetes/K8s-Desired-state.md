# Desired state

Mô hình khai báo và khái niệm trạng thái mong muốn là trọng tâm của Kubernetes. Mang chúng đi và Kubernetes vỡ vụn.

Trong Kubernetes, declarative model làm việc như sau:
- Khai báo trạng thái mong muốn của ứng dụng (microservice) trong manifest file
- POST nó lên Kubernetes API server
- Kubernetes lưu trữ chúng trong cluster store dưới dạng trạng thái mong muốn của ứng dụng
- Kubernetes triển khai trạng thái mong muốn trên cluster
- Kubernetes thực hiện các vòng lặp đồng hồ để đảm bảo trạng thái hiện tại của ứng dụng giống trạng thái mong muốn

Manifest files viết trong YAML và chúng nói cho Kubernetes cách chúng ta muốn 1 application trông như thế nào. Chúng ta gọi nó là desired state. Nó bao gồm những thứ như: image được sử dụng, có bao nhiêu replicas, network ports nào để listen và cách perform updates.

Khi tạo ra manifest, ta POST nó lên API server. Cách phổ biến nhất để làm điều này là với tiện ích kubectl command-line. POSTs manifest này như 1 request tới control plane thường là port 443.

Khi yêu cầu được xác thực và ủy quyền, Kubernetes kiểm tra manifest, xác định controller nào sẽ gửi nó đến (ví dụ: Deployments controller) và ghi lại cấu hình trong cluster store như 1 phần của cluster’s overall desired state. Một khi điều này được thực hiện, task được lên lịch trên cluster. Bao gồm việc pull image, starting containers, building networks và starting the application’s processes.

Cuối cùng, Kubernetes sử dụng các background reconciliation loops theo dõi trạng thái của cluster. Nếu trạng thái hiện tại của cluster thay đổi khác với trạng thái mong muốn, Kubernetes sẽ thực hiện bất kỳ nhiệm vụ nào là cần thiết để giải quyết vấn đề.

<img src=https://i.imgur.com/kjpM4w1.png>
