---
weight: 1
title: "【Go】Golang 语言中数组和切片的区别是什么？"
date: 2021-04-06T23:10:06+08:00
lastmod: 2021-04-06T23:10:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "简单说明了Go语言中，数组和切片的区别，以及一些简单的切片使用技巧和注意点."
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

# Golang 语言中数组和切片的区别是什么？
## 1 介绍
- Golang语言中，使用数组的情况并不多。切片使用更加广泛。
- 切片的底层存储也是基于数组。

## 2 数组和切换的区别
- 数组的零值是元素类型的零值，切片的零值是 nil。
- 数组是固定长度，切片是可变长度。
- 数组是值类型，切片是引用类型。
- 数组中元素超越边界会引发错误，切片中元素超越边界会自动扩容。
- 数组是值类型，切片是引用类型。
- 在 Golang 语言中传递数组属于值拷贝，如果数组的元素个数比较多或者元素类型的大小比较大时，直接将数组作为函数参数会造成性能损耗，可能会有读者想到使用数组指针作为函数参数，这样是可以避免性能损耗，但是在 Golang 语言中，更流行使用切片，关于这块内容，阅读完 Part 04 的切片数据结构，会有更加深入的理解。

## 3 切片的扩容规则
- 切片扩容实际是创建一个新的底层数组，把原切片的元素和新元素一起拷贝到新切片的底层数组中，原切片的底层数组将会被垃圾回收。
- 注意：切片的容量可以根据元素的个数的增多自动扩容，但是不会根据元素的个数的减少自动缩容。
- 在原切片长度小于 1024 时，新切片的容量会按照原切片的 2 倍扩容，否则，新切片的容量会按照原切片的 1.25 倍扩容。

## 4 切片数据结构
在 Golang 语言中，切片实际是一个结构体，源码如下所示：

```go
// /usr/local/go/src/runtime/slice.go
type slice struct {
  array unsafe.Pointer
  len   int
  cap   int
}
```
阅读源码，我们可以发现先，`slice` 结构体包含 3 个字段：
| 字段  | 说明         |
|-------|--------------|
| array | 指向底层数组 |
| len   | 切片的长度   |
| cap   | 切片的容量   |

在 Golang 语言运行时中，一个切片类型的变量实际上就是 runtime.slice 结构体的实例，其中 arrray 字段是指针类型，指向切片的底层数组，len 是切片的长度，cap 是切片的容量，当使用 make 函数创建切片时，如果不指定 cap 参数的值，cap 的值就等于 len 的值。

## 5 切片编程技巧
明白底层的原理的情况，为了降低或避免内存分配和拷贝的代价，我们通常会为新创建的切片指定 cap 参数的值，比如：
```go
s := make([]T, 0, cap)
```

但是，这种使用方式的前提是，我们可以预估切片的元素个数。

## 6 for range 遍历切片
通过使用 for range 遍历切片，每次遍历操作实际上是对遍历元素的**拷贝**。而使用 for 遍历切片，每次遍历是通过索引访问切片元素，性能会远高于通过 for range 遍历。
因此想要优化使用 for range 遍历切片的性能，可以使用**空白标识符 _ 省略每次遍历返回的切片元素**，改为使用切片索引取访问切片的元素。

普通方式:
```go
func main () {
    s := make([]int, 0, 10000)
    for k, v := range s {
        fmt.Println(s, v)
    }
}
```

优化方式:
```go
func main () {
    s := make([]int, 0, 10000)
    for k, _ := range s {
        fmt.Println(k, s[k])
    }
}
```

## 7 总结
简单的说明了切换和数组的区别，介绍了关闭切换扩容的规则，数组结构和使用技巧等。


<!--参考链接:https://mp.weixin.qq.com/s/PsTi92qwmz2KhWRt56d43Q-->

<!-- {{< admonition >}} -->
<!-- {{< /admonition >}} -->
<!-- {{< admonition note "Hugo 的运行环境" >}} -->
<!-- {{< /admonition >}} -->
<!-- {{< admonition tip "关于 CDN 配置的技巧" >}} -->
<!-- {{< version 0.2.7 changed >}} -->
<!-- {{< /admonition >}} -->