#!/usr/bin/env bash

# 数组保存需要删除的软链接文件名
dotfiles=(
.eslintrc.js       # eslint（关于javascript 语法规则错误提示）配置文件
.gvimrc            # gui 版本 vim 编辑器配置文件
.tern-project      # javascript 语义补全配置文件
.tmux              # tmux 插件安装目录
.tmux/.tmux.conf   # tmux 终端窗口复用器配置文件
.vim               # vim 插件目录
.vimrc             # vim 编辑器配置文件
.ycm_extra_conf.py # c 语言语义补全配置文件
.zshrc             # zsh 的配置文件
)

# 终端所需命令下载
commands=(
autojump                   # 支持快速跳转到曾经打开过的目录下
git                        # 版本控制安装
proxychains-ng             # 终端代理命令
reattach-to-user-namespace # 用户命名空间，防止因为 shell 的用户空间非当前用户
the_silver_searcher        # 命令缩写 ag 类似于 grep 命令
tmux                       # 终端复用窗口拓展
zsh                        # 最新 zsh 安装
)

# gui 软件下载
guis=(
the-unarchiver     # 解压缩应用
cheatsheet         # 长按 command ，将能查看当前程序的快捷键
# dingtalk           # 叮叮聊天工具
google-chrome      # 谷歌浏览器
iina               # 播放器
iterm2             # iterm2 终端安装
karabiner-elements # 键位设置软件
keka               # 压缩 开源免费, 压缩比高, 操作便捷, 支持rar等解压, 压缩中文目录后, 在windows下打开不会存在乱码等现象.
keycastr           # 按键显示，方便录制
macdown            # markdown 编辑器
macvim             # mac vim GUI客户端
# neteasemusic       # 网易云音乐
# omnigraffle        # 画图工具
# postman            # 接口调用工具
qlcolorcode        # 预览代码渲染
qlmarkdown         # 预览markdown 渲染
qlstephen          # 预览渲染
# robo-3t            # mongodb 数据库连接工具
# screenflow         # 视频录制
# sequel-pro         # mysql 数据库连接工具
# sketch             # 切图软件
# thunder            # 迅雷下载
webpquicklook
)

# 为 vim 插件提供支持和YouCompleteMe 安装依赖关系
vimDependCommands=(
"--HEAD universal-ctags/universal-ctags/universal-ctags" # 最新标签生成命令
cmake # YouCompleteMe 安装依赖
python # YouCompleteMe 安装依赖
vim # 最新 vim 安装
)

# 用 pip 方式安装所需命令
pythonCommands=(
cppman
glances
icdiff
)
