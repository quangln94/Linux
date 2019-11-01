# Deploying apps with Docker Stacks

Deploying và managing multi-service apps at scale là việc khó khăn.

Docker Stacks đơn giản hóa việc quản lý ứng dụng bằng cách desired state, rolling updates, simple, scaling operations, health checks...Tất cả được bọc trong một mô hình khai báo tốt đẹp.

Điều này rất đơn giản. Xác định app của bạn trong Compose file, sau đó deploy và manage nó với command `docker stack deploy`

Compose file bao gồm toàn bộ chồng dịch vụ tạo nên ứng dụng. Nó cũng bao gồm tất cả volumes, networks, secrets và cơ sở hạ tầng khác mà ứng dụng cần

Bạn sử dụng command `docker stack deploy` để deploy app từ file

Để thực hiện tất cả điều này, stacks build on top của Docker Swarm, nghĩa là bạn có được tất cả các tính năng bảo mật và nâng cao đi kèm với Swarm.

## Deploying apps with Docker Stacks

Nếu bạn biết Docker Compose, bạn sẽ thấy Docker Stacks thực sự dễ dàng. Trên thực tế, theo nhiều cách, stacks là thứ mà chúng ta luôn mong muốn Compose - được tích hợp hoàn toàn vào Docker và có thể quản lý toàn bộ vòng đời của các ứng dụng.

Về mặt kiến trúc, stacks nằm ở đầu phân cấp ứng dụng Docker. Stacks build on top of services, service turn build on top of containers

<img src=https://i.imgur.com/25sn89a.png>

## Overview of the sample app

Chúng ta sẽ sử dụng 1 demo app phổ biến AtSea Shop trên GitHub và là Open-sourced under the Apache 2.0 license

Chúng ta sử dụng app này bởi vì nó có độ phức tạp vừa phải mà không quá lớn để liệt kê và mô tả trong một cuốn sách

Bên trong công nghệ nó có một ứng dụng multi-technology microservices sử dụng certificates và secrets

<img src=https://i.imgur.com/r8rnRlG.png>

Như ta thấy, nó bao gồm 5 Services, 3 networks, 4 secrets, và 3 port mappings

Chúng tôi sẽ thấy từng chi tiết này khi chúng tôi kiểm tra stack file.

***Lưu ý: Khi đề cập đến các service trong chương này, chúng tôi nói về Docker Services (một tập hợp các container được quản lý dưới dạng một object và service object tồn tại trong Docker API)***

Clone application’s GitHub repo để bạn có tất cả các application source files trên máy cục bộ của mình
```sh
$ git clone https://github.com/dockersamples/atsea-sample-shop-app.git
Cloning into 'atsea-sample-shop-app'...
remote: Counting objects: 636, done.
remote: Total 636 (delta 0), reused 0 (delta 0), pack-reused 636
Receiving objects: 100% (636/636), 7.23 MiB | 28.25 MiB/s, done.
Resolving deltas: 100% (197/197), done.
```
Ứng dụng này bao gồm một số thư mục và source files. Hãy khám phá tất cả. Tuy nhiên, ta sẽ tập trung vào file `docker-stack.yml`. Chúng tôi sẽ gọi đây là file stack, vì điều này xác định app và các yêu cầu của nó

Ở level cao nhất, nó xác định 4 top-level key:
- version
- services
- networks
- secrets

Version cho biết version của định Compose file. Điều này phải là 3.0 hoặc cao hơn để làm việc với stacks. Services là nơi xác định stack of services tạo nên ứng dụng. Networks liệt kê các networks cần thiết và secrets xác định secrets mà ứng dụng sử dụng

Nếu ta mở rộng từng top-level key, ta sẽ xem cách mọi thứ ánh xạ tới Hình 14.1. Stack file có 5 services được gọi là `reverse_proxy`, `database`, `appserver`, `visualizer`,và `payment_gateway`. Stack file có 3 network được gọi là `front-tier`, `back-tier`, và `payment`. Cuối cùng stack file có 4 secrets được gọi là `postgres_password`, `staging_token`, `revprox_key`, và `revprox_cert`
```sh
version: "3.2"
services:
      reverse_proxy:
      database:
      appserver:
      visualizer:
      payment_gateway:
networks:
      front-tier:
      back-tier:
      payment:
secrets:
      postgres_password:
      staging_token:
      revprox_key:
      revprox_cert:
```
Điều quan trọng để hiểu rằng stack file captures và xác định nhiều yêu cầu của toàn bộ ứng dụng. Như vậy, nó là một dạng application self-documentation và một công cụ tuyệt vời để thu hẹp khoảng cách giữa dev và ops

## Looking closer at the stack file

Stack file là 1 Docker Compose file. Yêu cầu duy nhất là version: key chỉ định giá trị là 3.0 trở lên.

Một trong những điều đầu tiên Docker làm khi triển khai một ứng dụng từ stack file, là kiểm tra và tạo các network list trong  network: key. Nếu network chưa tồn tại, Docker sẽ tạo chúng.

Xem network được chỉ định trong stack file.
```sh
networks:
      front-tier:
      back-tier:
      payment:
            driver: overlay
            driver_opts:
                  encrypted: 'yes'
```
Có 3 network được chỉ định: `front-tier`, `back-tier`, và `payment`. Mặc định tất cả được tạo như overlay networks bởi overlay driver. Nhưng `payment` là được biệt, nó yêu cầu mã hóa data plane.

Mặc định control plane của tất cả overlay networks đều được mã hóa. Để mã hóa data plane, ta có 2 lựa chọn: 
- Truyền vào flag `-o encrypted` tới lệnh `docker network create`
- Chỉ định `encrypted: 'yes'` bên dưới `driver_opts` trong stack file.

Chi phí phát sinh bằng cách mã hóa data plane phụ thuộc vào các yếu tố khác nhau như loại lưu lượng và lưu lượng truy cập. Tuy nhiên, hy vọng nó sẽ nằm trong khoảng 10%.

## Secrets

Secrets được chỉ định nhừ là top-level objects, và stack file chúng ta chỉ định 4:
```sh
secrets:
      postgres_password:
            external: true
      staging_token:
            external: true
      revprox_key:
            external: true
      revprox_cert:
            external: true
```
Chú ý rằng tất cả đều được chỉ định là `external`. Có nghĩa là chúng phải tồn tại trước khi stack có thể deployed

Có thể các secrets được tạo theo yêu cầu khi ứng dụng được triển khai, chỉ cần thay thế `external: true` với `file: <filename>`. Tuy nhiên, để nó hoạt động 1 plaintext file chứa giá trị không được mã hóa phải tồn tại trên host’s filesystem. Điều này có ý nghĩa bảo mật rõ ràng.

Chúng ta sẽ thấy cách tạo ra secrets khi triển khai ứng dụng. Cho đến bây giờ, nó đủ để biết rằng ứng dụng xác định 4 secrets cần tạo trước.

## Services

## Tài liệu tham khảo
- Docker Deep Dive Zero to Docker in a single book! - Nigel Poulton
