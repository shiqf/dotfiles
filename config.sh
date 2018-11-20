#!/usr/bin/env bash

# 配置文件、命令行工具、有界面工具、vim依赖工具、python工具所需的工具变量
# 方便迁移工作环境，和选择安装所需要的工具。

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
cmds=(
autojump                   # 支持快速跳转到曾经打开过的目录下
git                        # 版本控制安装
proxychains-ng             # 终端代理命令
reattach-to-user-namespace # 用户命名空间，防止因为 shell 的用户空间非当前用户
the_silver_searcher        # 命令缩写 ag 类似于 grep 命令
tmux                       # 终端复用窗口拓展
zsh                        # 最新 zsh 安装
)

# 界面软件下载
guis=(
# neteasemusic       # 网易云音乐
# omnigraffle        # 画图工具
# postman            # 接口调用工具
# screenflow         # 视频录制
# sequel-pro         # mysql 数据库连接工具
# sketch             # 切图软件
# thunder            # 迅雷下载
cheatsheet         # 长按 command ，将能查看当前程序的快捷键
google-chrome      # 谷歌浏览器
iina               # 播放器
iterm2             # iterm2 终端安装
karabiner-elements # 键位设置软件
keka               # 压缩 开源免费, 压缩比高, 操作便捷, 支持rar等解压, 压缩中文目录后, 在windows下打开不会存在乱码等现象.
keycastr           # 按键显示，方便录制
macvim             # mac vim GUI客户端
qlcolorcode        # 预览代码渲染
qlmarkdown         # 预览markdown 渲染
qlstephen          # 预览渲染
the-unarchiver     # 解压缩应用
typora             # markdown 编辑器
webpquicklook      # 网页快速预览
)

# 为 vim 插件提供支持和YouCompleteMe 安装依赖关系
vims=(
"--HEAD universal-ctags/universal-ctags/universal-ctags" # 最新标签生成命令
cmake # YouCompleteMe 安装依赖
python # YouCompleteMe 安装依赖
vim # 最新 vim 安装
)

# 用 pip 方式安装所需命令
pythons=(
cppman
glances
icdiff
)

# node 安装包
npms=(
coffee-script
less
grunt-cli
gulp
eslint
)

# Npm 使用
# 安装包:

# $ npm install <package>     # 安装在本地项目中
# $ npm install -g <package>  # 安装在全局
# 安装包，并且将其保存你项目中的 package.json 文件:
# $ npm install <package> --save
# 查看 npm 安装的内容:
# $ npm list     # 本地
# $ npm list -g  # 全局
# 查看过期的包（本地或全局）:
# $ npm outdated [-g]
# 更新全部或特别指定一个包:
# $ npm update [<package>]
# 卸载包:

# $ npm uninstall <package>
