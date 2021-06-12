# 【Go】Go语言实现产生coredump文件




<!--more-->

## 简述

介绍Go语言生成coredump文件的方式和方法。

## 开始

​	之前的文章有谈过，centos7环境如何配置coredump文件的产生，也写了一个`c`语言的demo测试。今天来说说Go语言也可以生成coredump文件。来看看Go语言如何生成coredump吧。



### 测试demo

```go
package main

import "fmt"

func main() {
  a := 10
  for i := 1; i <= 10; i++ {
    fmt.Println(a/(10-i))
  }
}
```

- `go build -o main`
- `./main`测试

### 配置Go产生coredump文件

`GOTRACEBACK=none` :只输出panic异常信息

`GOTRACEBACK=single`:只输出被认为引发panic异常的那个goroutine的相关信息

`GOTRACEBACK=all`:输出所有goroutines的相关信息，除去与go runtime相关的stack frames.

`GOTRACEBACK=system`:输出所有goroutines的相关信息，包括与go runtime相关的stack frames,从而得知哪些goroutine是go runtime启动运行的

`GOTRACEBACK=crash`:与system的唯一区别是crash会生成coredump文件

这边使用最后一个配置的方式

- `GOTRACEBACK=crash`
- 临时配置`GOTRACEBACK=crash`
- 永久配置`echo GOTRACEBACK=crash ~/.zshrc`或者 `echo GOTRACEBACK=crash /etc/profile`

### 运行文件

- `./main` 生成coredump

  ```bash
  $ ./main
  1
  1
  1
  1
  2
  2
  3
  5
  10
  panic: runtime error: integer divide by zero
  
  goroutine 1 [running]:
  panic(0x4a88e0, 0x54cc60)
  	/usr/local/go/src/runtime/panic.go:1064 +0x545 fp=0xc000060f00 sp=0xc000060e38 pc=0x431e85
  runtime.panicdivide()
  	/usr/local/go/src/runtime/panic.go:191 +0x5b fp=0xc000060f20 sp=0xc000060f00 pc=0x43059b
  main.main()
  	/root/main/main.go:8 +0xda fp=0xc000060f88 sp=0xc000060f20 pc=0x49915a
  runtime.main()
  	/usr/local/go/src/runtime/proc.go:204 +0x209 fp=0xc000060fe0 sp=0xc000060f88 pc=0x434a89
  runtime.goexit()
  	/usr/local/go/src/runtime/asm_amd64.s:1374 +0x1 fp=0xc000060fe8 sp=0xc000060fe0 pc=0x463201
  
  goroutine 2 [force gc (idle)]:
  runtime.gopark(0x4c4dd8, 0x553e20, 0x1411, 0x1)
  	/usr/local/go/src/runtime/proc.go:306 +0xe5 fp=0xc00002cfb0 sp=0xc00002cf90 pc=0x434e85
  runtime.goparkunlock(...)
  	/usr/local/go/src/runtime/proc.go:312
  runtime.forcegchelper()
  	/usr/local/go/src/runtime/proc.go:255 +0xc5 fp=0xc00002cfe0 sp=0xc00002cfb0 pc=0x434d25
  runtime.goexit()
  	/usr/local/go/src/runtime/asm_amd64.s:1374 +0x1 fp=0xc00002cfe8 sp=0xc00002cfe0 pc=0x463201
  created by runtime.init.6
  	/usr/local/go/src/runtime/proc.go:243 +0x35
  
  goroutine 3 [GC sweep wait]:
  runtime.gopark(0x4c4dd8, 0x553f20, 0x140c, 0x1)
  	/usr/local/go/src/runtime/proc.go:306 +0xe5 fp=0xc00002d7a8 sp=0xc00002d788 pc=0x434e85
  runtime.goparkunlock(...)
  	/usr/local/go/src/runtime/proc.go:312
  runtime.bgsweep(0xc00004a000)
  	/usr/local/go/src/runtime/mgcsweep.go:163 +0x9e fp=0xc00002d7d8 sp=0xc00002d7a8 pc=0x42145e
  runtime.goexit()
  	/usr/local/go/src/runtime/asm_amd64.s:1374 +0x1 fp=0xc00002d7e0 sp=0xc00002d7d8 pc=0x463201
  created by runtime.gcenable
  	/usr/local/go/src/runtime/mgc.go:217 +0x5c
  
  goroutine 4 [GC scavenge wait]:
  runtime.gopark(0x4c4dd8, 0x553fc0, 0x140d, 0x1)
  	/usr/local/go/src/runtime/proc.go:306 +0xe5 fp=0xc00002df78 sp=0xc00002df58 pc=0x434e85
  runtime.goparkunlock(...)
  	/usr/local/go/src/runtime/proc.go:312
  runtime.bgscavenge(0xc00004a000)
  	/usr/local/go/src/runtime/mgcscavenge.go:265 +0xd2 fp=0xc00002dfd8 sp=0xc00002df78 pc=0x41f492
  runtime.goexit()
  	/usr/local/go/src/runtime/asm_amd64.s:1374 +0x1 fp=0xc00002dfe0 sp=0xc00002dfd8 pc=0x463201
  created by runtime.gcenable
  	/usr/local/go/src/runtime/mgc.go:218 +0x7e
  
  goroutine 5 [finalizer wait]:
  runtime.gopark(0x4c4dd8, 0x583368, 0x4a1410, 0x1)
  	/usr/local/go/src/runtime/proc.go:306 +0xe5 fp=0xc00002c758 sp=0xc00002c738 pc=0x434e85
  runtime.goparkunlock(...)
  	/usr/local/go/src/runtime/proc.go:312
  runtime.runfinq()
  	/usr/local/go/src/runtime/mfinal.go:175 +0xa9 fp=0xc00002c7e0 sp=0xc00002c758 pc=0x4163e9
  runtime.goexit()
  	/usr/local/go/src/runtime/asm_amd64.s:1374 +0x1 fp=0xc00002c7e8 sp=0xc00002c7e0 pc=0x463201
  created by runtime.createfing
  	/usr/local/go/src/runtime/mfinal.go:156 +0x65
  [1]    4665 abort (core dumped)  ./main
  ```

  `-rw------- 1 root root 101M Dec 23 15:05 core.main.4665`

## 总结

描述Go生成coredump的方法，和写demo实现，本来尝试使用gdb分析coredump文件，发现看不出堆栈的信息。后续文章分析使用dlv分析go的coredump。
