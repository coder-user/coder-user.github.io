# 【Go】开发和编译环境的基础安装【1】


go语言编译环境安装的简单介绍.

<!--more-->

## 简述
- 学习一门新的语言，安装一个可以运行调试的环境尤为重要。
- Go语言是可跨平台的语言，支持常见的开发环境
  - Linux
  - Mac OS X
  - Windows

## 开始

### Go语言官网

- [https://golang.org](https://golang.org)，一般的情况是无法打开使用的，但是go官方有一个中文镜像的官网 [https://golang.google.cn](https://golang.google.cn)，大家可以使用这个网址下载。
- 安装包下载建议，一般使用官方最新的release版本即可。
- 点击[download](https://golang.google.cn/dl/)进行选着相应的系统版本安装。

## Linux

If you have a previous version of Go installed, be sure to [remove it](https://golang.google.cn/doc/manage-install) before installing another.

1. Download the archive and extract it into /usr/local, creating a Go tree in /usr/local/go.

   For example, run the following as root or through `sudo`:

   ```sh
   tar -C /usr/local -xzf go1.14.3.linux-amd64.tar.gz
   ```

2. Add /usr/local/go/bin to the

   ```sh
   PATH
   ```

   environment variable.

   You can do this by adding the following line to your $HOME/.profile or /etc/profile (for a system-wide installation):

   ```sh
   export PATH=$PATH:/usr/local/go/bin
   ```

   **Note:** Changes made to a profile file may not apply until the next time you log into your computer. To apply the changes immediately, just run the shell commands directly or execute them from the profile using a command such as `source $HOME/.profile`.

3. Verify that you've installed Go by opening a command prompt and typing the following command:

   ```sh
   $ go version
   ```

4. Confirm that the command prints the installed version of Go.

### 基础安装实战

- 建议使用wget下载到linux的临时目录中.

  - eg: wget https://dl.google.com/go/go1.14.4.linux-amd64.tar.gz
  - tar -C /usr/local -xzf **{name}** 
    - Eg: tar -C /usr/local -xzf go1.14.4.linux-amd64.tar.gz
  - 修改环境变量
    - vi /etc/profile
 - 打开 /etc/profile，尾行添加:
        - PATH=$PATH:/usr/local/go/bin
    - 保存退出
      - source /etc/profile
- 查看版本号，验证是否生效。
      - go version

## Window

1. Open the MSI file you downloaded and follow the prompts to install Go.

   By default, the installer will install Go to C:\Go. You can change the location as needed. After installing, you will need to close and reopen any open command prompts so that changes to the environment made by the installer are reflected at the command prompt.

2. Verify that you've installed Go.

   1. In **Windows**, click the **Start** menu.

   2. In the menu's search box, type `cmd`, then press the **Enter** key.

   3. In the Command Prompt window that appears, type the following command:

      ```sh
      $ go version
      ```

   4. Confirm that the command prints the installed version of Go.

## Mac

1. Open the package file you downloaded and follow the prompts to install Go.

   The package installs the Go distribution to /usr/local/go. The package should put the /usr/local/go/bin directory in your `PATH` environment variable. You may need to restart any open Terminal sessions for the change to take effect.

2. Verify that you've installed Go by opening a command prompt and typing the following command:

   ```sh
   $ go version
   ```

3. Confirm that the command prints the installed version of Go.



## 总结

​	主要介绍，Go包的安装，下一篇介绍各个平台使用的开发工具。


