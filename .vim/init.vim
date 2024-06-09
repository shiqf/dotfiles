"=============================================================================
"
"  init.vim - intialize config
"
"  Created by shiqf on 2019-06-29 23:00
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
command! -nargs=1 LoadScript exec 'so '. s:home . '/' . '<args>'

"-----------------------------------------------------------------------------
"                              设置通用前缀空格键
"-----------------------------------------------------------------------------
let mapleader="\<Space>"
let g:max = 1

"-----------------------------------------------------------------------------
"                                   模块加载
"-----------------------------------------------------------------------------

" 插件加载
LoadScript init/plugins.vim

" 加载基础配置
LoadScript init/basic.vim

" 界面样式
LoadScript init/style.vim

" 加载扩展配置
LoadScript init/config.vim

" 自定义按键
LoadScript init/keymaps.vim

" 自定义主题
LoadScript init/colors.vim

" 设定 tabsize
LoadScript init/tabsize.vim

" 自定义功能按键映射
LoadScript init/function_keymaps.vim
