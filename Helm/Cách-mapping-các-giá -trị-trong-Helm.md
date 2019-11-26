# Cách Mapping các giá trị trong Helm
## 1. Mở file `values.yaml`
```
[root@server01 ~]# helm create test01
Creating test01
[root@server01 ~]# cd test01/
[root@server01 test01]# ls
charts  Chart.yaml  templates  values.yaml
[root@server01 test01]# vim values.yaml
# Default values for test01.
# This is a YAML-formatted file.
# Declare variables to be passed into your templates.

replicaCount: 1

image:
  repository: nginx
  tag: stable
  pullPolicy: IfNotPresent

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  # Specifies whether a service account should be created
  create: true
  # The name of the service account to use.
  # If not set and create is true, a name is generated using the fullname template
  name:

podSecurityContext: {}
  # fsGroup: 2000

securityContext: {}
  # capabilities:
  #   drop:
  #   - ALL
  # readOnlyRootFilesystem: true
  # runAsNonRoot: true
  # runAsUser: 1000

service:
  type: ClusterIP
  port: 80

```
**Mở file `deployment.yaml`**
```sh
[root@server01 templates]# vim deployment.yaml
        {{- toYaml . | nindent 8 }}
    {{- end }}
      serviceAccountName: {{ template "test01.serviceAccountName" . }}        # eponymous-tapir-test01
      securityContext::q!
        {{- toYaml .Values.podSecurityContext | nindent 8 }}                  # Không có
      containers:
        - name: {{ .Chart.Name }}                                             # test01
          securityContext:
            {{- toYaml .Values.securityContext | nindent 12 }}                # Không có
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"     # nginx:stable
          imagePullPolicy: {{ .Values.image.pullPolicy }}                     # IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          livenessProbe:
            httpGet:
              path: /
              port: http
          readinessProbe:
            httpGet:
              path: /
              port: http
          resources:
            {{- toYaml .Values.resources | nindent 12 }} 
      {{- with .Values.nodeSelector }}
      nodeSelector:
        {{- toYaml . | nindent 8 }}
      {{- end }}
    {{- with .Values.affinity }}
      affinity:
        {{- toYaml . | nindent 8 }}
    {{- end }}
    {{- with .Values.tolerations }}
      tolerations:
        {{- toYaml . | nindent 8 }}
    {{- end }}
```
**Mở file `service.yaml`**
```sh
apiVersion: v1
kind: Service
metadata:
  name: {{ include "test01.fullname" . }}                                     # eponymous-tapir-test01
  labels:
{{ include "test01.labels" . | indent 4 }}
spec:
  type: {{ .Values.service.type }}                                            # ClusterIP
  ports:
    - port: {{ .Values.service.port }}                                        # 80
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app.kubernetes.io/name: {{ include "test01.name" . }}                     # test01
    app.kubernetes.io/instance: {{ .Release.Name }}                           # eponymous-tapir
``` 
