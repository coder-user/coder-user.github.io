---
weight: 1
title: "【docker】最简单的Go Dockerfile编写姿势实战"
date: 2020-12-19T10:37:32+08:00
lastmod: 2020-12-19T10:37:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "编写Dockerfile，实现go程序的编译和运行."
resources:
- name: "featured-image"
  src: "featured-image.png"
tags: ["编程"]
categories: ["编程"]

lightgallery: true

toc:
  auto: false
---
编写Dockerfile，实现go程序的编译和运行.

<!--more-->
## 简述

docker是目前微服务部署场景中，非常重要的工具，目前大部分的公司都是使用docker+k8s实现集群化的部署。docker是Go语言编写的，那么今天简单的说明一下Go语言编译与运行的实战，使用多阶段

## 实例

使用多阶段构建的docker镜像的实例，实践，测试可用，应该可以直接用。

```bash
# 使用golang:1.15.6-alpine3.12作为编译的基础镜像
FROM golang:1.15.6-alpine3.12 AS builder

# 相关的标签
LABEL version="golang:1.15.6-alpine3.12" \
	description="make go meeting ctrl" \
  author="Coolliuzw" \
	stage=builder

# go环境变量配置
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOPROXY=https://goproxy.cn,direct \
    GOARCH=amd64
ENV APP_NAME="main"

# 编译的工作目录
WORKDIR /build/go

## 使用aliyun的镜像加速服务.
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# go mod 的镜像下载，可以缓存
ADD go.mod .
ADD go.sum .
RUN go mod download

# 编译go程序
COPY . .
RUN go build -ldflags="-s -w" -o ${APP_NAME}

# 使用最小镜像运行
FROM alpine:3.12

## 使用aliyun的镜像加速服务.
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 安装相关需要的工具包
RUN apk update \
 && apk add ca-certificates \
    -U tzdata \
    bash \
    bash-doc \
    bash-completion \
    ca-certificates \
    && rm -rf /var/cache/apk/*

## 设置时区信息
RUN rm -rf /etc/localtime && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 运行目录的构建
ENV APP_BUILD /build/go
ENV APP_NAME main
ENV APP_ROOT root/opt/${APP_NAME}
# RUN mkdir -p ${APP_ROOT}

#暴露端口
EXPOSE 8080

# 工作目录
WORKDIR ${APP_ROOT}

COPY --from=builder ${APP_BUILD}/${APP_NAME} ./bin/${APP_NAME}

CMD ./bin/${APP_NAME}
```

`docker build -t coolliuzw:go .`

### 清除未使用镜像

- 方法一

  `docker rmi $(sudo docker images --filter dangling=true -q)`

- 方法二

  ```bash
  // 清除构建的中间镜像
  FROM node as builder
  LABEL stage=builder
  ...
  
  FROM node:dubnium-alpine
  
  docker image prune --filter label=stage=builder
  ```

- 方法三

  `docker  system  prune`

## 总结

实践测试，构建简单的http服务程序

`coolliuzw                         go                  7f9b79a9e681   7 minutes ago   19.7MB`

测试成功





[comment]: <https://juejin.cn/post/6904508173328547854> "This is a comment, it will not be included"

