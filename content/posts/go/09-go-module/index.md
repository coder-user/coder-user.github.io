---
weight: 1
title: "【Go】go mod 的基础使用"
date: 2020-12-20T21:44:06+08:00
lastmod: 2020-12-20T21:44:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "简单的介绍一下go mod的基础使用。"
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

## 简述

简单的介绍一下go mod的基础使用，由于我开始学习Go的时间比较晚，已经大部分的项目都是从GoPath到Go mod的转换了，统一使用go.mod的方式管理，所以没有遇到什么难题，但是具体怎么使用也不太清楚，今天一起来学习一下go mod的使用方法。

## 什么是go module？

- **module**是一个相关**GO**包的集合，它是源代码更替和版本控制的单元。

- 模块由源文件形成的`go.mod`文件的根目录定义，包含`go.mod`文件的目录也被称为模块根

## go.mod文件

`go.mod`文件定义`module`路径以及列出其他需要在`build`时引入的模块的特定的版本。

`go.mod`文件用`//`注释，而不用`/**/`。文件的每行都有一条指令，由一个动作加上参数组成。

三个动词`require`、`exclude`、`replace`分别表示：项目需要的依赖包及版本、排除某些包的特别版本、取代当前项目中的某些依赖包

有一个专门的命令`go mod tidy`，用来查看和添加缺失的`module`需求声明以及移除不必要的

eg:

```go
module example.com/m

require (
    golang.org/x/text v0.3.0
    gopkg.in/yaml.v2  v2.1.0
)
```

# 具体使用步骤:

1. 首先将你的版本更新到最新的Go版本(>=1.11)，如何更新版本可以自行百度。
2. 通过go命令行，进入到你当前的工程目录下，在命令行设置临时环境变量`set GO111MODULE=on`；
3. 执行命令`go mod init`在当前目录下生成一个`go.mod`文件，执行这条命令时，当前目录不能存在`go.mod`文件。如果之前生成过，要先删除；
4. 如果你工程中存在一些不能确定版本的包，那么生成的`go.mod`文件可能就不完整，因此继续执行下面的命令；
5. 执行`go mod tidy`命令，它会添加缺失的模块以及移除不需要的模块。执行后会生成`go.sum`文件(模块下载条目)。添加参数`-v`，例如`go mod tidy -v`可以将执行的信息，即删除和添加的包打印到命令行；
6. 执行命令`go mod verify`来检查当前模块的依赖是否全部下载下来，是否下载下来被修改过。如果所有的模块都没有被修改过，那么执行这条命令之后，会打印`all modules verified`。
7. 执行命令`go mod vendor`生成vendor文件夹，该文件夹下将会放置你`go.mod`文件描述的依赖包，文件夹下同时还有一个文件`modules.txt`，它是你整个工程的所有模块。在执行这条命令之前，如果你工程之前有vendor目录，应该先进行删除。同理`go mod vendor -v`会将添加到vendor中的模块打印出来；

## 总结
- `go mod init`和`go mod tidy`两个主要的命令记住就行。
- `go get `(下载依赖的包)和`go get -u`（更新依赖的包到最新版本）