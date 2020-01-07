# Custom Exporter with Prometheus

## Bước 1: Add custom exporter
```sh
mkdir -p /code
cat << EOF > /code/collector.py
import time
from prometheus_client.core import GaugeMetricFamily, REGISTRY, CounterMetricFamily
from prometheus_client import start_http_server


class CustomCollector(object):
    def __init__(self):
        pass

    def collect(self):
        g = GaugeMetricFamily("MemoryUsage", 'Help text', labels=['instance'])
        g.add_metric(["instance01.us.west.local"], 20)
        yield g

        c = CounterMetricFamily("HttpRequests", 'Help text', labels=['app'])
        c.add_metric(["example"], 2000)
        yield c


if __name__ == '__main__':
    start_http_server(8000)
    REGISTRY.register(CustomCollector())
    while True:
        time.sleep(1)
EOF
```
## Bước 2: Dockerize

Đảm bảo có pip-requirements:
```sh
cat /code/pip-requirements.txt
prometheus_client
```
Dockerfile
```sh
FROM python:3.6

ADD code /code
RUN pip install -r /code/pip-requirements.txt

WORKDIR /code
ENV PYTHONPATH '/code/'

CMD ["python" , "/code/collector.py"]
```
## Bước 3: Deploy the collector on Kubernetes.
```sh
mkdir -p /yaml
cat << EOF > /yaml/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus-custom-collector-deployment
  labels:
    app: prometheus-custom-collector
spec:
  replicas: 1
  selector:
    matchLabels:
      app: prometheus-custom-collector
  template:
    metadata:
      labels:
        app: prometheus-custom-collector
    spec:
      containers:
      - name: prometheus-custom-collector
        image: kubejack/prometheus-custom-collector:0.2
        ports:
        - containerPort: 80
``` 

```sh
cat << EOF > /yaml/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: prometheus-custom-collector-service
spec:
  selector:
    app: prometheus-custom-collector
  type: NodePort
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8000
EOF    
```
Thực hiện deploy
```sh
kubectl create -f yaml/
```
## Tài liệu tham khảo
- https://medium.com/@ikod/custom-exporter-with-prometheus-b1c23cb24e7a
- http://michaeljones.tech/writing-exporters-for-prometheus/
- https://collabnix.com/tag/pushgateway/
