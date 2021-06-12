---
weight: 1
title: "【powershell】Windows powershell环境美化，工具达人必看篇"
date: 2020-12-24T22:20:32+08:00
lastmod: 2020-12-24T22:20:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "powershell美化的介绍."
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

## 简述

公司开发使用的`windows`，平常主要使用的安装`zsh`的`wsl`，真香。那么偶尔也需要使用到`cmd`或者`powershell`，cmd基本处于放弃的情况，极其的不好用。那么powershell呢？和zsh比还有很大的差距。今天就介绍一下怎么优化你的powershell。

## 怎么优化powershell？

### powershell替代软件

- `Windows Terminal`需要在`MS store`里面下载

### Windows Terminal优化

**主题配置**

使用`oh-my-post`主题插件

### oh-my-post主题

​	Mac/Linux下有oh-my-zsh主题，终于，Windows Terminal的PowerShell也有oh-my-posh主题了。`oh-my-posh` 是一个强大的`powerline`主题，类似于 `Linux`下的 `oh-my-zsh` 。

- github地址：[github-主题官网](https://github.com/JanDeDobbeleer/oh-my-posh)
- oh-my-post官网：[官网](https://ohmyposh.dev)

## 开始

### 主题安装方法

**查看策略组的执行权限**

首先，我们需要查看当前的权限，以便后续正常安装，以**管理员权限**打开的`powershell`中这么执行指令：

```bash
Get-ExecutionPolicy -List
```

此时，我们需要输入以下命令，将**CurrentUser**的**ExecutionPolicy(执行权限)**从原来的**Undefined**更改成**RemoteSigned**，需要输入命令：

```bash
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

按提示输入`Y`即可，后面所有的提示都是输入`Y`。

**接下来，你需要使用PowerShell Gallery 来安装 oh-my-posh.**

```bash
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
```

都安装好之后，还需要更新配置文件`$PROFILE`，类似于Linux Bash的.bashrc, 这是全局修改，而不是临时的设置喔~

输入:

```bash
$PROFILE
```

继续输入：

```bash
if (!(Test-Path -Path $PROFILE )) { New-Item -Type File -Path $PROFILE -Force }
notepad $PROFILE
```

在打开的文件中添加：

```ini
Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Honukai
```

保存后关闭记事本。

其中`Set-Theme Honukai`是设置主题的，其他可选主题有 `Agnoster`、`Avit`、`Darkblood`、`Fish`、`Honukai`、`Paradox`、`Sorin`、`tehrob`，可自行选择。

最后更新配置:

```bash
C:\Users\test\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

Copy

> **上面的Kuan是你的电脑的用户名，不要照抄**。也即前面运行`$PROFILE`命令后的结果。
>
> 重启powershell后会发现已经生效。



- 提示一个小坑，window安装主题的话，会发现进入带`git`的目录比较慢的情况，自己研究一下怎么提高速度，练练自己解决问题的能力。

## 总结

​	有没有感觉美观了很多，你的`powershell`变的与众不同。vscode的终端，idea的终端，goland的终端也同样被优化了。赞。详细文档看github官方介绍，可以研究研究怎么自定义主题。

~

最后，文件大小原因，不太喜欢插图，请见谅。

[comment]: <https://www.misiyu.cn/article/134.html> "powershell配置的详细文档"