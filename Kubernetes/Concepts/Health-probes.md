# Health probes
## 1. Liveness Probes
Thông qua Liveness Probe, kubelet có thể thực hiện 3 loại check để đảm bảo Pod không chỉ running mà còn sẵn sàng nhận và phản hồi các requests:
- Thực hiện 1 HTTP request tới Pod. Code phản hồi từ 200 đến 399. Code 5xx và 4xx là Pod gặp sự cố.
- Với Pod expose non-HTTP services (Postfix mail server), check kết nối TCP thành công.
- Thực hiện command trong Pod. Check thành công nếu Code trả về là 0

Xem xét ví dụ file `yaml` sau:
```sh
$ vim pod.yaml
apiVersion: v1
kind: Pod
metadata:
 name: node500
spec:
 containers:
   - image: magalix/node500
     name: node500
     ports:
       - containerPort: 3000
         protocol: TCP
     livenessProbe:
       httpGet:
         path: /
         port: 3000
       initialDelaySeconds: 5
```
Trong phần `.spec.containers.livenessProbe`. Tham số `httpGet` chấp nhận đường dẫn nó gửi HTTP GET request. `livenessProbe` cũng cho phép tham số `initialDelaySeconds` chỉ định thời gian chờ trước khi starting. 
 
Sử dung command `kubectl describe` để kiểm tra:
```sh
$ kubectl describe pods node500

Events:
Type 	   Reason             	Age                    From                         Message
---- 	   ------             	----                   ----                         -------
Normal   Scheduled          	5m30s                  default-scheduler            Successfully assigned node500 to docker-for-desktop
Normal   SuccessfulMountVolume  5m29s                  kubelet, docker-for-desktop  MountVolume.SetUp succeeded for volume "default-token-ddpbc"
Normal   Created            	3m35s (x3 over 5m24s)  kubelet, docker-for-desktop  Created container
Normal   Started            	3m35s (x3 over 5m24s)  kubelet, docker-for-desktop  Started container
Warning  Unhealthy          	3m18s (x7 over 5m18s)  kubelet, docker-for-desktop  Liveness probe failed: HTTP probe failed with statuscode: 500
Normal   Pulling            	2m48s (x4 over 5m29s)  kubelet, docker-for-desktop  pulling image "afakharany/node500"
Normal   Pulled             	2m46s (x4 over 5m24s)  kubelet, docker-for-desktop  Successfully pulled image "afakharany/node500"
Normal   Killing            	18s (x6 over 4m28s)    kubelet, docker-for-desktop  Killing container with id docker://node500:Container failed liveness probe.. Container will be killed and recreated.
```
Nếu quan tâm cách NodeJS application được lập trình, đây là file `app.js` và `Dockerfile` được sử dụng:

***app.js***
```sh
var http = require('http');

var server = http.createServer(function(req, res) {
	res.writeHead(500, { "Content-type": "text/plain" });
	res.end("We have run into an error\n");
});

server.listen(3000, function() {
	console.log('Server is running at 3000')
})
```
***Dockerfile***
```sh
FROM node
COPY app.js /
EXPOSE 3000
ENTRYPOINT [ "node","/app.js" ]
```

## 2. Readiness Probes

Readiness Probes thực hiện check tương tự Liveness Probes (GET requests, TCP connections, and command executions). Tuy nhiên cách khắc phục khác nhau. Không restarting container lỗi mà cô lập khỏi traffic đến.

Xem xet ví dụ về file `pod.yaml` dưới đây:
```sh
apiVersion: v1
kind: Pod
metadata:
 name: nodedelayed
spec:
 containers:
   - image: afakharany/node_delayed
     name: nodedelayed
     ports:
       - containerPort: 3000
         protocol: TCP
     readinessProbe:
       httpGet:
         path: /
         port: 3000
       timeoutSeconds: 2
```
**Deploy app và kiểm tra**
```sh
$ kubectl apply -f pod.yaml
$ kubectl describe pods nodedelayed
Events:
Type 	Reason             	Age           	  From                         Message
---- 	------             	----          	  ----                         -------
Normal   Scheduled          	58s           	  default-scheduler            Successfully assigned nodedelayed to docker-for-desktop
Normal   SuccessfulMountVolume  58s           	  kubelet, docker-for-desktop  MountVolume.SetUp succeeded for volume "default-token-ddpbc"
Normal   Pulling            	57s           	  kubelet, docker-for-desktop  pulling image "afakharany/node_delayed"
Normal   Pulled             	53s           	  kubelet, docker-for-desktop  Successfully pulled image "afakharany/node_delayed"
Normal   Created            	52s           	  kubelet, docker-for-desktop  Created container
Normal   Started            	52s           	  kubelet, docker-for-desktop  Started container
Warning  Unhealthy          	8s (x5 over 48s)  kubelet, docker-for-desktop  Readiness probe failed: Get http://10.1.0.83:3000/: net/http: request canceled (Client.Timeout exceeded while awaiting headers
```
`kubelet` không restarting Pod khi quá 2s mà hủy bỏ request. Các request được chuyển hướng tới healthy pods khác.

Notice that once the pod is no longer overloaded, the kubelet will start routing requests back to it; as the GET request now does not have delayed responses.

***Đây là file app.js***
```sh
var http = require('http');

var server = http.createServer(function(req, res) {
   const sleep = (milliseconds) => {
       return new Promise(resolve => setTimeout(resolve, milliseconds))
   }
   sleep(5000).then(() => {
       res.writeHead(200, { "Content-type": "text/plain" });
       res.end("Hello\n");
   })
});

server.listen(3000, function() {
   console.log('Server is running at 3000')
})
```
## Tài liệu tham khảo 
- https://www.magalix.com/blog/kubernetes-and-containers-best-practices-health-probes
