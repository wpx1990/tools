#### 制作镜像
```
docker build -f ./Dockerfile -t ubuntu:20.04-ssh ./
```

#### 在docker上运行
```
docker run -d -p 10022:22 ubuntu:20.04-ssh
```

#### 在K8S上运行
```
apiVersion: v1
kind: Pod
metadata:
  name: test-ssh
  labels:
    app: test-ssh
spec:
  containers:
  - name: ssh
    image: 10.15.42.160:5000/ubuntu:20.04-ssh
    imagePullPolicy: IfNotPresent
    ports:
    - containerPort: 22
      protocol: TCP
  nodeName: master1
---
apiVersion: v1
kind: Service
metadata:
  labels:
    service: test-ssh
  name: test-ssh
spec:
  ports:
  - port: 22
    targetPort: 22
    protocol: TCP
    nodePort: 32022
  selector:
    app: test-ssh
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 10800
  type: NodePort
```