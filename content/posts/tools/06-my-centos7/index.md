---
weight: 1
title: "【docker】基于centos7的开发镜像构建"
date: 2020-12-26T10:30:32+08:00
lastmod: 2020-12-26T10:30:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "centos7的镜像构建，自定义一个属于自己的docker镜像."
resources:
- name: "featured-image"
  src: "featured-image.jpg"

tags: ["tools"]
categories: ["tools"]

lightgallery: true

toc:
  auto: false
---



<!--more-->

## 简介

平时开发和环境运行的情况，都需要使用到`linux`的环境，但是每个人使用的环境不同，特点也不同。今天来介绍一下怎么自定义自己的docker镜像和打包。

以下介绍以为我的基础镜像。

## 开始

### 获取centos7的基础镜像

`docker pull ansible/centos7-ansible`

### 运行基础镜像

`docker run -d -it --network=host --restart=always --name=my_centos7 --privileged 688353a31fde /usr/sbin/init`

### 进入镜像

`docker exec -it my_centos7 bash`

### centos7切换阿里云源

参考：[设置方法参考链接](https://www.cnblogs.com/WindSun/p/11325859.html)

```bash
curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum  makecache
```

### zsh及插件的安装

插件：

`git zsh-autosuggestions zsh-syntax-highlighting autojump`

```bash
yum -y install zsh

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

yum -y install autojump

vim ~/.zshrc 
plugins=(git zsh-autosuggestions zsh-syntax-highlighting autojump)
ZSH_THEME="ys"
source ~/.zshrc
```

### fzf的安装

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

### 相关高频使用软件安装

```bash
yum -y install vim lrzsz tcpdump telnet gdb gcc gcc-c++ wget git unzip zip bash-completion net-tools yum-plugin-security
```

### go环境安装

```bash
$ wget https://golang.google.cn/dl/go1.15.6.linux-amd64.tar.gz
$ tar -C /usr/local -xzf go1.15.6.linux-amd64.tar.gz
$ rm -fr go1.15.6.linux-amd64.tar.gz
$ vim ~/.zshrc

# 尾行添加
export PATH=$PATH:/usr/local/go/bin
$ source ~/.zshrc

$ go version
go version go1.15.6 linux/amd64
```

#### go mod 和 go proxy 配置

```bash
$ go env -w GO111MODULE=on

$ go env -w GOPROXY="https://goproxy.cn,direct"
```

#### dlv工具安装

```bash
go get github.com/go-delve/delve/cmd/dlv

~/.zshrc
export PATH=$PATH:/root/go/bin
```

### graphviz安装

- pprof分析的时候会用到

```bash
$ yum -y install graphviz
```

### coredump环境配置

```bash
ulimit -c unlimited

$ echo core.%e.%p>/proc/sys/kernel/core_pattern

$ cat /proc/sys/kernel/core_pattern
core.%e.%p
```

### 清除安装缓存

```bash
$ yum clean all
```



## 总结

- 主要介绍了相关的centos插件，`fzf`，`oh-my-zsh`及其插件大量的提高的使用linux的效率，必须学会哦。

~

~

无图，见谅自己是测试吧

链接: https://pan.baidu.com/s/1I700VXCVCzCMgdpNPBworw  密码: t9ul 分享镜像