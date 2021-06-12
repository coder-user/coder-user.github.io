# 【Go】如何使用国内同性交友平台Gitee管理你的私有库


<!--more-->

## 1 简述

开发项目中，一些通用的包就是被封装为第三方库，可以作为新的项目的依赖包，在公司的情况，使用gitlab环境，配置.netrc文件即可。

那么在家里怎么管理你的依赖包呢，为了稳定的访问，使用国内最大的同性交友平台`Gitee`管理你的私有库作为项目依赖包的处理。

## 2 开始

### 2.1 SSH公钥添加

- 头像->设置->SSH公钥添加

**SSH公钥生成和查看方式**

- 生成
  - ssh-keygen
  - 运行命令后，按3次回车即可
- 查看
  - cat /root/.ssh/id_rsa.pub

**检测是否配置成功**

- `ssh git@gitee.com` 检测是否有权限

### 2.2 私有仓库的建立

- 后续补充

### 2.3 本地Git的配置

```bash
 git config --global url."git@gitee.com:".insteadOf "https://gitee.com/"
 
 
 //查看配置情况
 cat ~/.gitconfig，只要发现有如下即可.
[url "git@gitee.com:"]
   insteadOf = https://gitee.com/
```

### 2.4 测试

`go get -v gitee.com/{YourAccount}/name`

## 3 总结

基本说明了`Gitee`管理私有仓库的方法，哈哈哈，依然是没有图。

[comment]: <每日一博丨Go使用Gitee私有库作为项目依赖包(https://www.jianshu.com/p/b2bf49adb40a?utm_campaign=maleskine&utm_content=note&utm_medium=seo_notes&utm_source=recommendation)>


