---
weight: 1
title: "【微服务】为什么说做好微服务很难？"
date: 2020-12-22T23:37:32+08:00
lastmod: 2020-12-22T23:37:32+08:00
draft: true
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "简单的介绍做好微服务需要学习的知识点."
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

要想做好微服务，我们需要理解和掌握的知识点非常多，从几个维度上来说：



- 基本功能层面

1. 1. 并发控制&限流，避免服务被突发流量击垮
   2. 服务注册与服务发现，确保能够动态侦测增减的节点
   3. 负载均衡，需要根据节点承受能力分发流量
   4. 超时控制，避免对已超时请求做无用功
   5. 熔断设计，快速失败，保障故障节点的恢复能力

- 高阶功能层面

1. 1. 请求认证，确保每个用户只能访问自己的数据
   2. 链路追踪，用于理解整个系统和快速定位特定请求的问题
   3. 日志，用于数据收集和问题定位
   4. 可观测性，没有度量就没有优化