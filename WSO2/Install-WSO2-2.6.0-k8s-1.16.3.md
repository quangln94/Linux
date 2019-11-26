**Command**
```sh
sudo groupadd --system -g 802 wso2
sudo useradd --system -g 802 -u 802 wso2carbon

export username=ngocquang.ptit@gmail.com
export password=123456aA@

./deploy.sh --wu=$username --wp=$password
```
**Sửa file `wso2apim-deployment.y`**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2apim-with-analytics-apim
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: wso2apim-with-analytics-apim
  minReadySeconds: 30
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        deployment: wso2apim-with-analytics-apim
    spec:
      containers:
      - name: wso2apim-with-analytics-apim-worker
        image: docker.wso2.com/wso2am:2.6.0
        livenessProbe:
          exec:
            command:
            - /bin/bash
            - -c
            - nc -z localhost 9443
          initialDelaySeconds: 100
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
              - /bin/bash
              - -c
              - nc -z localhost 9443
          initialDelaySeconds: 100
          periodSeconds: 10
        imagePullPolicy: Always
        resources:
          requests:
            memory: "2Gi"
            cpu: "2000m"
          limits:
            memory: "3Gi"
            cpu: "3000m"
        ports:
        -
          containerPort: 8280
          protocol: "TCP"
        -
          containerPort: 8243
          protocol: "TCP"
        -
          containerPort: 9763
          protocol: "TCP"
        -
          containerPort: 9443
          protocol: "TCP"
        -
          containerPort: 5672
          protocol: "TCP"
        -
          containerPort: 9711
          protocol: "TCP"
        -
          containerPort: 9611
          protocol: "TCP"
        -
          containerPort: 7711
          protocol: "TCP"
        -
          containerPort: 7611
          protocol: "TCP"
        volumeMounts:
        - name: apim-storage-volume
          mountPath: /home/wso2carbon/wso2am-2.6.0/repository/deployment/server
        - name: apim-conf
          mountPath: /home/wso2carbon/wso2-config-volume/repository/conf
        - name: apim-conf-datasources
          mountPath: /home/wso2carbon/wso2-config-volume/repository/conf/datasources
      serviceAccountName: "wso2svc-account"
      imagePullSecrets:
      - name: wso2creds
      volumes:
      - name: apim-storage-volume
        persistentVolumeClaim:
          claimName: wso2apim-with-analytics-apim-deployment-volume-claim
      - name: apim-conf
        configMap:
          name: apim-conf
      - name: apim-conf-datasources
        configMap:
          name: apim-conf-datasources
```
**Sửa file `wso2apim-analytics-depl`**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2apim-with-analytics-apim-analytics-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: wso2apim-with-analytics-apim-analytics
  minReadySeconds: 30
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
    type: RollingUpdate
  template:
    metadata:
      labels:
        deployment: wso2apim-with-analytics-apim-analytics
    spec:
      containers:
      - name: wso2apim-with-analytics-apim-analytics
        image: docker.wso2.com/wso2am-analytics-worker:2.6.0
        resources:
          limits:
            memory: "4Gi"
          requests:
            memory: "4Gi"
        livenessProbe:
          exec:
            command:
            - /bin/sh
            - -c
            - nc -z localhost 7712
          initialDelaySeconds: 15
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
              - /bin/sh
              - -c
              - nc -z localhost 7712
          initialDelaySeconds: 15
          periodSeconds: 10
        lifecycle:
          preStop:
            exec:
              command:  ['sh', '-c', '${WSO2_SERVER_HOME}/bin/worker.sh stop']
        imagePullPolicy: Always
        securityContext:
          runAsUser: 802
        ports:
        -
          containerPort: 9764
          protocol: "TCP"
        -
          containerPort: 9444
          protocol: "TCP"
        -
          containerPort: 7612
          protocol: "TCP"
        -
          containerPort: 7712
          protocol: "TCP"
        -
          containerPort: 9091
          protocol: "TCP"
        -
          containerPort: 7071
          protocol: "TCP"
        -
          containerPort: 7444
          protocol: "TCP"
        volumeMounts:
        - name: apim-analytics-conf-worker
          mountPath: /home/wso2carbon/wso2-config-volume/conf/worker
      serviceAccountName: "wso2svc-account"
      imagePullSecrets:
      - name: wso2creds
      volumes:
      - name: apim-analytics-conf-worker
        configMap:
          name: apim-analytics-conf-worker
```
**Sửa file `mysql-deployment.yaml`**
```sh
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wso2apim-with-analytics-mysql-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      deployment: wso2apim-with-analytics-mysql
  template:
    metadata:
      labels:
        deployment: wso2apim-with-analytics-mysql
    spec:
      containers:
      - name: wso2apim-with-analytics-mysql
        image: mysql:5.7
        imagePullPolicy: IfNotPresent
        securityContext:
          runAsUser: 999
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: root
        - name: MYSQL_USER
          value: wso2carbon
        - name: MYSQL_PASSWORD
          value: wso2carbon
        ports:
        - containerPort: 3306
          protocol: TCP
        volumeMounts:
        - name: mysql-dbscripts
          mountPath: /docker-entrypoint-initdb.d
        - name: apim-rdbms-persistent-storage
          mountPath: /var/lib/mysql
        args: ["--max-connections", "10000"]
      volumes:
      - name: mysql-dbscripts
        configMap:
          name: mysql-dbscripts
      - name: apim-rdbms-persistent-storage
        persistentVolumeClaim:
          claimName: wso2apim-with-analytics-rdbms-volume-claim
      serviceAccountName: "wso2svc-account"
```
## Tài liệu tham khảo
- https://medium.com/@andriperera.98/how-to-deploy-wso2-api-manager-in-production-grade-kubernetes-268a65a41fa2
