---
weight: 1
title: "【ideavim】GoLand的vim环境插件配置"
date: 2021-04-03T07:55:32+08:00
lastmod: 2021-04-03T07:55:32+08:00
draft: false
author: "coolliuzw"
# authorLink: "https://coolliuzw.gitee.io"
description: "个人的ideavim配置及相关说明."
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
`Goland`的`vim`插件也集成了各种各种各样的功能使用。基本上可以满足个人的使用需求，避免使用`vim`学习成本太高的问题，现在很多编译器自己的功能集成，核心自定义的功能确实会比`vim`的好用。但是又舍弃不了`vim`操作上的便捷性，所以有了这边`ideavim`配置的说明，也是对自己`ideavim`配置的一个记录

## 2 配置
### 2.1 配置记录
先直接来一份个人配置.
```bash
" 设置 <LEADER> as <SPACE>
let mapleader=" "

" 去除VI一致性,必须要添加
" 不要使用vi的键盘模式，而是vim自己的
set nocompatible

" 打开行号和相关行号的配置
set relativenumber
set number


" 快速上下左右跳转
noremap H 5k
noremap L 5j
noremap W 5w
noremap B 5b

" K 区域选着，window环境个人还是屏蔽所有ctrl的vim按键
noremap K <C-v>

" kj 设置为esc
inoremap kj <ESC>

" 设置搜索相关
set hlsearch
exec "nohlsearch"
set incsearch
set ignorecase
set smartcase
" 搜索跳转
noremap = nzz
noremap - Nzz
noremap n nzz
noremap N Nzz
noremap <LEADER><CR> :nohlsearch<CR>

" go config
" 到go的方法名
noremap gm <S-i><ESC>f)2l
" 到go的函数名
noremap gf <S-i><ESC>5l
" 查找括号
noremap f9 f(
" 查找括号
noremap f0 f)

" 拷贝到系统的剪切板
noremap <S-y> \"+y

" ===
" === easymotion
" ===
" easyMotion 模拟，额外依赖插件：AceJump,IdeaVim-EasyMotion
set easymotion

let g:EasyMotion_do_mapping = 0 " Disable default mappings

" `s{char}{char}{label}`
" Need one more keystroke, but on average, it may be more comfortable.
nmap <Leader>s <Plug>(easymotion-s2)

" Turn on case-insensitive feature
let g:EasyMotion_smartcase = 1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)



""" Map leader to space ---------------------
" let mapleader=" "

""" Plugins  --------------------------------
" set surround
" set multiple-cursors
" set commentary
" set argtextobj
" set easymotion
" set textobj-entire
" set ReplaceWithRegister

""" Plugin settings -------------------------
" let g:argtextobj_pairs="[:],(:),<:>"

""" Common settings -------------------------
set showmode
" 行数留余
set so=3
" set incsearch
" set nu

""" Idea specific settings ------------------
" set ideajoin
" set ideastatusicon=gray
" set idearefactormode=keep

""" Mappings --------------------------------
" map <leader>f <Plug>(easymotion-s)
" map <leader>e <Plug>(easymotion-f)

map <leader>d <Action>(Debug)
map <leader>r <Action>(Run)
" map <leader>r <Action>(RenameElement)
map <leader>c <Action>(Stop)
map <leader>z <Action>(ToggleDistractionFreeMode)
map <leader>p <Action>(TogglePresentationMode)

map <leader>f <Action>(SelectInProjectView)
" map <leader>a <Action>(Annotate)
" map <leader>h <Action>(Vcs.ShowTabbedFileHistory)
" map <S-Space> <Action>(GotoNextError)

map <leader>b <Action>(ToggleLineBreakpoint)
map <leader>o <Action>(FileStructurePopup)


" ===
" === IdeaVimExtension
" ===
" 为IdeaVim插件增加自动切换为英文输入法的功能,
" idea 需要安装 IdeaVimExtension plugin
set keep-english-in-normal
" set keep-english-in-normal-and-restore-in-insert 回到insert模式时恢复输入法
" set nokeep-english-in-normal-and-restore-in-insert 保留输入法自动切换功能，但是回到insert模式不恢复输入法
" set nokeep-english-in-normal 关闭输入法自动切换功能
```

### 2.2 配置说明
- 参考2.1中的注释。

## 3 总结
`vim`需要一定的学习成本，但是学习好的话，可以大大的提高效率。

- `磨刀不误砍柴工`
- `工欲善其事必先利其器`

<!--参考文献:https://github.com/JetBrains/ideavim-->
