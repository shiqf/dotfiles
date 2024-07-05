vim9script
#=============================================================================
#
#  no_plugins.vim - intialize config
#
#  Created by shiqf on 2019-06-29 23:00
#
#=============================================================================

# 取得本文件所在的目录
var home = '~/.vim'

# 定义一个命令用来加载文件
command! -nargs=1 LoadScript exec 'so ' .. home .. '/' .. '<args>'

#-----------------------------------------------------------------------------
#                              设置通用前缀空格键
#-----------------------------------------------------------------------------
g:mapleader = "\<Space>"
set nocompatible
g:no_plugin = 1

#-----------------------------------------------------------------------------
#                                   模块加载
#-----------------------------------------------------------------------------

# 加载基础配置
LoadScript init/basic.vim

# 界面样式
LoadScript init/style.vim

# 加载扩展配置
LoadScript init/config.vim

# 自定义按键
LoadScript init/keymaps.vim

# 设定 tabsize
LoadScript init/tabsize.vim

# 自定义功能按键映射
LoadScript init/function_keymaps.vim
