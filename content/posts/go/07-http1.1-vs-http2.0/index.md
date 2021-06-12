---
weight: 1
title: "【Go】HTTP1.1和HTTP2.0 性能对比简单测试"
date: 2020-12-13T15:28:06+08:00
lastmod: 2020-12-13T15:28:06+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "简单的通过测试的代码对HTTP1.0和HTTP2.0做对比，基本分析一下HTTP2.0的性能有多强。"
resources:
- name: "featured-image"
  src: "featured-image.png"
tags: ["go"]
categories: ["go"]

lightgallery: true

toc:
  auto: false
---

简单的通过测试的代码对HTTP1.0和HTTP2.0做对比，基本分析一下HTTP2.0的性能有多强。

<!--more-->

## 简述

简单的通过测试的代码对HTTP1.0和HTTP2.0做对比，基本分析一下HTTP2.0的性能有多强。

## 准备工作

### 制作证书

- 方法一

```bash
1生成服务端私钥
openssl genrsa -out default.key 2048
2生成服务端证书
openssl req -new -x509 -key default.key -out default.pem -days 3650
```

- 方法二

```bash
generate-tls-cert --host=localhost,127.0.0.1
```

### 校验证书

因为我们是X509格式签名的证书所以程序做好先做一下有效性校验

```go
if _, err = tls.LoadX509KeyPair("default.pem", "default.key"); err != nil {
  panic(err)
}
```

### HTTPServer

- HTTP的服务使用的gin框架。

### 测试环境
<div style='display: none'>
- 查询配置的方法
echo -n "CPU型号:    " 
sysctl -n machdep.cpu.brand_string
echo -n "CPU核心数:  " 
sysctl -n machdep.cpu.core_count
echo -n "CPU线程数:  "
sysctl -n machdep.cpu.thread_count
echo "其它信息："
system_profiler SPDisplaysDataType SPMemoryDataType SPStorageDataType | grep 'Graphics/Displays:\|Chipset Model:\|VRAM (Total):\|Resolution:\|Memory Slots:\|Size:\|Speed:\|Storage:\|Media Name:\|Medium Type:'
</div>

- 本篇的测试使用Mac系统测试，配置如下:

  ```bash
  -n CPU型号:Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz
  -n CPU核心数:4
  -n CPU线程数:8
  其它信息：
  Graphics/Displays:
        Chipset Model: Intel Iris Pro
            Resolution: 2880 x 1800 Retina
      Memory Slots:
            Size: 8 GB
            Speed: 1600 MHz
            Size: 8 GB
            Speed: 1600 MHz
  Storage:
            Media Name: AppleAPFSMedia
            Medium Type: SSD
            Media Name: AppleAPFSMedia
            Medium Type: SSD
  ```

  建议使用Linux系统测试，最好的方式应该是和项目的生产环境相同配置测试

## 编码测试

### HTTP1.1

```go
package _1_http

import (
	"log"
	"net/http"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
)

const HTTPListenAddr = ":6666"

func testRunHTTPSServer() {
	router := gin.New()
	go func() {
		if err := router.Run(HTTPListenAddr); err != nil {
			log.Fatalf("HTTP server: run failed. error: %v", err)
		}
	}()
}

var client http.Client

func init() {
	testRunHTTPSServer()
	client.Timeout = 10 * time.Second
}

func BenchmarkHTTP(b *testing.B) {
	for i := 0; i < b.N; i++ {
		req, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, nil)
		if err != nil {
			panic(err)
		}
		_, _ = client.Do(req)
	}
}
```

### HTTP2.0

```go
package _2_http2

import (
	"crypto/tls"
	"log"
	"net/http"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"golang.org/x/net/http2"
)

const HTTPSListenAddr = ":6666"

func testRunHTTPSServer() {
	router := gin.New()
	if _, err := tls.LoadX509KeyPair("test.pem", "test.key"); err != nil {
		log.Fatalf("HTTPS server: invalid cert")
	}

	go func() {
		if err := router.RunTLS(HTTPSListenAddr, "test.pem", "test.key"); err != nil {
			log.Fatalf("HTTPS server: run failed. error: %v", err)
		}
	}()
}

var client http.Client

func init() {
	testRunHTTPSServer()
	client.Timeout = 10 * time.Second
	client.Transport = &http2.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true}}
}

func BenchmarkHTTP2(b *testing.B) {
	for i := 0; i < b.N; i++ {
		req, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, nil)
		if err != nil {
			panic(err)
		}
		_, _ = client.Do(req)
	}

}
```

## 测试结果

在mac环境下，只做了简单的基础测试对比，使用Go的Benchmark测试的方法测试.

### 性能对比

#### GOMAXPROCS=1

##### HTTP1.1

```bash
$ GOMAXPROCS=1 go test -bench=. -benchmem -benchtime=10s 
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] Listening and serving HTTP on :6666
goos: darwin
goarch: amd64
pkg: gotest/01-http
BenchmarkHTTP   2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 320ms
2020/12/13 06:46:57 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 640ms
2020/12/13 06:46:58 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:46:59 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:00 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:01 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:02 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:03 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:04 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:47:05 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
   10000           1249917 ns/op           22633 B/op        125 allocs/op
PASS
ok      gotest/01-http  12.753s
```

##### HTTP2.0

```bash
$ GOMAXPROCS=1 go test -bench=. -benchmem -benchtime=10s
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] Listening and serving HTTPS on :6666
goos: darwin
goarch: amd64
pkg: gotest/02-http2
BenchmarkHTTP2    111625            105795 ns/op            7988 B/op         84 allocs/op
PASS
ok      gotest/02-http2 13.421s
```

#### GOMAXPROCS=4

##### HTTP1.1

```bash
$ GOMAXPROCS=4 go test -bench=. -benchmem -benchtime=10s 
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] Listening and serving HTTP on :6666
goos: darwin
goarch: amd64
pkg: gotest/01-http
BenchmarkHTTP-4         2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 06:54:20 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 320ms
2020/12/13 06:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 640ms
2020/12/13 06:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:22 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:23 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:24 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:25 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:26 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:27 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 06:54:28 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
   10000           1248583 ns/op           22690 B/op        126 allocs/op
PASS
ok      gotest/01-http  12.971s
```

##### HTTP2.0

```bash
$ GOMAXPROCS=4 go test -bench=. -benchmem -benchtime=10s   
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] Listening and serving HTTPS on :6666
goos: darwin
goarch: amd64
pkg: gotest/02-http2
BenchmarkHTTP2-4          109705            107176 ns/op            8013 B/op         84 allocs/op
PASS
ok      gotest/02-http2 13.309s
```



### 连接数对比

很明显的测试http的方式的情况，已经有打印错误的报错日志`2020/12/13 06:47:05 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s`，错误日志，简单的意思就是高并发的情况下打开句柄或者socket太多了，无法建立新的连接了，这里的问题来了，为什么报的是 `too many open files`? 那就是你知道的，**linux一切皆是文件**，写过`c socket`网络编程的应该知道，操作socket的方式，是不是和操作file很像。以下更新一下测试的具体参数信息?

- 简单的查看方法

  ```bash
  $ netstat -n | awk '/^tcp/ {n=split($(NF-1),array,":");if(n<=2)++S[array[(1)]];else++S[array[(4)]];++s[$NF];++N} END {for(a in S){printf("%-20s %s\n", a, S[a]);++I}printf("%-20s %s\n","TOTAL_IP",I);for(a in s) printf("%-20s %s\n",a, s[a]);printf("%-20s %s\n","TOTAL_LINK",N);}' | grep 6666
  
  $ netstat -n | awk '/^tcp/ {n=split($(NF-1),array,":");if(n<=2)++S[array[(1)]];else++S[array[(4)]];++s[$NF];++N} END {for(a in S){printf("%-20s %s\n", a, S[a]);++I}printf("%-20s %s\n","TOTAL_IP",I);for(a in s) printf("%-20s %s\n",a, s[a]);printf("%-20s %s\n","TOTAL_LINK",N);}' | TIME_WAIT 
  
  // 查看各个TCP状态的数量信息
  $ netstat -n | awk '/^tcp/ {++S[$NF]} END {for(a in S) print a, S[a]}'
  ```

#### HTTP1.1

```bash
$ netstat -n | awk '/^tcp/ {n=split($(NF-1),array,":");if(n<=2)++S[array[(1)]];else++S[array[(4)]];++s[$NF];++N} END {for(a in S){printf("%-20s %s\n", a, S[a]);++I}printf("%-20s %s\n","TOTAL_IP",I);for(a in s) printf("%-20s %s\n",a, s[a]);printf("%-20s %s\n","TOTAL_LINK",N);}' | grep 6666
127.0.0.1.6666       5119

$ netstat -n | awk '/^tcp/ {n=split($(NF-1),array,":");if(n<=2)++S[array[(1)]];else++S[array[(4)]];++s[$NF];++N} END {for(a in S){printf("%-20s %s\n", a, S[a]);++I}printf("%-20s %s\n","TOTAL_IP",I);for(a in s) printf("%-20s %s\n",a, s[a]);printf("%-20s %s\n","TOTAL_LINK",N);}' | grep TIME_WAIT
TIME_WAIT            5130
```

需要使用大量的连接进行消息的传输，会`队头堵塞`原因吧。

这么看来，在持续并发的情况下，会建立非常多的连接资源的使用，如果有空闲的连接关闭的情况，会导致大量的TIME_WAIT消息，后导致后续连接的异常。

#### HTTP2.0

```bash
$ netstat -n | awk '/^tcp/ {n=split($(NF-1),array,":");if(n<=2)++S[array[(1)]];else++S[array[(4)]];++s[$NF];++N} END {for(a in S){printf("%-20s %s\n", a, S[a]);++I}printf("%-20s %s\n","TOTAL_IP",I);for(a in s) printf("%-20s %s\n",a, s[a]);printf("%-20s %s\n","TOTAL_LINK",N);}' | grep 6666
127.0.0.1.6666       1
```

目前显示HTTP2测试的情况，只有一个连接，具体也不清楚为什么？只知道HTTP2可以不用多连接，使用流ID的方式传输的，但是就一个连接，有点强。有没有发现一个问题，这边测试都是串行测试的，没有使用到并发测试的，会上会这个原因导致只有一个连接？

## 总结

- 这边只在本地的Mac上做了基础的测试，数据基本能体现出使用HTTPS的HTTP2.0可以有比较大的优势，但是测试的方式方法不全，之前也没有写过相关测试的文章，有什么建议的测试方便，建议指导
- 后续补充测试部分：
  - 并行测试HTTP请求
  - Body对HTTP1.1和HTTP2.0性能的影响
  - Header对HTTP1.1和HTTP2.0性能的影响
- 应该还会有下一篇分析的。待补充。。。