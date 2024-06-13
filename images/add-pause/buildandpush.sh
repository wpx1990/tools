#! /bin/bash

BASE_IMAGE=ubuntu:20.04
DOCKERFILE_PATH=go-pause
HARBOR_ADDR=tj.inner1.harbor.com/tools/

DOCKERFILE=Dockerfile
IMAGE_NAME=$BASE_IMAGE-add-pause
IMAGE_NAME_LINUX_AMD64=$IMAGE_NAME-linux-amd64
IMAGE_NAME_LINUX_ARM64V8=$IMAGE_NAME-linux-arm64v8

cd ./$DOCKERFILE_PATH

# linux amd64镜像制作
docker build -f ./$DOCKERFILE -t $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64 --platform=linux/amd64 --build-arg base_image=$BASE_IMAGE ./
docker push $HARBOR_ADDR$IMAGE_NAME_LINUX_AMD64

# linux arm64v8镜像制作
docker build -f ./$DOCKERFILE -t $HARBOR_ADDR$IMAGE_NAME_LINUX_ARM64V8 --platform=linux/arm64/v8 --build-arg base_image=$BASE_IMAGE ./
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

# 删除dangling镜像
echo y | docker image prune

cd -