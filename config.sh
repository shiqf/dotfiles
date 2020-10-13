#!/usr/bin/env bash

# 配置文件、命令行工具、有界面工具、vim依赖工具、python工具所需的工具变量
# 方便迁移工作环境，和选择安装所需要的工具。

##############################################################################
#                   数组保存需要删除的软链接文件名                           #
##############################################################################

dotfiles=(
    .eslintrc.js       # eslint（关于javascript 语法规则错误提示）配置文件
    .gtags.conf        # ctags 生成方式
    .gvimrc            # gui 版本 vim 编辑器配置文件
    .tmux              # tmux 插件安装目录
    .tmux/.tmux.conf   # tmux 终端窗口复用器配置文件
    .vim               # vim 插件目录
    .vimrc             # vim 编辑器配置文件
    .ycm_extra_conf.py # c 语言语义补全配置文件
    .zshrc             # zsh 的配置文件
)

##############################################################################
#                               终端命令                                     #
##############################################################################

cmds=(
    # "--HEAD universal-ctags/universal-ctags/universal-ctags" # 最新标签生成命令
    cmake                      # 跨平台编译工具
    fzf                        # 模糊查询
    git                        # 版本控制安装
    global                     # GNU GLOBAL 是一个源代码标记系统
    proxychains-ng             # 终端代理命令
    python                     # 默认 python3
    ranger                     # 终端文件管理软件
    reattach-to-user-namespace # 用户命名空间，防止因为 shell 的用户空间非当前用户
    the_silver_searcher        # 命令缩写 ag 类似于 grep 命令
    tmux                       # 终端复用窗口拓展
    vim                        # 最新 vim 安装
    z                          # 支持快速跳转到曾经打开过的目录下
    zsh                        # 最新 zsh 安装
)

##############################################################################
#                                 Gui工具                                    #
##############################################################################

# 系统工具
guis=(
    cheatsheet         # 长按 command ，将能查看当前程序的快捷键
    devdocs            # 文档
    google-chrome      # 谷歌浏览器
    iina               # 播放器
    iterm2             # iterm2 终端安装
    karabiner-elements # 键位设置软件
    keka               # 压缩 开源免费, 压缩比高, 操作便捷, 支持rar等解压, 压缩中文目录后, 在windows下打开不会存在乱码等现象.
    keycastr           # 按键显示，方便录制
    qlcolorcode        # 预览语法高亮
    qlmarkdown         # 预览markdown 渲染
    qlstephen          # 预览未知扩展名的文本 添加行号defaults write org.n8gray.QLColorCode extraHLFlags '-l'
    typora             # markdown 编辑器
    webpquicklook      # 网页快速预览

# 工作工具
# dash         # 文档
# neteasemusic # 网易云音乐
# omnigraffle  # 画图工具
# postico      # postgres 数据库
# postman      # 接口调用工具
# robo-3t      # monogo 数据库
# screenflow   # 视频录制
# sequel-pro   # mysql 数据库连接工具
# sketch       # 切图软件
# thunder      # 迅雷下载
# youdaonote   # 有道笔记
)

##############################################################################
#                               python 工具包                                #
##############################################################################

pips=(
    pygments # 支持其它语言 除[C/C++/Yacc/Java/PHP4/assembly] 之外javascript/typescript等
    cppman   # 高亮 cpp 文档
    ranger   # 终端文件管理软件
)

##############################################################################
#                                node 工具包                                 #
##############################################################################

npms=(
    eslint     # javascript 语法检测
    ts-node    # typescript 运行环境
    typescript # typescript 编译器
)
