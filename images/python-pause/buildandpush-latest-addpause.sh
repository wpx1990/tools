#! /bin/bash

VERSION=cpu-latest-addpause

IMAGE_NAME=algorithm_base:$VERSION
IMAGE_NAME_LINUX_AMD64=$IMAGE_NAME-linux-amd64
IMAGE_NAME_LINUX_ARM64V8=$IMAGE_NAME-linux-arm64v8

HARBOR_ADDR=tj.inner1.harbor.com/algorithms/

DOCKERFILE=Dockerfile

# linux amd64镜像制作
docker build -f ./$DOCKERFILE -t $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64 --platform=linux/amd64 ./
docker push $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64

# linux arm64v8镜像制作
docker build -f ./$DOCKERFILE -t $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8 --platform=linux/arm64/v8 ./
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

# 删除dangling镜像
echo y | docker image prune