# 【Go】今天简单的看一个Go切片的题目，看下你有没有做错


<!--more-->

## 1 简述
`Go Slice`也是开发过程中频繁使用的关键字，你有真正理解`Slice`的原理吗？具体原理的话，这边目前先不做分析了，网上的资料很多，可能后续有时间的话这边也会总结一下。今天就来看一个简简单单的Go语言题目吧。

## 2 题目

```go
package main

import "fmt"

func testFunc1(data []int) {
	data[0] = 1000
}

func testFunc2(data []int) {
	data = append(data, 2000)
}

func main() {
	a := make([]int, 0, 10)
	a = append(a, 1)
	testFunc1(a)
	fmt.Println(a)

	testFunc2(a)
	fmt.Println(a)
}
```
**你认为输出的结果是什么呢?**
- 输出结果信息：

  ```bash
  $ go run main   
  [1000]
  [1000]
  ```

- 输出是否和你想象的一样？你是否有这样的疑问 2000 去哪里了？切片不是引用传递吗？

  不懂原理的可能会猜想：

  - 是否切换append扩容了，`data = append(data, 2000)`输入的data的地址和返回的data的地址不同。
  - 没有data返回不出来？

  具体原因分析：
  - 首先需要理解切片的底层结构，使用 `len cap unsafe`指针三个元素构成的。容量，长度和指向底层数组的指针,切片可以随时进行扩展
  - 理解切换什么时候进行数据扩容
  - 知道go语言只有值传递没有引用传递

  具体我也不说透了，我相信你可以理解的。

## 3 总结

​	通过代码，简单的说明了`Go`语言的几点特性。希望你以后不会遇到类似的问题。如果最后你还是没有理解可以给我留言。我希望遇到问题的话，自己可以先写代码学习验证。
