# 【Go】实现json日志格式化观察程序


<!--more-->

## 1 简述
`Log`目前微服务日志量大，存储数据多，切分散，常常需要使用es的收集日志。
传统的日志格式打印的数据不利于`es`的分析使用，日志存储`es`上`Json`格式的日志是非常用必要的，
方便数据分析和检索，那么问题来了，`Json`格式的数据有利于机器的分析和检索，
那么人眼观察变的异常的困难，还好是`Json`格式的日志，所以可以对日志进行格式化处理。  

## 2 源码
```go
package main

import (
	"bufio"
	"bytes"
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"strings"
)

var fileString = flag.String("f", "./input.log", "Input Your cli string")

func main() {
	flag.Parse()

	if strings.Contains(*fileString, "./") {
		fileName := *fileString
		*fileString = fileName[2:]
	}

	fRead, err := os.Open(*fileString)
	if err != nil {
		fmt.Printf("failed open the file %s", *fileString)
		return
	}
	defer func() {
		_ = fRead.Close()
	}()

	outFileString := "output-" + *fileString

	if isExist(outFileString) {
		os.Remove(outFileString)
	}

	// 创建输出文件 output.txt 用于存放输出结果
	fWrite, err2 := os.Create(outFileString)
	if err2 != nil {
		fmt.Println(err)
		panic(err2)
	}
	defer func() {
		_ = fWrite.Close()
	}()

	// create a scanner
	fs := bufio.NewScanner(fRead)

	// scan file
	// https://golang.org/pkg/bufio/#Scanner.Scan
	for fs.Scan() {
		strLine := fs.Bytes()
		formatStr, _ := handleStr(strLine)

		_, _ = fWrite.Write(formatStr)
	}
}

func handleStr(b []byte) ([]byte, error) {
	var out bytes.Buffer
	err := json.Indent(&out, b, "", "\t")
	if err != nil {
		return nil, err
	}
	jsonIndent := out.Bytes()

	time, level, err := getTimeAndLevel(b)
	timeLevelInfo := fmt.Sprintf("%s:%6s\t\t", time, level)

	var formatStr = make([]byte, 0, len(jsonIndent))
	formatStr = append(formatStr, timeLevelInfo...)
	for _, ch := range jsonIndent {
		formatStr = append(formatStr, ch)
		if ch == '\n' {
			formatStr = append(formatStr, timeLevelInfo...)
		}
	}
	formatStr = append(formatStr, '\n')

	return formatStr, err
}

func getTimeAndLevel(b []byte) (string, string, error) {
	type data struct {
		Time  string `json:"time"`
		Level string `json:"level"`
	}
	var d data
	if err := json.Unmarshal(b, &d); err != nil {
		return "", "", err
	}

	return d.Time, d.Level, nil
}

func isExist(path string) bool {
	_, err := os.Stat(path)
	if err != nil {
		if os.IsExist(err) {
			return true
		}
		if os.IsNotExist(err) {
			return false
		}
		return false
	}

	return true
}
```
## 3 格式化对比
### 3.1 格式化前数据
```
GOROOT=C:\Go #gosetup
GOPATH=D:\GoPath #gosetup
C:\Go\bin\go.exe build -o D:\Users\yl1754\AppData\Local\Temp\___703go_build_mars_cmd.exe mars/cmd #gosetup
D:\Users\yl1754\AppData\Local\Temp\___703go_build_mars_cmd.exe #gosetup
2021-02-24T19:50:35.523+0800	INFO	cmd/mars.go:18	mars on init ...
{"level":"INFO","time":"2021-02-24T19:50:35.543+0800","caller":"cmd/init.go:20","msg":"env:dev, region:cn-shanghai ip:10.71.4.28"}
{"level":"INFO","time":"2021-02-24T19:50:35.543+0800","caller":"cmd/mars.go:30","msg":"mars on start ..."}
[GEE-debug] [WARNING] Running in "debug" mode. Switch to "release" mode in production.
 - using env:	export GEE_MODE=release
 - using code:	gee.SetMode(gee.ReleaseMode)

[GEE-debug] GET    /meeting-port-manager/api/v1/meetings/:meetingID/test --> mars/internal/service/consumerservice/router.(*router).initRoutes.func1 (3 handlers)
[GEE-debug] POST   /meeting-port-manager/api/v1/meetings/:meetingID/body --> mars/internal/service/consumerservice/router.(*router).initRoutes.func2 (3 handlers)
[GEE-debug] POST   /meeting-port-manager/api/v1/meetings/:meetingID/reader --> mars/internal/service/consumerservice/router.(*router).initRoutes.func3 (3 handlers)
{"level":"INFO","time":"2021-02-24T19:50:35.543+0800","caller":"consumer/consumer.go:52","msg":"yrmq server instance mars_1981391775"}
{"level":"DEBUG","time":"2021-02-24T19:50:35.543+0800","caller":"consumer/consumer.go:43","msg":"YRMQ start success. {Addr:10.120.26.62:9076 AccessKey: SecretKey:}"}
{"level":"INFO","time":"2021-02-24T19:50:35.754+0800","caller":"http/client.go:210","msg":"http client","http.request.method":"POST","url.path":"/api/v1/token","url.query":{},"destination.address":"10.120.26.62:9979","X-Y-Request-Id":"da421472-c67a-46b6-8ce7-971c3c94ea8e","http.request.body.content":"{\"grant_type\":\"client_credentials\"}","http.response.status_code":200,"http.response.body.content":"{\"access_token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJkZXMiOjAsImFrcCI6MCwiY3BjIjpbInVzZXItbWFuYWdlciIsInlnYSIsInlwdXNoIiwicmVndWxhdG9yIl0sImFraWQiOiJkNmE0YTAzNDVhNzY0MDMwOGY5MTMxMDBlMTE3ZjRkZiIsImFrcyI6MCwiYWsiOiI0Y2M4MmVmYTg5NjE0ZDVmOGMyMDQ4YjE5OWNkNTAxZiIsImRlbCI6MCwiYWt0IjowLCJleHAiOjE2MTQxNjkyMDksImp0aSI6IjZlZjFjZjAwNTE2MzQyNDlhYjU3NGM1OTcxYzNjMDllIiwiZGlkIjoiOTgzZjhmODQxMjU0NDYwMGE2MGI1M2JkNWQ1MTI2Y2EifQ.F51cNGkvcfWW-07TTwMqHujTWUPGsA--cdTNjqguXJURMdZsLkFAuXH_Pfm5sNO3H0ougW7-1X2LHanKRIIRxdWqmtbyU5TEZ-DKmszfJgw5W7lCTMobdZsu6jJsYHyDJ-NzvA7zgNO2ZrJamgtUtGFR4ukibCrh9ywb6IQqmu2IHtStbIVRs71AlLrTQ28EVpE0tmOzbQmojEpAieC6hIj19GEB72hug70ArLrXPC_cV3t3FNGyWb-kYi6XOT-yoeMDUWDJpj4J0AiN0F03mCYSqyyj6D43-qcLFaXgUG7uDHNVavVC_9CzVFlrtEEMP89Afa_D2vphiqgJS5y6Ow\",\"token_type\":\"bearer\",\"expires_in\":1799}","cost":209}
{"level":"INFO","time":"2021-02-24T19:51:58.167+0800","caller":"middleware/access_log.go:26","msg":"http server","source.address":"","http.request.method":"POST","url.original":"/meeting-port-manager/api/v1/meetings/123123123/reader","user_agent.original":"EnvDefaultAppID","X-Y-Request-Id":"ded1916d-a5b5-4e2f-9170-7c5bef72a1d8","X-Y-Session-Id":"","http.request.body.content":"{\"displayName\":\"test\"}","http.response.status_code":200,"http.response.body.content":"e3Rlc3R9","cost":0}
{"level":"INFO","time":"2021-02-24T19:51:58.168+0800","caller":"yconn/yconn.go:116","msg":"new conn pool addr 10.120.26.62:9445"}
{"level":"INFO","time":"2021-02-24T19:52:45.800+0800","caller":"middleware/access_log.go:26","msg":"http server","source.address":"","http.request.method":"POST","url.original":"/meeting-port-manager/api/v1/meetings/123123123/reader","user_agent.original":"EnvDefaultAppID","X-Y-Request-Id":"17e7760c-ff8c-48d8-a692-4f9f932084d6","X-Y-Session-Id":"","http.request.body.content":"{\"displayName\":\"test\"}","http.response.status_code":200,"http.response.body.content":"e3Rlc3R9","cost":0}
{"level":"INFO","time":"2021-02-24T19:52:50.720+0800","caller":"middleware/access_log.go:26","msg":"http server","source.address":"","http.request.method":"POST","url.original":"/meeting-port-manager/api/v1/meetings/123123123/reader","user_agent.original":"EnvDefaultAppID","X-Y-Request-Id":"c791a19d-3bb2-4514-bd11-73e31e12bac1","X-Y-Session-Id":"","http.request.body.content":"{\"displayName\":\"test\"}","http.response.status_code":200,"http.response.body.content":"e3Rlc3R9","cost":0}
{"level":"INFO","time":"2021-02-24T19:52:57.456+0800","caller":"middleware/access_log.go:26","msg":"http server","source.address":"","http.request.method":"POST","url.original":"/meeting-port-manager/api/v1/meetings/123123123/reader","user_agent.original":"EnvDefaultAppID","X-Y-Request-Id":"53d4166a-07c6-45a0-b4f6-7313d05bcb89","X-Y-Session-Id":"","http.request.body.content":"{\"displayName\":\"test\"}","http.response.status_code":200,"http.response.body.content":"e3Rlc3R9","cost":0}
```
### 3.2 格式化后数据
```
2021-02-24T19:50:35.543+0800:  INFO		{
2021-02-24T19:50:35.543+0800:  INFO			"level": "INFO",
2021-02-24T19:50:35.543+0800:  INFO			"time": "2021-02-24T19:50:35.543+0800",
2021-02-24T19:50:35.543+0800:  INFO			"caller": "cmd/init.go:20",
2021-02-24T19:50:35.543+0800:  INFO			"msg": "env:dev, region:cn-shanghai ip:10.71.4.28"
2021-02-24T19:50:35.543+0800:  INFO		}
2021-02-24T19:50:35.543+0800:  INFO		{
2021-02-24T19:50:35.543+0800:  INFO			"level": "INFO",
2021-02-24T19:50:35.543+0800:  INFO			"time": "2021-02-24T19:50:35.543+0800",
2021-02-24T19:50:35.543+0800:  INFO			"caller": "cmd/mars.go:30",
2021-02-24T19:50:35.543+0800:  INFO			"msg": "mars on start ..."
2021-02-24T19:50:35.543+0800:  INFO		}
2021-02-24T19:50:35.543+0800:  INFO		{
2021-02-24T19:50:35.543+0800:  INFO			"level": "INFO",
2021-02-24T19:50:35.543+0800:  INFO			"time": "2021-02-24T19:50:35.543+0800",
2021-02-24T19:50:35.543+0800:  INFO			"caller": "consumer/consumer.go:52",
2021-02-24T19:50:35.543+0800:  INFO			"msg": "yrmq server instance mars_1981391775"
2021-02-24T19:50:35.543+0800:  INFO		}
2021-02-24T19:50:35.543+0800: DEBUG		{
2021-02-24T19:50:35.543+0800: DEBUG			"level": "DEBUG",
2021-02-24T19:50:35.543+0800: DEBUG			"time": "2021-02-24T19:50:35.543+0800",
2021-02-24T19:50:35.543+0800: DEBUG			"caller": "consumer/consumer.go:43",
2021-02-24T19:50:35.543+0800: DEBUG			"msg": "YRMQ start success. {Addr:10.120.26.62:9076 AccessKey: SecretKey:}"
2021-02-24T19:50:35.543+0800: DEBUG		}
2021-02-24T19:50:35.754+0800:  INFO		{
2021-02-24T19:50:35.754+0800:  INFO			"level": "INFO",
2021-02-24T19:50:35.754+0800:  INFO			"time": "2021-02-24T19:50:35.754+0800",
2021-02-24T19:50:35.754+0800:  INFO			"caller": "http/client.go:210",
2021-02-24T19:50:35.754+0800:  INFO			"msg": "http client",
2021-02-24T19:50:35.754+0800:  INFO			"http.request.method": "POST",
2021-02-24T19:50:35.754+0800:  INFO			"url.path": "/api/v1/token",
2021-02-24T19:50:35.754+0800:  INFO			"url.query": {},
2021-02-24T19:50:35.754+0800:  INFO			"destination.address": "10.120.26.62:9979",
2021-02-24T19:50:35.754+0800:  INFO			"X-Y-Request-Id": "da421472-c67a-46b6-8ce7-971c3c94ea8e",
2021-02-24T19:50:35.754+0800:  INFO			"http.request.body.content": "{\"grant_type\":\"client_credentials\"}",
2021-02-24T19:50:35.754+0800:  INFO			"http.response.status_code": 200,
2021-02-24T19:50:35.754+0800:  INFO			"http.response.body.content": "{\"access_token\":\"eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJkZXMiOjAsImFrcCI6MCwiY3BjIjpbInVzZXItbWFuYWdlciIsInlnYSIsInlwdXNoIiwicmVndWxhdG9yIl0sImFraWQiOiJkNmE0YTAzNDVhNzY0MDMwOGY5MTMxMDBlMTE3ZjRkZiIsImFrcyI6MCwiYWsiOiI0Y2M4MmVmYTg5NjE0ZDVmOGMyMDQ4YjE5OWNkNTAxZiIsImRlbCI6MCwiYWt0IjowLCJleHAiOjE2MTQxNjkyMDksImp0aSI6IjZlZjFjZjAwNTE2MzQyNDlhYjU3NGM1OTcxYzNjMDllIiwiZGlkIjoiOTgzZjhmODQxMjU0NDYwMGE2MGI1M2JkNWQ1MTI2Y2EifQ.F51cNGkvcfWW-07TTwMqHujTWUPGsA--cdTNjqguXJURMdZsLkFAuXH_Pfm5sNO3H0ougW7-1X2LHanKRIIRxdWqmtbyU5TEZ-DKmszfJgw5W7lCTMobdZsu6jJsYHyDJ-NzvA7zgNO2ZrJamgtUtGFR4ukibCrh9ywb6IQqmu2IHtStbIVRs71AlLrTQ28EVpE0tmOzbQmojEpAieC6hIj19GEB72hug70ArLrXPC_cV3t3FNGyWb-kYi6XOT-yoeMDUWDJpj4J0AiN0F03mCYSqyyj6D43-qcLFaXgUG7uDHNVavVC_9CzVFlrtEEMP89Afa_D2vphiqgJS5y6Ow\",\"token_type\":\"bearer\",\"expires_in\":1799}",
2021-02-24T19:50:35.754+0800:  INFO			"cost": 209
2021-02-24T19:50:35.754+0800:  INFO		}
2021-02-24T19:51:58.167+0800:  INFO		{
2021-02-24T19:51:58.167+0800:  INFO			"level": "INFO",
2021-02-24T19:51:58.167+0800:  INFO			"time": "2021-02-24T19:51:58.167+0800",
2021-02-24T19:51:58.167+0800:  INFO			"caller": "middleware/access_log.go:26",
2021-02-24T19:51:58.167+0800:  INFO			"msg": "http server",
2021-02-24T19:51:58.167+0800:  INFO			"source.address": "",
2021-02-24T19:51:58.167+0800:  INFO			"http.request.method": "POST",
2021-02-24T19:51:58.167+0800:  INFO			"url.original": "/meeting-port-manager/api/v1/meetings/123123123/reader",
2021-02-24T19:51:58.167+0800:  INFO			"user_agent.original": "EnvDefaultAppID",
2021-02-24T19:51:58.167+0800:  INFO			"X-Y-Request-Id": "ded1916d-a5b5-4e2f-9170-7c5bef72a1d8",
2021-02-24T19:51:58.167+0800:  INFO			"X-Y-Session-Id": "",
2021-02-24T19:51:58.167+0800:  INFO			"http.request.body.content": "{\"displayName\":\"test\"}",
2021-02-24T19:51:58.167+0800:  INFO			"http.response.status_code": 200,
2021-02-24T19:51:58.167+0800:  INFO			"http.response.body.content": "e3Rlc3R9",
2021-02-24T19:51:58.167+0800:  INFO			"cost": 0
2021-02-24T19:51:58.167+0800:  INFO		}
2021-02-24T19:51:58.168+0800:  INFO		{
2021-02-24T19:51:58.168+0800:  INFO			"level": "INFO",
2021-02-24T19:51:58.168+0800:  INFO			"time": "2021-02-24T19:51:58.168+0800",
2021-02-24T19:51:58.168+0800:  INFO			"caller": "yconn/yconn.go:116",
2021-02-24T19:51:58.168+0800:  INFO			"msg": "new conn pool addr 10.120.26.62:9445"
2021-02-24T19:51:58.168+0800:  INFO		}
2021-02-24T19:52:45.800+0800:  INFO		{
2021-02-24T19:52:45.800+0800:  INFO			"level": "INFO",
2021-02-24T19:52:45.800+0800:  INFO			"time": "2021-02-24T19:52:45.800+0800",
2021-02-24T19:52:45.800+0800:  INFO			"caller": "middleware/access_log.go:26",
2021-02-24T19:52:45.800+0800:  INFO			"msg": "http server",
2021-02-24T19:52:45.800+0800:  INFO			"source.address": "",
2021-02-24T19:52:45.800+0800:  INFO			"http.request.method": "POST",
2021-02-24T19:52:45.800+0800:  INFO			"url.original": "/meeting-port-manager/api/v1/meetings/123123123/reader",
2021-02-24T19:52:45.800+0800:  INFO			"user_agent.original": "EnvDefaultAppID",
2021-02-24T19:52:45.800+0800:  INFO			"X-Y-Request-Id": "17e7760c-ff8c-48d8-a692-4f9f932084d6",
2021-02-24T19:52:45.800+0800:  INFO			"X-Y-Session-Id": "",
2021-02-24T19:52:45.800+0800:  INFO			"http.request.body.content": "{\"displayName\":\"test\"}",
2021-02-24T19:52:45.800+0800:  INFO			"http.response.status_code": 200,
2021-02-24T19:52:45.800+0800:  INFO			"http.response.body.content": "e3Rlc3R9",
2021-02-24T19:52:45.800+0800:  INFO			"cost": 0
2021-02-24T19:52:45.800+0800:  INFO		}
2021-02-24T19:52:50.720+0800:  INFO		{
2021-02-24T19:52:50.720+0800:  INFO			"level": "INFO",
2021-02-24T19:52:50.720+0800:  INFO			"time": "2021-02-24T19:52:50.720+0800",
2021-02-24T19:52:50.720+0800:  INFO			"caller": "middleware/access_log.go:26",
2021-02-24T19:52:50.720+0800:  INFO			"msg": "http server",
2021-02-24T19:52:50.720+0800:  INFO			"source.address": "",
2021-02-24T19:52:50.720+0800:  INFO			"http.request.method": "POST",
2021-02-24T19:52:50.720+0800:  INFO			"url.original": "/meeting-port-manager/api/v1/meetings/123123123/reader",
2021-02-24T19:52:50.720+0800:  INFO			"user_agent.original": "EnvDefaultAppID",
2021-02-24T19:52:50.720+0800:  INFO			"X-Y-Request-Id": "c791a19d-3bb2-4514-bd11-73e31e12bac1",
2021-02-24T19:52:50.720+0800:  INFO			"X-Y-Session-Id": "",
2021-02-24T19:52:50.720+0800:  INFO			"http.request.body.content": "{\"displayName\":\"test\"}",
2021-02-24T19:52:50.720+0800:  INFO			"http.response.status_code": 200,
2021-02-24T19:52:50.720+0800:  INFO			"http.response.body.content": "e3Rlc3R9",
2021-02-24T19:52:50.720+0800:  INFO			"cost": 0
2021-02-24T19:52:50.720+0800:  INFO		}
2021-02-24T19:52:57.456+0800:  INFO		{
2021-02-24T19:52:57.456+0800:  INFO			"level": "INFO",
2021-02-24T19:52:57.456+0800:  INFO			"time": "2021-02-24T19:52:57.456+0800",
2021-02-24T19:52:57.456+0800:  INFO			"caller": "middleware/access_log.go:26",
2021-02-24T19:52:57.456+0800:  INFO			"msg": "http server",
2021-02-24T19:52:57.456+0800:  INFO			"source.address": "",
2021-02-24T19:52:57.456+0800:  INFO			"http.request.method": "POST",
2021-02-24T19:52:57.456+0800:  INFO			"url.original": "/meeting-port-manager/api/v1/meetings/123123123/reader",
2021-02-24T19:52:57.456+0800:  INFO			"user_agent.original": "EnvDefaultAppID",
2021-02-24T19:52:57.456+0800:  INFO			"X-Y-Request-Id": "53d4166a-07c6-45a0-b4f6-7313d05bcb89",
2021-02-24T19:52:57.456+0800:  INFO			"X-Y-Session-Id": "",
2021-02-24T19:52:57.456+0800:  INFO			"http.request.body.content": "{\"displayName\":\"test\"}",
2021-02-24T19:52:57.456+0800:  INFO			"http.response.status_code": 200,
2021-02-24T19:52:57.456+0800:  INFO			"http.response.body.content": "e3Rlc3R9",
2021-02-24T19:52:57.456+0800:  INFO			"cost": 0
2021-02-24T19:52:57.456+0800:  INFO		}
```
## 4 总结
 具体代码非常的简单，写的比较随便。本篇文章主要用于保存源码，也不多做什么介绍了
 对比发现，格式化后的日志配合`notepad++`可以大大的提高检索的效率。
 最后，提示大家，学习了`Go语言`也去看看你身边有什么可以编写的小工具吧。
