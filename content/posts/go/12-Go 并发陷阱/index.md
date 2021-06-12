---
weight: 1
title: "【Go】Go并发陷阱和有效规避方法"
date: 2020-12-26T11:30:06+08:00
lastmod: 2020-12-26T11:30:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: ""
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

Go作为`21世纪的c语言`，并发开发的难道很低，使用`goroutine`协程的成本也很低。所以goroutine的并发开发在开发程序当中被大量的使用，但是goroutine的开发也有不少的坑和陷阱，这篇文章总结一些场景的坑和陷阱以及规避的方法。

## 闭包专递参数问题

循环并发时闭包传递参数的问题，先看一个实例

```go
func main() {
	wg := sync.WaitGroup{}
	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func() {
			wg.Done()
			fmt.Println(i)
		}()
	}
	wg.Wait()
}
```

运行测试输出（大概率，可能你的多测试的话，会有其他的情况，但是预计 0，1，2，3，4基本为0）：

```plain
5
5
5
5
5
```

**原因分析：**

- `i`的变量只被声明了一次，`i`使用的地址空间在循环中被复用，当子的goroutine函数执行打印时，`i`i的值可能已经被主的goroutine的`i++`修改了值，从而导致了并发错误。针对这种错误可以通过**复制拷贝**或者**传参拷贝**的方式规避。



## panic 异常

`panic` 异常的出现会导致 Go 程序的崩溃。

但其实即使 panic 是出现在其他启动的子 goroutine 中，也会导致 Go 程序的崩溃退出，同时 panic 只能捕获 goroutine 自身的异常，因此**对于每个启动的 goroutine，都需要在入口处捕获 panic，并尝试打印堆栈信息并进行异常处理，从而避免子 goroutine 的 panic 导致整个程序的崩溃退出**。如下面的例子所示：

```go
func Recover() {
	// 从 panic 中恢复并打印栈信息
	if e := recover(); e != nil {
		buf := make([]byte, 1024)
		buf = buf[:runtime.Stack(buf, false)]
		fmt.Printf("[PANIC]%v\n%s\n", e, buf)
	}
}

func main() {
	wg := sync.WaitGroup{}
	for i := 0; i < 5; i++ {
		wg.Add(1)
		go func() {
			wg.Done()
			defer Recover()
			panic("err")
		}()
	}
	wg.Wait()

	time.Sleep(time.Second * 1)
	fmt.Println("success.")
}
```

**`Goroutine`的`panic`捕获是独立的，父的goroutine的recover无法继承到子的goroutine，一定要注意这个点。**

## 超时控制

**善于结合使用 select、timer 和 context 进行超时控制**。在 goroutine 中进行一些耗时较长的操作，最好都加上超时timer，在并发的时候也要传递 context，这样在取消的时候就不会有遗漏，进而达到回收 goroutine 的目的，避免内存泄漏的发生。如下面的例子所示，通过 select 同时监听任务和定时器状态，在定时器到达而任务未完成之时，提前结束任务，清理资源并返回。

```go
select {
// do logic process
case msg <- input:
   ....
// has been canceled
case <-ctx.Done():
    // ...资源清理
    return
// 2 second timeout    
case <-time.After(time.Second * 2)  
    // ...资源清理
    return
default:
}
```

## 总结

- 说明了几种可能出现的错误，和原因的分析，但是没有给出明确的解决示例代码，根据原因分析说明，自己去实践解决问题吧
- 问题出现原因可能远不止这些，后续可能会总结继续完善本篇文章。