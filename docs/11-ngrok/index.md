# 【ngrok】微软推荐的使用内网穿透工具

<!--more-->

## 简述

​	内网穿透很多情况都会使用到，目前很多服务使用webhook的方式的话，有一个外网能响应到内网服务的方式是非常有必要的。尝试了几个工具之后，最终给大家推荐一个软件，就是今天主题，`ngrok`。跨平台，window、linux、mac都ok。

## 开始

### 环境的安装

- 官方网站：[ngrok](https://ngrok.com)
- 下载对应的版本
- 几个环境的版本都是使用压缩包的新式，解压即可使用。

### 获取认证token

- 注册账号
- 获取token
  - Authentication -> Your Authtoken

### 运行测试

#### 简单使用

```bash
// 填写token
$ ./ngrok authtoken {authtoken}
Authtoken saved to configuration file: /Users/coolliuzw/.ngrok2/ngrok.yml
# 配置文件生成地址 /Users/coolliuzw/.ngrok2/ngrok.yml

// 内网穿透http 8080 端口
$ ./ngrok http 8080

ngrok by @inconshreveable                                                                                                                                                                   (Ctrl+C to quit)

Session Status                online
Account                       coolliuzw (Plan: Free)
Version                       2.3.35
Region                        United States (us)
Web Interface                 http://127.0.0.1:4040
Forwarding                    http://e297d4f71578.ngrok.io -> http://localhost:8080
Forwarding                    https://e297d4f71578.ngrok.io -> http://localhost:8080

Connections                   ttl     opn     rt1     rt5     p50     p90
                              0       0       0.00    0.00    0.00    0.00
```

#### 配置文件使用

- ngrok.yml

```yml
authtoken: {authtoken}

tunnels:
  http:
    proto: http
    addr: 8080
```

- `$ ./ngrok start -all`

  ```bash
  Session Status                online
  Account                       coolliuzw (Plan: Free)
  Version                       2.3.35
  Region                        United States (us)
  Web Interface                 http://127.0.0.1:4040
  Forwarding                    http://d174cf132c6a.ngrok.io -> http://localhost:8080
  Forwarding                    https://d174cf132c6a.ngrok.io -> http://localhost:8080
  
  Connections                   ttl     opn     rt1     rt5     p50     p90
                                0       0       0.00    0.00    0.00    0.00
  ```

## 总结

介绍了ngrok的使用，基本能满足使用。需要更具体的使用方法的可以查看官网，基本free版本的就够我们日常使用了，如果有特殊需求的话可以使用付费版本。

~

**小任务**：尝试搭建本地搭建一个http服务，使用手机访问服务得到响应。
