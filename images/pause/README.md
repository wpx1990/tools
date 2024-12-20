## 1、K8S启动POD

修改container的启动命令：

```
command: ["/bin/sh"]
args: ["-c", "while true; do echo hello; sleep 10; done"]
```