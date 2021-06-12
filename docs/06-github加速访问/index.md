# 【开发工具】Github访问加速的常用方式和技巧

<!--more-->
## 1 简介
​	访问`github`是程序员经常要用的，查询相关优秀的开源库学习，必备的网址，为什么要加速访问，相信大家都清楚，那么今天说说怎么加速访问。
## 2 常用的加速方法  
### 2.1 GitHub 镜像访问
提供两个最常用的镜像地址:

- [https://hub.fastgit.org](https://hub.fastgit.org)

- [https://github.com.cnpmjs.org](https://github.com.cnpmjs.org)

镜像网站，网站的内容跟 GitHub 是完整同步的镜像，然后在这个网站里面进行下载克隆等操作。

### 2.2 GitHub 文件加速
利用 Cloudflare Workers 对 github release 、archive 以及项目文件进行加速，部署无需服务器且自带CDN.

- https://gh.api.99988866.xyz
- https://g.ioiox.com
  以上网站为演示站点，如无法打开可以查看开源项目：gh-proxy-GitHub(https://hunsh.net/archives/23/) 文件加速自行部署。

### 2.3 Github 加速下载
只需要复制当前 GitHub 地址粘贴到输入框中就可以代理加速下载！

- http://toolwa.com/github/

### 2.4 加速你的 Github
- https://github.zhlh6.cn

输入 Github 仓库地址，使用生成的地址进行 git ssh 等操作

### 2.5 谷歌浏览器 GitHub 加速插件(推荐)
- **Github加速**

### 2.6 GitHub raw 加速

​	GitHub raw 域名并非 github.com 而是 raw.githubusercontent.com，上方的 GitHub 加速如果不能加速这个域名，那么可以使用 Static CDN 提供的反代服务。

​	将 raw.githubusercontent.com 替换为 raw.staticdn.net 即可加速。

### 2.7 GitHub + Jsdelivr

- jsdelivr 唯一美中不足的就是它不能获取 exe 文件以及 Release 处附加的 exe 和 dmg 文件。

也就是说如果 exe 文件是附加在 Release 处但是没有在 code 里面的话是无法获取的。所以只能当作静态文件 cdn 用途，而不能作为 Release 加速下载的用途。

### 2.8 通过 Gitee 中转 fork 仓库下载

网上有很多相关的教程，这里简要的说明下操作。

访问 gitee 网站：https://gitee.com/ 并登录，在顶部选择“从 GitHub/GitLab 导入仓库” 如下：

### 2.9 通过修改 HOSTS 文件进行加速

手动把cdn和ip地址绑定。

第一步：获取 github 的 global.ssl.fastly 地址访问：http://github.global.ssl.fastly.net.ipaddress.com/#ipinfo 获取cdn和ip域名：
得到：199.232.69.194 https://github.global.ssl.fastly.net

第二步：获取github.com地址

访问：https://github.com.ipaddress.com/#ipinfo 获取cdn和ip：
得到：140.82.114.4 http://github.com

第三步：修改 host 文件映射上面查找到的 IP

windows系统：

1、修改C:\Windows\System32\drivers\etc\hosts文件的权限，指定可写入：右击->hosts->属性->安全->编辑->点击Users->在Users的权限“写入”后面打勾。如下：

图片
然后点击确定。

2、右击->hosts->打开方式->选定记事本（或者你喜欢的编辑器）->在末尾处添加以下内容：

199.232.69.194 github.global.ssl.fastly.net

140.82.114.4 github.com

## 3 总结

基本介绍了常用的**Github**加速的方式，希望你有需要使用的情况，可以使用上。

<!--[原文链接，阅读有更好的体验](https://mp.weixin.qq.com/s/hhB8SQd6hJ8v5Z17FLMUAA)-->
