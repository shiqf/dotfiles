" 不兼容vi模式
set nocompatible

" macvim 支持 alt 键作为 meta
if has('mac')
  set macmeta
endif

" 取消游标闪烁
set gcr=a:block-blinkon0

" 设置 gui vim 窗口大小
set lines=30 columns=120

" 不显示菜单栏
set guioptions=

" 设置字体及大小
if has('mac')
  set guifont=Monaco:h14
elseif has('win32') || has('win64')
  set guifont=Consolas:h14
endif

" windows gvim 右键菜单乱码解决
if has('win32') || has('win64')
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif
