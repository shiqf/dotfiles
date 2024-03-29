" 不兼容vi模式
set nocompatible

" macvim 支持 alt 键作为 meta
if has('mac')
  set macmeta
endif

" 取消 gui 游标闪烁
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=steelblue
set guicursor=n-v-c:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:block-ver15-blinkon0-iCursor

" 设置 gui vim 窗口大小
set columns=120 lines=36

" 不显示菜单栏
set guioptions=

" Windows 禁用 ALT 操作菜单（可以在 Vim 里使用 ALT 的映射功能）
" 不显示菜单栏时可以不用设置该项
" set winaltkeys=no

" 设置字体及大小
if has('mac')
  set guifont=Monaco:h12
elseif has('win32') || has('win64')
  set guifont=Consolas:h12
endif

" windows gvim 右键菜单乱码解决
if has('win32') || has('win64')
  source $VIMRUNTIME/delmenu.vim
  source $VIMRUNTIME/menu.vim
endif
