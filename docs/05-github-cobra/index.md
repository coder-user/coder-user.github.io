# 【Go】Cobra Go最强大的命令行工具【1】


简单的介绍一个Go语言必须的库，强大的命令行工具.

<!--more-->

## 简介

Cobra既是一个用于创建功能强大的现代CLI应用程序的库，也是一个生成应用程序和命令文件的程序。

Cobra被用于许多Go项目中，比如`Kubernetes`、`Hugo`和`githubcli`等等。

github地址: [cobra](https://github.com/spf13/cobra)

## 准备工作

### 安装

```bash
go get -u github.com/spf13/cobra
```

然后在你的项目引入Cobra的包:

```bash
import "github.com/spf13/cobra"
```

go get后，也会给系统安一个cobra的工具，我们可以使用这个工具生成项目的demo。

## 工具常用命令

```bash
$ cobra -h                                      
Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.

Usage:
  cobra [command]

Available Commands:
  add         Add a command to a Cobra Application
  help        Help about any command
  init        Initialize a Cobra Application

Flags:
  -a, --author string    author name for copyright attribution (default "YOUR NAME")
      --config string    config file (default is $HOME/.cobra.yaml)
  -h, --help             help for cobra
  -l, --license string   name of license for the project
      --viper            use Viper for configuration (default true)

Use "cobra [command] --help" for more information about a command.
```



## 基础实践

### demo工程项目生成

- 建议cobra空文件夹

- 使用go mod初始化文件 `go mod init cobra`

- 使用cobra工具生成项目文件:

  ```bash
  cobra init --pkg-name cobra --author coolliuzw
  ```

- 运行测试

  ```bash
  $ go run main.go            
  A longer description that spans multiple lines and likely contains
  examples and usage of using your application. For example:
  
  Cobra is a CLI library for Go that empowers applications.
  This application is a tool to generate the needed files
  to quickly create a Cobra application.
  ```

步骤执行完成后，就有一个基本可运行的命令行demo。

### demo程序修改

go run main.go，demo输出的是以上的内容，那么我们应该如何去修改他呢？跟我来：

- `vim cmd/root.go` 就能看到输出的这段代码了。cobra自动生成命令行都放置在cmd这个目录下。

  ```go
  // rootCmd represents the base command when called without any subcommands
  var rootCmd = &cobra.Command{
  	Use:   "cobra",
  	Short: "A brief description of your application",
  	Long: `A longer description that spans multiple lines and likely contains
  examples and usage of using your application. For example:
  
  Cobra is a CLI library for Go that empowers applications.
  This application is a tool to generate the needed files
  to quickly create a Cobra application.`,
  	// Uncomment the following line if your bare application
  	// has an action associated with it:
  	//	Run: func(cmd *cobra.Command, args []string) { },
  }
  ```

- demo也有一些注释说明简单的用法，我们来修改一下demo在测试一下。

  - 修改

    ```go
    // rootCmd represents the base command when called without any subcommands
    var rootCmd = &cobra.Command{
      Use:   "cobra",
      Short: "A brief description of coolliuzw",
      Long: `A longer description of coolliuzw blog`,
      // Uncomment the following line if your bare application
      // has an action associated with it:
      //	Run: func(cmd *cobra.Command, args []string) { },
    }
    ```

  - 运行

    ```bash
    go run main.go   
    A longer description of coolliuzw blog
    ```

  - 具体修改了什么看一下代码的注释。

### 添加自定义Cli命令
- 添加`version`命令行工具.
- `cobra add version --author coolliuzw`

- cmd目录下多了一个version.go的文件。

- 尝试修改version测试
  ```go
  // versionCmd represents the version command
  var versionCmd = &cobra.Command{
  	Use:   "version",
  	Short: "A brief description of version",
  	Long: `A longer description of version long`,
  	Run: func(cmd *cobra.Command, args []string) {
  		fmt.Println("version called")
  	},
  }
  ```

- 查看是否添加成功

  ```bash
  go run main.go help   
  A longer description of coolliuzw blog
  
  Usage:
    cobra [command]
  
  Available Commands:
    help        Help about any command
    version     A brief description of version
  
  Flags:
        --config string   config file (default is $HOME/.cobra.yaml)
    -h, --help            help for cobra
    -t, --toggle          Help message for toggle
  
  Use "cobra [command] --help" for more information about a command.
  
  //go run main.go help可以看程序支持的命令行.
  //version     A brief description of version也添加进去了
  ```

- 测试调用.

  ```bash
  $ go run main.go version
  version called
  // 成功调用
  ```

  

## 总结

- 这边只说说demo怎么构建起来，是不是很简单。去创建你的cli工具吧
