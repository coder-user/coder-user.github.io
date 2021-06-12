---
weight: 1
title: "【Go】Cobra Go最强大的命令行工具【2】"
date: 2020-12-12T16:38:06+08:00
lastmod: 2020-12-12T16:38:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "简单的介绍一个Go语言必须的库，强大的命令行工具."
resources:
- name: "featured-image"
  src: "featured-image.png"
tags: ["go"]
categories: ["go"]

lightgallery: true

toc:
  auto: false
---

简单的介绍一个Go语言必须的库，强大的命令行工具.

<!--more-->

## 简介

- 扩展使用cobra库的，简单的命令行参数配置。
- 预运行和后运行的回调函数的注册使用。

## 开始

### 运行函数的介绍

在运行命令的主函数之前或之后可以运行的函数。

主要有一下几个运行函数，按从上往下先后的顺序调用：

- `PersistentPreRun`

- `PreRun`

- `Run`

- `PostRun`

- `PersistentPostRun`

  之前主要使用的demo只使用到`Run`的函数，其实实际的cli运行当中，`PreRun`函数也是常被用到做一些资源的初始化。

### 怎么给命令行设置参数

- **本地标志**:本地分配标志，该标志将仅适用于该特定命令。

```go
localCmd.Flags().StringVarP(&Source, "source", "s", "", "Source directory to read from")
```

- **持久标志**:标志可以是"持久"的，这意味着此标志将可用于分配给它的命令以及该命令下的每个命令。对于全局标志，将标志作为根上的持久标志分配。

```bash
rootCmd.PersistentFlags().BoolVarP(&Verbose, "verbose", "v", false, "verbose output")
```

## 实际demo测试

以之前获取版本号为例：

- 测试运行参数

```go
// versionCmd represents the version command
var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "A brief description of version",
	Long:  `A longer description of version long`,
	PreRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("version PreRun")
	},
	Run: func(cmd *cobra.Command, args []string) {
		flags, _ := cmd.Flags().GetBool("flags")
		fmt.Println("flags =", flags)
		fmt.Println("version main called")
	},
	PostRun: func(cmd *cobra.Command, args []string) {
		fmt.Println("version PostRun")
	},
}
```

- 测试flags标志位：

```go
func init() {
	rootCmd.AddCommand(versionCmd)

	versionCmd.Flags().BoolP("flags", "t", false, "test flags")
}
```

- 测试结果

```bash
$ go run main.go version -t
version PreRun
flags = true
version main called
version PostRun

$ go run main.go version   
version PreRun
flags = false
version main called
version PostRun
```

## 总结

- 基本的使用扩展就到这边了，基本可以实现一个满足你的基础使用框架。
- 最后还有一个缺点是命令行工具不可以tab补全，官方也有实现方法使用，bash的方式。大家也可以去学习一下。后面有时间也会考虑一下出一个文档。