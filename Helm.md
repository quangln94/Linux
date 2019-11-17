# Helm là gì
Deploy một ứng dụng lên Kubernetes cluster - đặc biệt là các ứng dụng phức tạp - đòi hỏi việc tạo một loạt các resource của ứng dụng đó, ví dụ như Pod, Service, Deployment, ReplicaSet ... . Mỗi resource lại yêu chúng ta phải viết một file YAML chi tiết cho nó để deploy. Điều đó dẫn đến các thao tác CRUD trên một loạt các resource này trở nên phức tạp, mất thời gian, dễ bị bỏ sót và gặp vấn đề về tái sử dụng hay chia sẻ cho người khác.

Như Ubuntu có apt, Centos có yum, tương tự Helm đóng vai trò là một Package Manager cho Kubernetes. Việc cài đặt các resource Kubernetes sẽ được thông qua và quản lý trên Helm.
