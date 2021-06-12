---
weight: 1
title: "【tools】 如何玩转GitHub？"
date: 2020-12-06T21:50:32+08:00
lastmod: 2020-12-06T21:50:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "github相关的命令."
resources:
- name: "featured-image"
  src: "featured-image.jpg"

tags: ["tools"]
categories: ["tools"]

lightgallery: true

toc:
  auto: false
---

github常用的搜索方式.

<!--more-->

## 1. 最常用的Git命令

**克隆代码**

- `git clone`
  - http地址
  - git地址

**拉取代吗**

- `git pull`

**切换分支**

- `git checkout <branch_name>`

**查看工作区状态**

- `git status`

**查看过往提交记录**

- `git log`

**提交到暂存区**

- `git add`

**提交到本地仓库**

- `git commit -m "提交注释"`

**提交到远程仓库**

- `git pull`

## 2. GitHub介绍和搜索项目

1. 按项目名称（name）查找

   - `in:name dev-tester`

2. 按项目描述（description）查找

   - `in:description` 微服务

   - `in:about` 微服务

3. 按README描述查找

   - `in:readme` 微服务相关

4. 设置星星数（stars）查询范围

   - `stars:>1000`

5. 设置fork数（forks）查询范围

   - `forks:>500`

6. 按项目语言筛选

   - `language:java`

7. 按项目作者查找

   - `user:CoolLiuzw`

8. 按项目大小查找

   - `size:>=500`

9. 更新时间
   - `pushed:>2020-01-01`
10. 组合查找

- `in:name dev-tester in:description 微服务 stars:>1000`

### 常用查找示例:

- `in:about gin language:go`

## 3. Github下载加速

- 绑定`hosts`
  - linux/window尝试通过绑定hosts的方式获取一定的加速，不过本地测试加速的效果不明显，还是建议大家借助Gitee的方式，实现快速的下载代码。
- 借助Gitee下载代码
  - `Gitee`对于github上比较出名的项目也有一定的维护，基本上能做到每天同步更新一次的频率，可以查找一下对应的项目。
- 使用油猴插件`gitfast`

## 4. GitHub项目创建及上传

- 待补充

## 总结

- 其实，如何玩转github的相关知识很多开发的小伙伴还是没有认真的学习过，建议通过本文的学习，你能通过github上找到自己想要的开源项目。






