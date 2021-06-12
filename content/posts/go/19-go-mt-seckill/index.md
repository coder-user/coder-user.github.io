---
weight: 1
title: "【Go】jd_mtSeckill 的抢购程序使用教程"
date: 2021-01-10T15:36:06+08:00
lastmod: 2021-01-10T15:36:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "jd_mtSeckill 的抢购程序使用教程."
resources:
- name: "featured-image"
  src: "featured-image.png"
tags: ["go"]
categories: ["go"]

lightgallery: true

toc:
  auto: false
---

<!--more-->

## 1 简述

`Golang` 编写的抢茅台项目 [mtSeckill](https://github.com/zqjzqj/mtSecKill)。之前是有一个`Python`的版本比较火，对`Python`不太了解加上时间关系没有去整，也没有去看源码。现在有`Golang`的版本，自己有着几个月的`Go`编程经验，所以想去学学代码里面并发的思想和精髓。目前初级阶段主要会介绍一下如何使用。

## 2 开始

**准备**

- 必须使用`Google Chrome`浏览器

### 2.1 Go程序开发人员

```bash
# 下载代码
$ git clone https://github.com/zqjzqj/mtSecKill.git

# 进入代码目录
$ cd mtSecKill

# 下载项目相关依赖包，使用go mod的方式
$ go mod tidy

# 运行项目
$ go run cmd/main.go
```

代码会按默认参数进行配置和运行，当然为了使用方便，你也可以编译可运行文件

#### 2.1.1 编译运行程序

```bash
# 运行项目
$ go run cmd/main.go

# 修改为

# 编译可运行程序 可执行文件的名称「coolliuzw」
$ go build -o coolliuzw_mt cmd/main.go

# 运行
$ ./coolliuzw_mt 
服务器与本地时间差为:  182 ms
开始执行时间为： 2021-01-11 09:59:59
```

#### 2.1.2 运行参数说明

其中的参数非常的直观

- **sku**：你抢购的 sku_id，默认是茅台的ID
- **num**：抢购数量，茅台最多 2瓶，设置为2
- **works**：开启多少个浏览器窗口抢购，即工作的线程数
- **time**：抢购时间，注意不是日期，而是时间，时间会自动取未来最近一天的时间。

一般直接使用默认的就可以了，以下是测试手动配置，看看有没有变成10个窗口？

```bash
$ ./coolliuzw_mt -num=2 -works=10 -time=09:59:58 -sku=100012043978

# 默认运行，建议
$ ./coolliuzw_mt
```

### 2.2 非代码开发人员免配置运行

免配置运行，即使用作者变成好的可运行程序，github的release可以下载到相应平台的版本

#### 2.2.1 mac系统

`Mac`系统，终端执行该条命令赋予执行权限  `chmod +x mtSeckill.mac`，然后再执行命令 `./mtSeckill.mac` 运行

#### 2.2.2 window系统

- 下载[mtSecKill.win.exe](https://github.com/zqjzqj/mtSecKill/releases/download/v2.4/mtSecKill.win.exe)
- 双击运行即可

## 3 总结

之前对Go实现浏览器控制操作没有什么了解，通过初步学习源码结构，使用`chromedp`包实现对chrome浏览器的操作控制，后期有时间也打算深度的学习一下源码，说不定，后面`6.18`和`11.11`可以抢点其他的东西。