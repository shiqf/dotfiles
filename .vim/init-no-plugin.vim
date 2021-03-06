"=============================================================================
"
"  no_plugins.vim - intialize config
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
command! -nargs=1 LoadScript exec 'so ' .. s:home .. '/' .. '<args>'

"-----------------------------------------------------------------------------
"                              设置通用前缀空格键
"-----------------------------------------------------------------------------
let mapleader="\<Space>"

"-----------------------------------------------------------------------------
"                                   模块加载
"-----------------------------------------------------------------------------

" 加载基础配置
LoadScript init/init-basic.vim

" 界面样式
LoadScript init/init-style.vim

" 加载扩展配置
LoadScript init/init-config.vim

" 自定义按键
LoadScript init/init-keymaps.vim

" 设定 tabsize
LoadScript init/init-tabsize.vim

" 加载错误修正
LoadScript init/init-abbr.vim

set relativenumber

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
" let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
