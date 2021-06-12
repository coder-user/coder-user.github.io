---
weight: 1
title: "【Go】用ErrorGroup替代你的WaitGroup"
date: 2020-12-26T17:40:06+08:00
lastmod: 2020-12-26T17:40:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "ErrorGroup的简介和学习探索."
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

> 引用文章[觉得WaitGroup不好用？试试ErrorGroup吧！](https://juejin.cn/post/6909348887450877960)

## 简介

`sync.WaitGroup`在并发编程里面使用频率非常高，通常用于协同等待的场景，学习基础的Go并发编程的同学应该没有不懂它的使用方法。

## WaitGroup简单介绍

- 看看下面这个代码：

  ```go
  func main() {
  	cost := time.Now()
  	for i := 0; i < 5; i++ {
  		go func(i int) {
  			fmt.Println(i)
  		}(i)
  	}
  
    // time.Sleep 具体什么作用呢？
  	time.Sleep(time.Second * 1)
  	fmt.Printf("cost:%v ms", time.Since(cost).Milliseconds())
  }
  
  0
  4
  1
  2
  3
  cost:1004 ms
  ```

  我相信大家应该很清楚，`time.Sleep()`在这边的作用。同样的`sync.WaitGroup`也是起到等待完成的作用。

  一个`goroutine`在检查点(Check Point)等待一组执行任务的 worker `goroutine` 全部完成，如果在执行任务的这些worker `goroutine` 还没全部完成，等待的 `goroutine` 就会阻塞在检查点，直到所有woker `goroutine` 都完成后才能继续执行。

- 改改代码使用`sync.WaitGroup`的方式

  ```go
  func main() {
  	cost := time.Now()
  	wg := sync.WaitGroup{}
  	for i := 0; i < 5; i++ {
  		wg.Add(1)
  		go func(i int) {
  			defer wg.Done()
  			fmt.Println(i)
  		}(i)
  	}
  
  	wg.Wait()
  	fmt.Printf("cost:%v ms", time.Since(cost).Milliseconds())
  }
  
  // 输出
  4
  1
  0
  2
  3
  cost:0 ms
  ```

为什么两个程序时间差距这么大，你应该明白了，原因在于怎么实现等的操作。怎么保证可靠性的等待。

## WaitGroup存在的问题

​	如果在woker `goroutine`的执行过程中遇到错误想要通知在检查点等待的协程处理该怎么办呢？`WaitGroup`并没有提供传播错误的功能。

## ErrorGroup介绍

​	`Go`语言在扩展库提供的`ErrorGroup`并发原语正好适合在这种场景下使用，它在`WaitGroup`的功能基础上还提供了，**错误传播以及上下文取消的功能**。

`Go`扩展库通过`errorgroup.Group`提供`ErrorGroup`原语的功能，它有三个方法可调用：

```go
func WithContext(ctx context.Context) (*Group, context.Context)
func (g *Group) Go(f func() error)
func (g *Group) Wait() error
```

- 调用`errorgroup`包的`WithContext`方法会返回一个`Group` 实例，同时还会返回一个使用 `context.WithCancel` 生成的新`Context`。一旦有一个子任务返回错误，或者是`Wait` 调用返回，这个新 `Context` 就会被 `cancel`。
- `Go`方法，接收类型为`func() error` 的函数作为子任务函数，如果任务执行成功，就返回`nil`，否则就返回 `error`，并且会`cancel` 那个新的`Context`。
- `Wait`方法，类似`WaitGroup`的 `Wait` 方法，调用后会阻塞地等待所有的子任务都完成，它才会返回。如果有多个子任务返回错误，它**只会返回第一个出现的错误**，如果所有的子任务都执行成功，就返回`nil`。

## 使用ErrorGroup

`go get -u`

接下来我们让主`goroutine`使用`ErrorGroup`代替`WaitGroup`等待所有子任务的完成，`ErrorGroup`有一个特点是会返回所有执行任务的`goroutine`遇到的第一个错误。我们试着执行一下下面的程序，注意观察程序的输出。

```go
package main

import (
	"fmt"
	"log"
	"time"

	"golang.org/x/sync/errgroup"
)

func main() {
	var eg errgroup.Group
	for i := 0; i < 100; i++ {
		i := i
		eg.Go(func() error {
			time.Sleep(2 * time.Second)
			if i > 90 {
				fmt.Println("Error:", i)
				return fmt.Errorf("Error occurred: %d", i)
			}
			fmt.Println("End:", i)
			return nil
		})
	}
	if err := eg.Wait(); err != nil {
		log.Fatal(err)
	}
}
```

上面程序，遇到i大于90的都会产生错误结束执行，但是只有第一个执行时产生的错误被`ErrorGroup`返回，程序的输出大概如下：

```go
......
End: 49
End: 26
Error: 98
End: 63
End: 39
End: 50
End: 38
Error: 95
End: 67
End: 65
End: 57
End: 64
2020/12/17 18:11:40 Error occurred: 98
复制代码
```

最早执行遇到错误的`goroutine`输出了`Error: 98`但是所有未执行完的其他任务并没有停止执行。那么想让程序遇到错误就终止其他子任务该怎么办呢？我们可以用`errgroup.Group`提供的`WithContext`方法创建一个带可取消上下文功能的`ErrorGroup`。

```go
package main

import (
	"context"
	"fmt"
	"log"
	"time"

	"golang.org/x/sync/errgroup"
)

func main() {
	eg, ctx := errgroup.WithContext(context.Background())

	for i := 0; i < 100; i++ {
		i := i
		eg.Go(func() error {
			time.Sleep(2 * time.Second) 

			select {
			case <-ctx.Done():
				fmt.Println("Canceled:", i)
				return nil
			default:
				if i > 90 {
					fmt.Println("Error:", i)
					return fmt.Errorf("Error: %d", i)
				}
				fmt.Println("End:", i)
				return nil
			}
		})
	}
	if err := eg.Wait(); err != nil {
		log.Fatal(err)
	}
}
```

`Go`方法单独开启的`goroutine`在执行参数传递进来的函数时，如果函数返回了错误，会对`ErrorGroup`持有的`err`字段进行赋值并及时调用`cancel`函数，通过上下文通知其他子任务取消执行任务。所以上面更新后的程序会有如下类似的输出。

```go
......
Error: 99
Canceled: 68
Canceled: 85
End: 57
End: 51
Canceled: 66
Canceled: 93
Canceled: 72
Canceled: 78
End: 55
Canceled: 74
2020/12/17 18:23:12 Error: 99
```

了解`ErrorGroup`的使用方法后，我们再来看看这个并发同步原语的实现原理。

## ErrorGroup的实现原理

`ErrorGroup`原语的结构体类型`errorgroup.Group`定义如下：

```go
type Group struct {
	cancel func()

	wg sync.WaitGroup

	errOnce sync.Once
	err     error
}
```

- `cancel` — 创建 [`context.Context`](https://draveness.me/golang/tree/context.Context) 时返回的取消函数，用于在多个 `goroutine` 之间同步取消信号；
- `wg` — 用于等待一组 `goroutine` 完成子任务的同步原语；
- `errOnce` — 用于保证只接收一个子任务返回的错误的同步原语；

通过 `errgroup.WithContext`构造器创建`errgroup.Group` 结构体：

```go
func WithContext(ctx context.Context) (*Group, context.Context) {
	ctx, cancel := context.WithCancel(ctx)
	return &Group{cancel: cancel}, ctx
}
```

运行新的并行子任务需要使用`errgroup.Group.Go`方法，这个方法的执行过程如下：

1. 调用 `sync.WaitGroup.Add` 增加待处理的任务数；
2. 创建一个新的 `goroutine` 并在 `goroutine` 内部运行子任务；
3. 返回错误时及时调用 `cancel` 并对 `err` 赋值，只有最早返回的错误才会被上游感知到，后续的错误都会被舍弃：

```go
func (g *Group) Go(f func() error) {
	g.wg.Add(1)

	go func() {
		defer g.wg.Done()

		if err := f(); err != nil {
			g.errOnce.Do(func() {
				g.err = err
				if g.cancel != nil {
					g.cancel()
				}
			})
		}
	}()
}
```

用于等待的`errgroup.Group.Wait`方法只是调用了 `sync.WaitGroup.Wait`方法，阻塞地等待所有子任务完成。在子任务全部完成时会通过调用在`errorgroup.WithContext`创建`Group`和`Context`对象时存放在`Group.cancel`字段里的函数，取消`Context`对象并返回可能出现的错误。

```go
func (g *Group) Wait() error {
	g.wg.Wait()
	if g.cancel != nil {
		g.cancel()
	}
	return g.err
}
```

## 总结

`Go`语言通过`errorgroup.Group`结构提供的`ErrorGroup`原语通过封装`WaitGroup`、`Once`基本原语结合上下文对象，提供了除同步等待外更加复杂的错误传播和执行任务取消的功能。在使用时，我们也需要注意它的两个特点：

- `errgroup.Group`在出现错误或者等待结束后都会调用 `Context`对象 的 `cancel` 方法同步取消信号。
- 只有第一个出现的错误才会被返回，剩余的错误都会被直接抛弃。