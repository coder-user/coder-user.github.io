---
weight: 1
title: "【Go】for ... range 的坑，你踩了吗？"
date: 2020-12-12T00:01:06+08:00
lastmod: 2020-12-12T00:01:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "介绍一个Go程序员不理解for...range容易出现的错误."
resources:
- name: "featured-image"
  src: "featured-image.jpg"
tags: ["go"]
categories: ["go"]

lightgallery: true

toc:
  auto: false
---

介绍一个Go程序员不理解for...range容易出现的错误.

<!--more-->

## 简述

- `for...range`是Go编程里面非常常用到的Slice和map的遍历方式，它的伪代码你懂吗？
- 常常有人被踩到循环赋值，指针引用的坑的问题。

## for...range遍历取值

```go
package main

import "fmt"

type Person struct {
	name string
}

func main() {
	personSlice := []Person{
		{"shazi"},
		{"coolliuzw"},
	}

	var res []*Person

	for _, person := range personSlice {
		res = append(res, &person)
	}

	for _, person := range res {
		fmt.Println("name-->>:", person.name)
	}
}
```

输出结果：

```go
name-->>: coolliuzw
name-->>: coolliuzw
```

- 是不是和你的预期不太一样，为什么是这样的呢？
  - `for range` 的时候，`person` 只**初始化了一次**，理解这句话应该就知道为什么了。
  - 之后的遍历都是在原来遍历的基础上赋值，所有person的指针（地址）并没有变。该指针指向的是最后一次遍历的person的值，所以最后结果集中，也就都成了最后遍历的v的值


最后提一个问题？刚刚出现的问题怎么解决呢？

- 方法一
```go
	for i := range personSlice {
		res = append(res, &personSlice[i])
```
- 方法二
```go
  // 哈哈，也可以考虑一下为什么这么定义person不会重复定义哦
	for _, person := range personSlice {
		person := person
		res = append(res, &person)
	}
```
## 总结

指针是Go、C、C++的重点支持，使用好指针对内存，GC、性能都有很大的提高。一定要理解清楚哦。