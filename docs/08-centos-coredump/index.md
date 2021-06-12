# 【centos】如何开启coredump文件转储文件

<!--more-->

## 简介

​	开发的环境生成coredump文件是非常有必要的，主要用于处理一些非必现问题，看下异常的堆栈可以对问题进行相对精确的分析。如果没有coredump文件的情况如果日志不足的情况，非常难以定位。

## 开始

## 如何生成coredump?

### 限制生产的大小

- 未配置的情况一般是 0，0是无法产生coredump文件

  ```bash
  $ ulimit -c
  0
  ```

  

- 限制大小调整，直接调整为不限制的情况

  ```bash
  $ ulimit -c unlimited
  
  $ ulimit -c
  unlimited
  ```

- 扩展

  ```bash
  临时 ：ulimit -c unlimited   // core文件大小不限制 
  永久 ：echo  "ulimit -c unlimited" >> ~/.bashrc 
        echo  'ulimit -c unlimited' >> /etc/profile
  ```

### 查看coredump文件

- 查看coredump文件生成路径

  ```bash
  $ cat /proc/sys/kernel/core_pattern
  core
  ```

  

- 测试建议设置

  ```bash
  $ echo core.%e.%p>/proc/sys/kernel/core_pattern
  
  $ cat /proc/sys/kernel/core_pattern
  core.%e.%p
  ```

- 生产环境建议设置固定目录，务必要**手动创建coredump目录**

  ```bash
  $ echo /tmp/cores/core.%e.%p>/proc/sys/kernel/core_pattern
  
  $ cat /proc/sys/kernel/core_pattern
  /tmp/cores/core.%e.%p
  ```

## demo测试

- 使用c语言的demo

  ```c
  vim main.c
    
  #include <stdio.h>
  
  int main()
  {
      int a = 1 / 0;
  }
  
  
  $ gcc main.c -o main
  $ ./main
  [1]    1942 floating point exception (core dumped)  ./main
    
  cd /tmp/cores
  $ ll
  total 104K
  -rw------- 1 root root 240K Dec 22 16:04 core.main.1942
  ```

- 测试成功

## 总结

简单的描述了centos的环境，如何实现coredump的生成，你也去体验一下吧。

后续会介绍一下 Go 语言如何产生和分析coredump文件。


