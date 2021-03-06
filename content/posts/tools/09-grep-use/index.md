---
weight: 1
title: "【grep】基本使用总结"
date: 2021-05-30T21:16:32+08:00
lastmod: 2021-05-30T21:16:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "fzf配置及常用快捷键."
resources:
- name: "featured-image"
  src: "featured-image.png"

tags: ["开发工具"]
categories: ["开发工具"]

lightgallery: true

toc:
  auto: false
---

<!--more-->

## 1 简介
  `grep` 是开发检索日志字段常用的方式，具体的使用方式也没有进行总结，目前最常用的使用方式 `grep -rin {检索的内容}`，之前也没有明确的去学习 `-rin` 是什么意思。今天来一起学习一下 `grep` 的详细使用吧。

## 2 安装
  `grep` 是linux自带的软件，其他相关的检索工具还包括 `ag ack` 等，有兴趣的可以一起学习一下。
## 3 基本使用
 Linux grep 命令用于查找文件里符合条件的字符串。  
grep 指令用于查找内容包含指定的范本样式的文件，如果发现某文件的内容符合所指定的范本样式，预设 grep 指令会把含有范本样式的那一列显示出来。若不指定任何文件名称，或是所给予的文件名为 -，则 grep 指令会从标准输入设备读取数据。
- -a 或 --text : 不要忽略二进制的数据。
- -A<显示行数> 或 --after-context=<显示行数> : 除了显示符合范本样式的那一列之外，并显示该行之后的内容。
- -b 或 --byte-offset : 在显示符合样式的那一行之前，标示出该行第一个字符的编号。
- -B<显示行数> 或 --before-context=<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前的内容。
- -c 或 --count : 计算符合样式的列数。
- -C<显示行数> 或 --context=<显示行数>或-<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前后的内容。
- -d <动作> 或 --directories=<动作> : 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。
- -e<范本样式> 或 --regexp=<范本样式> : 指定字符串做为查找文件内容的样式。
- -E 或 --extended-regexp : 将样式为延伸的正则表达式来使用。
- -f<规则文件> 或 --file=<规则文件> : 指定规则文件，其内容含有一个或多个规则样式，让grep查找符合规则条件的文件内容，格式为每行一个规则样式。
- -F 或 --fixed-regexp : 将样式视为固定字符串的列表。
- -G 或 --basic-regexp : 将样式视为普通的表示法来使用。
- -h 或 --no-filename : 在显示符合样式的那一行之前，不标示该行所属的文件名称。
- -H 或 --with-filename : 在显示符合样式的那一行之前，表示该行所属的文件名称。
- -i 或 --ignore-case : 忽略字符大小写的差别。
- -l 或 --file-with-matches : 列出文件内容符合指定的样式的文件名称。
- -L 或 --files-without-match : 列出文件内容不符合指定的样式的文件名称。
- -n 或 --line-number : 在显示符合样式的那一行之前，标示出该行的列数编号。
- -o 或 --only-matching : 只显示匹配PATTERN 部分。
- -q 或 --quiet或--silent : 不显示任何信息。
- -r 或 --recursive : 此参数的效果和指定"-d recurse"参数相同。
- -s 或 --no-messages : 不显示错误信息。
- -v 或 --invert-match : 显示不包含匹配文本的所有行。
- -V 或 --version : 显示版本信息。
- -w 或 --word-regexp : 只显示全字符合的列。
- -x --line-regexp : 只显示全列符合的列。
- -y : 此参数的效果和指定"-i"参数相同。
## 4 常用方法
- `grep -rin "cond"`
- `zgrep "cond"`
## 5 总结
  简单的总结了一下grep的使用方法。

<!--参考文献:-->
