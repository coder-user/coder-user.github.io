---
weight: 1
title: "【redis】最简单的Redis学习环境部署- docker篇"
date: 2020-12-21T23:23:32+08:00
lastmod: 2020-12-21T23:23:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "最简单的redis学习环境部署方法."
#resources:
#- name: "featured-image"
#  src: "featured-image.png"
tags: ["编程"]
categories: ["编程"]

lightgallery: true

toc:
  auto: false
---
<!--more-->

## 简介

学习redis和学习编程语言一样，学习之前需要把环境安装好，能实践的学习。今天主要介绍一下，redis的docker学习环境安装方法。

## 下载redis镜像

- 拉取 Redis 镜像, 选择 `redis:alpine` 轻量级镜像版本：

  `docker pull redis:alpine`

## 运行容器

``` bash
docker run -p 6379:6379 --name redis -v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf -v /usr/local/docker/redis/data:/data -d redis:alpine redis-server /etc/redis/redis.conf --appendonly yes
```

命令说明：

- `-p 6379:6379`: 将容器的 6379 端口映射到宿主机的 6379 端口；
- `-v /usr/local/docker/redis/data:/data` : 将容器中的 /data 数据存储目录, 挂载到宿主机中 /usr/local/docker/redis/data 目录下；
- `-v /usr/local/docker/redis/redis.conf:/etc/redis/redis.conf` ： 将容器中 /etc/redis/redis.conf 配置文件，挂载到宿主机的 /usr/local/docker/redis/redis.conf 文件上；
- `redis-server --appendonly yes`: 在容器执行 redis-server 启动命令，并打开 redis 持久化配置;

## 连接刚刚创建好的容器

`docker run -it redis:alpine redis-cli -h 172.17.0.1`

- 是不是ok了，开始你的测试吧

## 总结

简单介绍redis的docker测试环境的安装过来，快去实践吧。