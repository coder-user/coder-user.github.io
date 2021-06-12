# 【Go】一道简单的goroutine问题，参数传递你有没有搞懂


<!--more-->

## 1 简述
`Goroutine` 是并发编程必须掌握的东西，之前在go语言中文网看到的一道题目，尽然有`%65`的`Gopher` 没有回答正确，今天就来说说这个题目。
## 2 题目

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan int)
	go fmt.Println(<-ch1)
	ch1 <- 5
	time.Sleep(1 * time.Second)
}
```
**你认为输出的结果是什么呢?**
- 5
- 编译不通过
- 运行时死锁
```bash
fatal error: all goroutines are asleep - deadlock!

goroutine 1 [chan receive]:
main.main()
        /Users/liuzhiwei/code/go/mgo/test/main.go:10 +0x65
```
## 3 看看这题
```go
package main

import (
	"fmt"
	"time"
)

func main() {
	ch1 := make(chan int)
	go func() {
		fmt.Println(<-ch1)
	}()
	ch1 <- 5
	time.Sleep(1 * time.Second)
}
```
- 答案你认为是什么呢？

## 4 总结
在 Go 语言规范中，关于 **go 语句**[1]有这么一句描述：

> ```
> GoStmt = "go" Expression .
> ```
>
> The expression must be a function or method call; it cannot be parenthesized. Calls of built-in functions are restricted as for **expression statements**[2].
>
> The function value and parameters are **evaluated as usual**[3] in the calling goroutine, but unlike with a regular call, program execution does not wait for the invoked function to complete.

这里说明，go 语句后面的函数调用，其参数会先求值，这和普通的函数调用求值一样。在规范中**调用部分**[4]是这样描述的：

> Given an expression `f` of function type `F`,
>
> ```
> f(a1, a2, … an)
> ```
>
> calls `f` with arguments `a1, a2, … an`. Except for one special case, arguments must be single-valued expressions **assignable**[5] to the parameter types of `F` and are evaluated before the function is called.

大意思是说，函数调用之前，实参就被求值好了。

因此这道题目 `go fmt.Println(<-ch1)` 语句中的 `<-ch1` 是在 main goroutine 中求值的。这相当于一个无缓冲的 chan，发送和接收操作都在一个 goroutine 中（main goroutine）进行，因此造成死锁。

更进一步，大家可以通过汇编看看上面两种方式的不同。

此外，defer 语句也要注意。比如下面的做法是不对的：

```
defer recover()
```

而应该使用这样的方式：

```
defer func() {
  recover()
}()
```
简单的问题，原理一定需要掌握。
