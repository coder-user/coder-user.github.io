---
weight: 1
title: "【开发工具】Postman的基础使用说明"
date: 2021-03-06T21:39:32+08:00
lastmod: 2021-03-06T21:39:32+08:00
draft: true
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "在代码的自测过程中和编译过程中，需要很频繁的使用到postman工具，需要学习一些基础使用以及技巧来避免一些频繁的操作."
resources:
- name: "featured-image"
  src: "featured-image.jpg"

tags: ["开发工具"]
categories: ["开发工具"]

lightgallery: true
toc:
  auto: false
---
<!--more-->
## 1 简介
  在代码的自测过程中和编译过程中，需要很频繁的使用到`postman`工具，需要学习一些基础使用以及技巧来避免一些频繁的操作.

## 2 基本使用

## 3 常用的技巧
### 3.1 获取返回值设置为环境变量
```
//把json字符串转化为对象
var data=JSON.parse(responseBody);
//获取data对象的token值。
var token=data.access_token;
//设置成全局变量
pm.environment.set("access_token", token)
```

## 总结
- 学习`Postman`的基础使用方式和相关使用技巧，对日后的开发测试尽早做好相关的准备。