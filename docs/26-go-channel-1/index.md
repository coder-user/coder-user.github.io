# 【Go】channel的基本使用方法


<!--more-->

## 1 简述
  `channel` 是Go语言的核心数据结构和 `goroutine` 之间的通信方式，`channel` 是支撑Go语言高性能并发编程模型的重要数据结构。
  `channel` 也是最常用的数据结构之一，用好和弄懂Go的 `channel` 才可以写出更好的代码。
  这边也会通过几个篇幅描述一个 `channel` 的具体使用和相关的原理以及常用的方法。
## 2 channel的发展
  `CSP` 的应用
## 3 channel和sync
> Don’t communicate by sharing memory, share memory by communicating.
{{< admonition abstract >}}
  不要通过共享内存来通信，而要通过通信来共享内存。
{{< /admonition >}}
### 3.1 sync 的解决方案
### 3.2 channel 的解决方案
### 3.3 sync和channel的选择
尽管 Go 的设计者极力推荐使用 CSP 的方式来解决并发问题，但是 CSP 只是解决并发安全问题的其中一种途径，在某些场景，还是要具体问题具体分析。

课程中给出的建议如下：
{{< admonition note "课程建议" >}}
- 共享资源的并发访问使用传统并发原语；
- 复杂的任务编排和消息传递使用 Channel；
- 消息通知机制使用 Channel，除非只想 signal 一个 goroutine，才使用 Cond；
- 简单等待所有任务的完成用 WaitGroup，也有 Channel 的推崇者用 Channel，都可以；
- 需要和 Select 语句结合，使用 Channel；
- 需要和超时配合时，使用 Channel 和 Context。
{{< /admonition >}}

## 4 channel的基本用法
### 4.1 channel的基本类型
```go
chan    // 既可以发送数据，又可以接收数据的 channel
chan<-  // 只能接收数据的 channel
<-chan  // 只能发送数据的 channel
```
### 4.2 channel的初始化方式
```go
ch := make(chan struct{}, 10)
```
  未初始化的channel零值为 `nil` ,10是channel的容量，也可以不指定容量，即容量为零。如果不指定channel长度的情况，一般称为无缓冲的channel。

{{< admonition note "uber">}}
channel通常size应为1或是无缓冲的。默认情况下，channel是无缓冲的，其size为零。任何其他尺寸都必须经过严格的审查。考虑如何确定大小，是什么阻止了channel在负载下被填满并阻止写入，以及发生这种情况时发生了什么。
{{< /admonition >}}

### 4.3 channel的基本用法
**1. 发送数据**
```go
  ch := make(chan struct{})
  ch <- struct{}{}
```

**2. 接收数据**
```go
	ch := make(chan struct{})
	<-ch
```
- channel中接收数据的时候，还可以接收两个值:
```go
	val, ok := <-ch
	if !ok {
		fmt.Println("close")
	}
	_ = val
```
 ok 是一个bool值，表示是否成功的从 channel 中接收到了数据。如果 ok 是 false， ch 已经被 close, 且 ch 中没有缓存数据，那么 val 就是零值。

  所以如果 val 是零值，有可能是接收到了零值，也有可能是空的且被close的channel产生的零值。

**3. 其他操作**
- close
- cap
- len
- select
- forange

## 5 使用channel常见的错误
`panic`、`goroutine` 泄露
### 5.1 panic错误
- close 为 nil 的 channel
- send 已经 close 的 channel
- close 已经 close 的 channel
### 5.2 goroutine泄露
- channel的阻塞导致goroutine的泄露

## 6 总结
简单的介绍了 `channel` 的基本使用方法。
<!--参考链接:https://mp.weixin.qq.com/s/PsTi92qwmz2KhWRt56d43Q-->

<!-- {{< admonition note "Hugo 的运行环境" >}} -->
<!-- {{< /admonition >}} -->
<!-- {{< admonition tip "关于 CDN 配置的技巧" >}} -->
<!-- {{< version 0.2.7 changed >}} -->
<!-- {{< /admonition >}} -->

