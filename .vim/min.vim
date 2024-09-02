"=============================================================================
"
"                 min_plugins.vim - intialize config
"
"       Created by shiqf on 2021年10月14日 星期四 20时33分05秒 CST
"
"=============================================================================
" 防止重复加载
if get(s:, 'loaded', 0) != 0
  finish
else
  let s:loaded = 1
endif

" 取得本文件所在的目录
let s:home = '~/.vim'

" 定义一个命令用来加载文件
command! -nargs=1 LoadScript exec $'so {s:home}/<args>'

"-----------------------------------------------------------------------------
"                              设置通用前缀空格键
"-----------------------------------------------------------------------------
set nocompatible
let mapleader = "\<Space>"

"-----------------------------------------------------------------------------
"                                   模块加载
"-----------------------------------------------------------------------------
" 加载基础配置
LoadScript init/basic.vim

" 加载扩展配置
LoadScript init/config.vim

" 界面样式
LoadScript init/style.vim

" 自定义按键
LoadScript init/keymaps.vim

" 设定 tabsize
LoadScript init/tabsize.vim

" 自定义功能按键映射
LoadScript init/function_keymaps.vim

" 插件配置
LoadScript init/plugins.vim

colorscheme habamax
