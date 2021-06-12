# 【Go】go-callvis 查看代码调用关系图


<!--more-->

## 1 简述

阅读Go项目的情况，理清pkg之前的调用和函数之前的调用需要花费一定的时间，那么怎么提高我们阅读 开源 或 新代码的效率呢？

今天学习的就是使用 [go-callvis](https://github.com/ofabry/go-callvis)生成代码函数调用图。

`go-callvis`是一个开发工具，用于使用交互式视图帮助可视化Go程序的调用图。

该工具的**目的**是使用调用图中的数据及其与包和类型的关系为开发人员提供Go程序的**可视化概述**。 

这在大型项目中特别有用，在大型项目中代码的复杂性要高得多，或者您只是试图理解其他人的代码。 

**特征**

- 支持Go module的模式
- Focus重点关注程序中的特定程序包
- 单击程序包以使用交互式查看器快速切换焦点
- 按包将功能分组和/或将方法按类型分组
- 将程序包筛选为特定的导入路径前缀
- 忽略标准库中的函数
- 省略各种类型的函数调用

## 2 开始

### 2.1 Go callvis说明

**图片说明：**

**Packages / Types**

| Represents | Style            |
| ---------: | :--------------- |
|  `focused` | **blue** color   |
|   `stdlib` | **green** color  |
|    `other` | **yellow** color |

**Functions / Methods**

|   Represents | Style             |
| -----------: | :---------------- |
|   `exported` | **bold** border   |
| `unexported` | **normal** border |
|  `anonymous` | **dotted** border |

**Calls**

|   Represents | Style                  |
| -----------: | :--------------------- |
|   `internal` | **black** color        |
|   `external` | **brown** color        |
|     `static` | **solid** line         |
|    `dynamic` | **dashed** line        |
|    `regular` | **simple** arrow       |
| `concurrent` | arrow with **circle**  |
|   `deferred` | arrow with **diamond** |

### 2.2 安装

```sh
go get -u github.com/ofabry/go-callvis
# or
git clone https://github.com/ofabry/go-callvis.git
cd go-callvis && make install

// Graphviz 工具安装，这个是可选的，生成的时候添加 -graphviz 参数的时候需要使用到.
brew install graphviz
```

### 2.3 工具参数说明

**命令格式**

```bash
go-callvis <target package>
```

**参数说明**

```bash
Options
Usage of go-callvis:
  -debug
    	Enable verbose log.
    	启用详细日志.
  -file string
    	output filename - omit to use server mode
    	输出文件名-省略使用服务器模式.
  -cacheDir string
    	Enable caching to avoid unnecessary re-rendering.
    	启用缓存以避免不必要的重新渲染.
  -focus string
    	Focus specific package using name or import path. (default "main")
    	使用名称或导入路径关注特定的程序包。 （默认为“main”）.
  -format string
    	output file format [svg | png | jpg | ...] (default "svg")
    	输出文件格式[svg | png | jpg | ...]（默认为“ svg”）.
  -graphviz
    	Use Graphviz's dot program to render images.
    	使用Graphviz的点程序来渲染图像.
  -group string
    	Grouping functions by packages and/or types [pkg, type] (separated by comma) (default "pkg")
    	按软件包和/或类型[pkg，type]（用逗号分隔）（默认为“ pkg”）
  -http string
    	HTTP service address. (default ":7878")
    	HTTP服务地址。 （默认为“：7878”）.
  -ignore string
    	Ignore package paths containing given prefixes (separated by comma)
    	忽略包含给定前缀（用逗号分隔）的包路径.
  -include string
    	Include package paths with given prefixes (separated by comma)
    	包含具有给定前缀的软件包路径（以逗号分隔）.
  -limit string
    	Limit package paths to given prefixes (separated by comma)
    	将包路径限制为给定的前缀（以逗号分隔）.
  -minlen uint
    	Minimum edge length (for wider output). (default 2)
    	最小边长（用于更宽的输出）。 （默认2）.
  -nodesep float
    	Minimum space between two adjacent nodes in the same rank (for taller output). (default 0.35)
    	同一等级中两个相邻节点之间的最小间距（用于更高的输出）.
  -nointer
    	Omit calls to unexported functions.
    	忽略对未导出函数的调用.
  -nostd
    	Omit calls to/from packages in standard library.
    	忽略对标准库中程序包的调用.
  -skipbrowser
    	Skip opening browser.
    	跳过打开浏览器.
  -tags build tags
    	a list of build tags to consider satisfied during the build. For more information about build tags, see the description of build constraints in the documentation for the go/build package
    	在构建期间要考虑满意的构建标记列表. 有关构建标记的更多信息，请参阅go / build软件包的文档中的构建约束说明.
  -tests
    	Include test code.
    	包括测试代码.
  -version
    	Show version and exit.
    	显示版本并退出.
```

### 2.4 demo样例实操

- [demo样例实操](https://github.com/ofabry/go-callvis/tree/master/examples)

- eg:
  - `go-callvis -focus {pkg_name} -group pkg,type ./ | dot -Tpng -o /tmp/out.png`

## 3 相关问题解决方法

- no main packages？
  - go callvis 只能适用于程序代码，[isuue](https://github.com/ofabry/go-callvis/issues/19)
  - Main package is required for the analysis used, because all the calls in the callgraph tree begins in main (and inits).

- 使用pkg包的方式

  `go-callvis -group pkg,type -limit github.com/knq/xo github.com/knq/xo/examples/sqlite3 | dot -Tpng -o /tmp/out.png`





[comment]: <每日一博丨Go使用Gitee私有库作为项目依赖包(https://www.jianshu.com/p/b2bf49adb40a?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)>


