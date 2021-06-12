# 【Go】window和Mac交叉编译Linux实战和源码分享


一个用Go编译的go语言交叉编译工具.

<!--more-->

## 简述
​	程序编译是编译型语言，运行必备的过程。Go的重要的特性之一就是有着优秀的编译速度，和之前编写C相比，有着非常明显的提升。有人开玩笑说，Go语言是作者在编译C++过程中开发。

​	当然编译速度快的情况下，实现交叉编译也尤其的简单，只需要做环境变量上的修改。

## 需求

​	Gopher一般开发调试环境是Window 和 Mac 环境，但是项目测试往往需要跑到linux服务器上测试。这时候就需要编译Linux的可运行程序。最基础的方式就是代码下载到Linux上编译，获得需要的运行程序。过程中就有了需要Linux下载代码的一个过程。(支持CI可以忽略)

   最简单的方式，我认为是window上直接可编译Linux可运行文件，使用ssh工具的lrzsz工具，直接拖到Linux运行代码。下面简单的介绍一下我实现的工具。

## 原理

参考相关文档：

```sh
在powershell命令行中编译（示例编译64位linux程序）

$env:GOOS="linux"
$env:GOARCH="amd64"
go build xxx.go

在CMD命令行中编译（示例编译64位linux程序）
set GOARCH=amd64
set GOOS=linux
go build -a
```

- 这也是我们代码实现的原理基础。

## 实现

- 直接修改环境变量
  - 不可行，想编译window还得手动改回去。
- bat脚本，有兴趣可以自己学习一下。
  - 缺点，只能用于window，不能通用化。
  - 使用麻烦，需要需要修改环境变量和解除环境变量

### Go编译的cli运行工具

- 既然大家是学习Go的那么就用Go实现一个可以支持交叉编译的工具

直接上代码，基于之前说的原理:

```go
package main

import (
	"flag"
	"fmt"
	"os"
	"os/exec"
)

var buildPath = flag.String("p", "./", "input build path string")
var makeFileName = flag.String("o", "", "output file name config")

func main() {
	flag.Parse()
	_ = os.Setenv("CGO_ENABLED", "0")
	_ = os.Setenv("GOARCH", "amd64")
	_ = os.Setenv("GOOS", "linux")

	arg := []string{"build"}
	if len(*makeFileName) > 0 {
		arg = append(arg, []string{"-o", *makeFileName}...)
	}
	arg = append(arg, *buildPath)

	if err := exec.Command("go", arg...).Run(); err != nil {
		fmt.Println("!!!!!!!!!!!!!!!!!!!!!!!!!!make Failed!!!!!!!!!!!!!!!!!!!!!!!!!!", err)
	} else {
		fmt.Println("!!!!!!!!!!!!!!!!!!!!!!!!!!make SUCCESS!!!!!!!!!!!!!!!!!!!!!!!!!!")
	}
}
```

代码就是基于原理开发的。在所在的平台执行命令，以mac为例。

- 编译工具（一次编译永久使用）
  - `go build -o gomake`
- 试用工具交叉编译
  - `gomoke -o linux_go`

  ```sh
  # liuzhiwei @ liuzhiweideMacBook-Pro in ~/code/go/mgo/test [23:45:33] C:127
  $ ls
  go.mod  gomake  main.go
  
  # liuzhiwei @ liuzhiweideMacBook-Pro in ~/code/go/mgo/test [23:45:35] 
  $ ./gomake -o linux_go  
  !!!!!!!!!!!!!!!!!!!!!!!!!!make SUCCESS!!!!!!!!!!!!!!!!!!!!!!!!!!
  
  # liuzhiwei @ liuzhiweideMacBook-Pro in ~/code/go/mgo/test [23:46:06] 
  $ ls
  go.mod   gomake   linux_go main.go
  ```

- 使用以上过程实现的编译linux运行程序，这边是用Mac测试，window同原理。



**常用方式**：gomake编译工具移动到需要编译的目录运行 `./gomake`即可。

## 总结

​	主要介绍Go编写的Go语言交叉编译工具，实现Window和Mac编译Linux可运行程序。可以试用起来，这个有打打的提高了我的工作效率。


