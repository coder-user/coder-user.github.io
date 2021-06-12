---
weight: 1
title: "【fzf】模糊查找神器-fzf"
date: 2021-05-17T21:44:32+08:00
lastmod: 2021-05-17T21:44:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "fzf配置及常用快捷键."
resources:
- name: "featured-image"
  src: "featured-image.jpg"

tags: ["开发工具"]
categories: ["开发工具"]

lightgallery: true

toc:
  auto: false
---

<!--more-->

## 1 简介
  日常开发目前还是主要使用windows为主，window上查询文件的神奇有`everything`就够了，但是linux上，有些时候需要经常的输入重复的命令，如果命名很长的话，重复输出极其的麻烦。  

  后面发现的`fzf`这个神奇，可以模糊查询命令历史记录，这个也是我用`fzf`使用最多场景的地方。fzf还可以和vim集成也是很好用，这篇文章主要介绍一下 fzf 的安装和配置相关的，以及相关快捷键。
## 2 Install
```bash
# fzf install
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

# ag install 
# centos7
yum -y install the_silver_searcher
# ubuntu
sudo apt-get install silversearcher-ag	
```

## 3 zsh-config

```bash
# vim ~/.zshrc
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(highlight -O ansi {} || cat {}) 2> /dev/null | head -500'"

# source ~/.zshrc
```

---

## 4 常用快捷键

- `CTRL-T` 查找目录下条目
- `CTRL-R` 查找历史命令
- 在输出交换窗口里
  - Ctrl-J/Ctrl-K/Ctrl-N/Ctrlk-N可以用来将光标上下移动
  - Enter键用来选中条目， Ctrl-C/Ctrl-G/Esc用来退出
  - 在多选模式下（-m), TAB和Shift-TAB用来多选
  - Mouse: 上下滚动， 选中， 双击； Shift-click或shift-scoll用于多选模式

## 5 搜索语法
- fzf默认会以“extened-search"模式启动， 这种模式下你可以输入多个以空格分隔的搜索关键词， 如`^music .mp3$`, `sbtrkt !fire`.

## 6 总结
- zsh + oh-my-zsh + fzf 快去优化你的linux环境吧, 如果有使用vim的也可以去研究一下怎么集成到vim中。

<!--参考文献:https://einverne.github.io/post/2019/08/fzf-usage.html-->
<!--参考文献:https://zhuanlan.zhihu.com/p/91873965-->