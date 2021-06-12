# 【Go】channel的哪些操作会引发panic?


<!--more-->

## 1 简述
`Go channel`明白哪些情况channel会发生`panic`是去避免发生的最好的方式。如果不清楚`panic`的时间的话，就算你中午不出事，早晚也会出事的。还是那句话，基础的知识点继续掌握它。
## 2 Channel Panic
**1. 关闭一个 nil 值 channel 会引发 panic**
```go
package main

func main() {
	var ch chan struct{}
	close(ch)
}

panic: close of nil channel

goroutine 1 [running]:
main.main()
        /Users/liuzhiwei/code/go/mgo/Gee/test/main/main.go:5 +0x2a
```
**2. 关闭一个已经关闭的channel会引发panic**
```go
package main

func main() {
	ch := make(chan struct{})
	close(ch)
	close(ch)
}

panic: close of closed channel

goroutine 1 [running]:
main.main()
        /Users/liuzhiwei/code/go/mgo/Gee/test/main/main.go:6 +0x57
```
**3. 向一个已经关闭的channel发送数据**
```go
package main

func main() {
	ch := make(chan struct{})
	close(ch)
	ch <- struct{}{}
}

panic: send on closed channel

goroutine 1 [running]:
main.main()
        /Users/liuzhiwei/code/go/mgo/Gee/test/main/main.go:6 +0x65
```
## 3 总结
如果你对某块代码没有安全感，相信我，就算它中午不出事，早晚也得出事。
