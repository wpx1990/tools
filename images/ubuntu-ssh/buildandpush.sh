#! /bin/bash

IMAGE_NAME=ubuntu:20.04-ssh
IMAGE_NAME_LINUX_AMD64=$IMAGE_NAME-linux-amd64
IMAGE_NAME_LINUX_ARM64V8=$IMAGE_NAME-linux-arm64v8

HARBOR_ADDR=local-harbor.com/tools/

# linux amd64镜像制作
docker build -f ./Dockerfile -t $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64 --platform=linux/amd64 ./
docker push $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64

# linux arm64v8镜像制作
docker build -f ./Dockerfile -t $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8 --platform=linux/arm64/v8 ./
docker push $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8

# 创建manifest列表
docker manifest create $HARBOR_ADDR$IMAGE_NAME \
  $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64 \
  $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8

# 设置manifest列表
docker manifest annotate $HARBOR_ADDR$IMAGE_NAME $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64 --os linux --arch amd64
docker manifest annotate $HARBOR_ADDR$IMAGE_NAME $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8 --os linux --arch arm64 --variant v8

# 推送manifest列表到镜像仓库
docker manifest push $HARBOR_ADDR$IMAGE_NAME --purge

# docker rmi $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64
# docker rmi $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8