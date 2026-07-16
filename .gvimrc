" 不兼容vi模式
set nocompatible

" macvim 支持 alt 键作为 meta
if has('mac')
  set macmeta
endif

" 取消 gui 游标闪烁
highlight Cursor guifg=darkcyan guibg=blueviolet
highlight iCursor guifg=white guibg=red
set guicursor=n-v-c:block-Cursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:block-ver20-blinkon0-iCursor


" 设置 gui vim 窗口大小
set columns=90 lines=27

" 不显示菜单栏支持黑色栏
set guioptions=d

" Windows 禁用 ALT 操作菜单（可以在 Vim 里使用 ALT 的映射功能）
" 不显示菜单栏时可以不用设置该项
" set winaltkeys=no

" 设置字体及大小
if has('mac')
  set guifont=Monaco:h12
elseif has('win32') || has('win64')
  set guifont=Consolas:h12
endif
