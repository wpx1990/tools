#### 制作镜像
```
sh buildandpush.sh
```

#### 在docker上运行
```
docker run -it --rm ubuntu:20.04-add-pause
```

#### 在K8S上运行
```
apiVersion: v1
kind: Pod
metadata:
  name: test-add-pause
  labels:
    app: test-add-pause
spec:
  containers:
  - name: add-pause
    image: ubuntu:20.04-add-pause
    imagePullPolicy: IfNotPresent
  nodeSelector:
    kubernetes.io/hostname: k8s-edge
```