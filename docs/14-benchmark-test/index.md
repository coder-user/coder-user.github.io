# 【Go】性能分析之benchmark基准测试


<!--more-->

## 简介

`benchmark`基准测试是一种测试代码性能的方法，同时也可以用来判断某段代码的CPU或者内存效率问题。很多开发都是通过`benchmark`测试的结果来衡量一个函数或者功能的性能表现。一个优秀的程序员不仅需要写好自己的业务代码，其次测试代码的质量也是衡量的一个重要标准。一个完整的单元测试和性能测试，至少可以发现80%的bug。

以下以Go语言为案例，说说go的benchmark测试。

## 1 准备

- 压力测试的环境，必须同一个测试环境，修改前后才有对比可言。
- 压力测试的环境，最好和线上运行的系统相同，建议使用`linux`，有条件的可以与线上系统的配置相同。
- 机器处于闲置状态，测试时不要执行其他任务，也不要和其他人共享硬件资源。

## 2 benchmark测试

### 2.1 测试环境的搭建

​	Go 语言标准库内置的 testing 测试框架提供了基准测试`benchmark`的能力，能让我们很容易地对某一段代码进行性能试。`benchmark`的测试方式和普通的测试方式相同，创建的测试文件都需要以`_test.go`结尾。一般测试的情况，都是一个源文件代码会对应一个测试文件。测试文件的量可以会远超业务代码的量。

使用命命令行操作：

```bash
$ mkdir benchmark

$ cd benchmark

$ vim main.go
```

- main.go
  - 测试什么程序的性能呢？这个问题我想了很久。排序算法？

```go
package main

import "fmt"

func main() {
	arr := []int{8, 4, 2, 9, 10, -3, 3, 20, 15, -1}
	bubbleSort(arr)
	fmt.Println(arr)
}

func bubbleSort(arr []int) {
	length := len(arr)
	for i := 0; i < length-1; i++ {
		flag := true

		for j := 0; j < length-1-i; j++ {
			if arr[j] > arr[j+1] {
				arr[j], arr[j+1] = arr[j+1], arr[j]
				flag = false
			}
		}

		if flag {
			break
		}
	}
}
```

- 新建测试程序，编写测试代码

**vim main_test.go**

```go
package main

import (
	"math/rand"
	"testing"
	"time"
)

var intArray []int

func TestMain(m *testing.M) {
	rand.Seed(time.Now().Unix())
	intArray = make([]int, 10000)

	for i := 0; i < 10000; i++ {
		intArray[i] = rand.Int()
	}

	m.Run()
}


func Benchmark_bubbleSort(b *testing.B) {
	slice := intArray[0:10000]
	for i := 0; i < b.N; i++ {
		bubbleSort(slice)
	}
}
```

- benchmark 和普通的单元测试用例是使用，测试文件都是需要`_test.go` 结尾命名。
- 函数名以 `Benchmark` 开头，参数是 `b *testing.B`。
- `func TestMain(m *testing.M)`是测试前运行的数据，这边是实现随机一组int类型的数据。

这样我们的测试环境就搭建好了，可以开始执行我们的测试了。

### 2.2 Go test 执行测试用例

```bash
$ go test -bench .
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-8   	   99993	     11892 ns/op
PASS
ok  	benchmark	4.550s
```

在测试目录执行`go test`，使用 `go test -bench .`执行当前目录下的所有`benchmark`测试单元。

**如果目录下有很多的测试单元，你只想执行其中一个怎么办？**

`-bench`参数支持使用正则表达式，正则表达式匹配到的`benchmark`测试才会执行。

`$ go test -bench='^bubbleSort$' .`

```bash
$ go test -bench='bubbleSort' .
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-8   	   99130	     12216 ns/op
PASS
ok  	benchmark	2.601s
```

**benchmark执行的过程中，过滤单元测试的输出**

- `-run`匹配一个从来没有单元测试的方法，过滤单元测试的输出，可以使用以下两种的测试方法：

  - `-run=none`
  - `-run=^$`

  eg:

  `go test -bench=. -run=none`

  `go test -bench=. -run=^$`

### 2.3 Go test的一些扩展参数

#### 2.3.1 准确度的提升

正确的使用扩展参数的情况，能提高单元测试精确度。

`-benchtime`和`-count`参数`-cpu`

**-benchtime**

**测试时间**

`go test -bench=. -benchtime=5s .`

```bash
$  go test -bench=. -benchtime=5s .
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-8   	  502545	     12027 ns/op
PASS
ok  	benchmark	11.097s
```

​	为什么时间是 `11.097s` 不是 `5s`，测试用例编译、执行、销毁等是需要时间的。

**测试次数**

`go test -bench=. -benchtime=5x .`

```bash
$ go test -bench=. -benchtime=5x .
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-8   	       5	     16795 ns/op
PASS
ok  	benchmark	0.388s
```

**-cpu**

设置cpu使用个数对程序的性能的影响。

`go test -bench=. -cpu=2,4,8 .`

```bash
$ go test -bench=. -cpu=2,4,8 .
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-2   	   97129	     12054 ns/op
Benchmark_bubbleSort-4   	   98277	     11940 ns/op
Benchmark_bubbleSort-8   	   99444	     11927 ns/op
PASS
ok  	benchmark	5.012s
```

​	为什么2，4，8核心的性能几乎是一样的？因为没有使用到多线程的机制，写的demo是串行的。

#### 2.3.2 实现内存的统计

**-benchmem**

`go test -bench=. -benchmem`

```bash
goos: darwin
goarch: amd64
pkg: benchmark
Benchmark_bubbleSort-8   	  100401	     11959 ns/op	       0 B/op	       0 allocs/op
PASS
ok  	benchmark	2.624s
```

## 3 benchmark扩展和原理分析

### 3.1 精确耗时处理

- ResetTimer
  - 受到耗时准备任务的干扰情况，使用`ResetTimer`重置时间。
- StopTimer 和 StartTimer
  - 每次函数调用前后需要一些准备工作和清理工作，可以使用 `StopTimer` 暂停计时以及使用 `StartTimer` 开始计时。

### 3.2 原理简单说明

```go
func Benchmark_bubbleSort(b *testing.B) {
	slice := intArray[0:10000]
	for i := 0; i < b.N; i++ {
		bubbleSort(slice)
	}
}
```

​	通过demo可以看到，`benchmark`测试的时候，使用的参数为`b *testing.B`，有一个很重要用到的数据类型为`b.N`，通过`for`循环可以看出，是用例需要执行的次数。`b.N`对于每个用例测试可能都是不一样的。

**那这个b.N的数值的N是如何决定的呢？**

​	b.N从1开始，如果测试的用例可以在 1s 内完成，`b.N`的值增加，再次的去执行。b.N的值大概是以指数的方式序列递增，越到后面，增加的越快。

**demo:**

```go
func BenchmarkSleep1s(b *testing.B) {
	for i := 0; i < b.N; i++ {
		time.Sleep(time.Second * 1)
	}
}
```

**测试命令**

```
$ go test -bench="Sleep"    
goos: darwin
goarch: amd64
pkg: benchmark
BenchmarkSleep1s-8             1        1002035924 ns/op
PASS
ok      benchmark       1.438s
```

- 为什么只执行一次的话，应该就是上面的方式方法。

## 总结

介绍了benchmark的使用，以及相关扩展参数的使用方法。快去实践一下吧？
后续的话，介绍使用pprof进行性能的分析。

[comment]: <https://geektutu.com/post/hpg-benchmark.html> "benchmark测试用例"
[comment]: <https://blog.csdn.net/weixin_34232617/article/details/91854391> "benchmark测试用例"
[comment]: <https://blog.csdn.net/woniu317/article/details/82560312> "benchmark测试用例"
