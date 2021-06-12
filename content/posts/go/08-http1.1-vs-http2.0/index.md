---
weight: 1
title: "【Go】HTTP1.1和HTTP2.0 性能对比简单测试【2】"
date: 2020-12-13T15:28:06+08:00
lastmod: 2020-12-13T15:28:06+08:00
draft: true
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "HTTP1.0和HTTP2.0扩展测试。"
resources:
- name: "featured-image"
  src: "featured-image.png"
tags: ["go"]
categories: ["go"]

lightgallery: true

toc:
  auto: false
---

HTTP1.0和HTTP2.0扩展测试。

<!--more-->

## 简述

之前对HTTP1.1和HTTP2.0做了简单的测试，今天继续扩展一些测试demo，继续分析一下性能问题。

## 性能测试

### 并发性能测试

#### HTTP1.1
```go
func BenchmarkHTTPRunParallel(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, nil)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}
```
##### 测试结果

```bash
// 连接数
127.0.0.1.6666       15349

// 测试结果
$ GOMAXPROCS=4 go test -bench=HTTPRunParallel$ -benchmem -benchtime=10s 

goos: darwin
goarch: amd64
pkg: gotest/01-http
BenchmarkHTTPRunParallel-4      2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 13:54:21 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 13:54:22 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 320ms
2020/12/13 13:54:22 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 640ms
2020/12/13 13:54:22 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:23 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:24 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:25 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:26 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:27 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:28 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:29 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 13:54:32 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 320ms
2020/12/13 13:54:33 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 640ms
2020/12/13 13:54:33 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:34 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:35 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:36 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:37 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:38 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:39 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:40 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:41 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:41 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 13:54:41 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 20ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 40ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 80ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 160ms
2020/12/13 13:54:43 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 320ms
2020/12/13 13:54:44 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 640ms
2020/12/13 13:54:44 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:45 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:46 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:47 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:48 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:49 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 1s
2020/12/13 13:54:50 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 5ms
2020/12/13 13:54:50 http: Accept error: accept tcp [::]:6666: accept: too many open files; retrying in 10ms
 1762750             10968 ns/op            3073 B/op         43 allocs/op
PASS
ok      gotest/01-http  30.715s
```

#### HTTP2.0
```go
func BenchmarkHTTP2RunParallel(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, nil)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}
```
##### 测试结果

```bash
// 连接数
127.0.0.1.6666       1

// 测试结果
$ GOMAXPROCS=4 go test -bench=HTTP2RunParallel$ -benchmem -benchtime=10s 

goos: darwin
goarch: amd64
pkg: gotest/02-http2
BenchmarkHTTP2RunParallel-4       245194             51889 ns/op            7970 B/op         83 allocs/op
PASS
ok      gotest/02-http2 13.547s

$ GOMAXPROCS=4 go test -bench=HTTP2RunParallelWithBodyAndHeader$ -benchmem -benchtime=10s
[GIN-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:   export GIN_MODE=release
 - using code:  gin.SetMode(gin.ReleaseMode)

[GIN-debug] Listening and serving HTTPS on :6666
goos: darwin
goarch: amd64
pkg: gotest/02-http2
BenchmarkHTTP2RunParallelWithBodyAndHeader-4       27138            439417 ns/op           73953 B/op        506 allocs/op

PASS
ok      gotest/02-http2 16.786s
```


package _2_http2

import (
	"bytes"
	"crypto/tls"
	"log"
	"math/rand"
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

var (
	client http.Client
	header http.Header
	reader *bytes.Reader
	r      *rand.Rand
)

func randString(len int) string {
	bytesSlice := make([]byte, len)
	for i := 0; i < len; i++ {
		b := r.Intn(26) + 65
		bytesSlice[i] = byte(b)
	}
	return string(bytesSlice)
}

func init() {
	testRunHTTPSServer()
	client.Timeout = 10 * time.Second
	client.Transport = &http2.Transport{TLSClientConfig: &tls.Config{InsecureSkipVerify: true}}

	//// 生成body.
	//var body bytes.Buffer
	//for i := 0; i < 10000; i++ {
	//	_, _ = fmt.Fprint(&body, i)
	//}
	//
	//r = rand.New(rand.NewSource(time.Now().Unix()))
	//
	//reader = bytes.NewReader(body.Bytes())
	//
	//const headerLen = 100
	//header = make(http.Header, headerLen)
	//for i := 0; i < headerLen; i++ {
	//	header.Add(randString(headerLen), randString(headerLen))
	//}
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

func BenchmarkHTTP2WithBody(b *testing.B) {
	for i := 0; i < b.N; i++ {
		req, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, reader)
		if err != nil {
			panic(err)
		}
		_, _ = client.Do(req)
	}
}

func BenchmarkHTTP2WithBodyAndHeader(b *testing.B) {
	for i := 0; i < b.N; i++ {
		request, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, reader)
		if err != nil || request == nil {
			panic(err)
		}
		request.Header = header
		_, _ = client.Do(request)
	}
}

func BenchmarkHTTP2RunParallel(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, nil)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}

func BenchmarkHTTP2RunParallelWithBody(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, reader)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}
func BenchmarkHTTP2RunParallelWithBodyAndHeader(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			request, err := http.NewRequest(http.MethodGet, "https://127.0.0.1"+HTTPSListenAddr, reader)
			if err != nil || request == nil {
				panic(err)
			}
			request.Header = header
			_, _ = client.Do(request)
		}
	})
}













package _1_http

import (
	"bytes"
	"log"
	"math/rand"
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

var (
	client http.Client
	header http.Header
	reader *bytes.Reader
	r      *rand.Rand
)

func randString(len int) string {
	bytesSlice := make([]byte, len)
	for i := 0; i < len; i++ {
		b := r.Intn(26) + 65
		bytesSlice[i] = byte(b)
	}
	return string(bytesSlice)
}

func init() {
	testRunHTTPSServer()
	client.Timeout = 10 * time.Second

	//// 生成body.
	//var body bytes.Buffer
	//for i := 0; i < 10000; i++ {
	//	_, _ = fmt.Fprint(&body, i)
	//}
	//
	//r = rand.New(rand.NewSource(time.Now().Unix()))
	//reader = bytes.NewReader(body.Bytes())
	//
	//const headerLen = 100
	//header = make(http.Header, headerLen)
	//for i := 0; i < headerLen; i++ {
	//	header.Add(randString(headerLen), randString(headerLen))
	//}
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

func BenchmarkHTTPWithBody(b *testing.B) {
	for i := 0; i < b.N; i++ {
		req, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, reader)
		if err != nil {
			panic(err)
		}
		_, _ = client.Do(req)
	}
}

func BenchmarkHTTPWithBodyAndHeader(b *testing.B) {
	for i := 0; i < b.N; i++ {
		request, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, reader)
		if err != nil || request == nil {
			panic(err)
		}
		request.Header = header
		_, _ = client.Do(request)
	}
}

func BenchmarkHTTPRunParallel(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, nil)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}

func BenchmarkHTTPRunParallelWithBody(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			req, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, reader)
			if err != nil {
				panic(err)
			}
			_, _ = client.Do(req)
		}
	})
}

func BenchmarkHTTPRunParallelWithBodyAndHeader(b *testing.B) {
	b.RunParallel(func(pb *testing.PB) {
		for pb.Next() {
			request, err := http.NewRequest(http.MethodGet, "http://127.0.0.1"+HTTPListenAddr, reader)
			if err != nil || request == nil {
				panic(err)
			}
			request.Header = header
			_, _ = client.Do(request)
		}
	})
}


性能测试差距过大，无法判断。