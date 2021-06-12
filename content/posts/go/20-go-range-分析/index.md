---
weight: 1
title: "【Go】for range 高频次使用，你懂它的原理吗？"
date: 2021-01-17T23:47:06+08:00
lastmod: 2021-01-17T23:47:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "for range的简单使用的介绍及其语法糖的原理分析."
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
`for range` 是`Go语言` 提供的一种迭代遍历的手段，通常我们使用可以操作的类型有数组、切片、Map、Channel等，实际使用`频率非常`的高。所以它的原理的话，我们必须要掌握清楚。

## 2 For Range
### 2.1 for range 使用
#### 2.1.1 数组
```go
package main

import "fmt"

func main() {
	array := [3]int{1, 2, 3}
	for i, v := range array {
		fmt.Printf("array[%d]=%d\n", i, v)
	}
}

// out
array[0]=1
array[1]=2
array[2]=3
```
#### 2.1.2 切片
```go
package main

import "fmt"

func main() {
	slice := []int{1, 2, 3}
	for i, v := range slice {
		fmt.Printf("slice[%d]=%d\n", i, v)
	}
}

// out
slice[0]=1
slice[1]=2
slice[2]=3
```
#### 2.1.3 Map
```go
package main

import "fmt"

func main() {
	dataMap := map[int]int{
		1: 1,
		2: 2,
	}

	for i, v := range dataMap {
		fmt.Printf("dataMap[%d]=%d\n", i, v)
	}
}

// out
dataMap[1]=1
dataMap[2]=2
```
#### 2.1.4 Channel
```go
// TODO
```
### 2.2 for range 奇妙的问题

- TODO
- 遍历append
- for..range的坑

### 2.3 for range 语法糖

原理代码:

```go
// Arrange to do a loop appropriate for the type.  We will produce
//   for INIT ; COND ; POST {
//           ITER_INIT
//           INDEX = INDEX_TEMP
//           VALUE = VALUE_TEMP // If there is a value
//           original statements
//   }
```

可见range实际上是一个C风格的循环结构。range支持数组、数组指针、切片、map和channel类型，对于不同类型有些细节上的差异。

#### 2.3.1 数组
```go
// len_temp := len(range)
// range_temp := range
// for index_temp = 0; index_temp < len_temp; index_temp++ {
//   value_temp = range_temp[index_temp]
//   index = index_temp
//   value = value_temp
//   original body
//}
```
#### 2.3.2 切片
```go
// The loop we generate:
//   for_temp := range
//   len_temp := len(for_temp)
//   for index_temp = 0; index_temp < len_temp; index_temp++ {
//           value_temp = for_temp[index_temp]
//           index = index_temp
//           value = value_temp
//           original body
//   }
```
#### 2.3.3 Map
```go
// The loop we generate:
//   var hiter map_iteration_struct
//   for mapiterinit(type, range, &hiter); hiter.key != nil; mapiternext(&hiter) {
//           index_temp = *hiter.key
//           value_temp = *hiter.val
//           index = index_temp
//           value = value_temp
//           original body
//   }
```
#### 2.3.4 Channel
```go
// The loop we generate:
//   for {
//           index_temp, ok_temp = <-range
//           if !ok_temp {
//                   break
//           }
//           index = index_temp
//           original body
//   }
```

### 2.4 一些for  range其他的问题

- for...range遍历过程中可以delete在map里面的数据吗？
  - 遍历的过程中，可以参数map的数据。
- for...range遍历map的时候，是否需要加锁处理？
  - 建议所有map的情况都进行加锁处理，除非版本只有并发读的情况，没有出现并发写，或者并发读写的情况。

## 总结

- map应该使我们必须掌握的遍历语法糖，避免出现使用for...range出问题的坑。很多坑自己出现可能只是对`for...range`的原理不够了解。明白其原理的情况，才能更加正确的使用它。

[map](https://blog.csdn.net/lengyue1084/article/details/108124495)