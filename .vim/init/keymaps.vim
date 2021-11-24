"=============================================================================
"
"                    keymaps.vim - 按键设置，按你喜欢更改
"
"   - 插入模式下使用 EMACS 键位
"   - 命令模式下使用 Emacs 风格的编辑操作
"   - 窗口切换：ALT+hjkl
"   - 命令模式下使用 Emacs 风格的编辑操作
"   - tab：创建，关闭，上一个，下一个，首个，末个，左移，右移
"   - 各个模式中的映射增强
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================

"-----------------------------------------------------------------------------
"                          插入模式下使用 EMACS 键位
"-----------------------------------------------------------------------------
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <c-a> <c-\><c-o>_
inoremap <c-e> <end>
inoremap <m-f> <c-right>
inoremap <m-b> <c-left>
inoremap <m-d> <esc>g`^cw

" 类似终端下的 ctrl-y
inoremap <c-y> <c-a>

" ctrl+k 删除到行末
inoremap <c-k> <c-\><c-o>"_d$
inoremap <c-w> <c-g>u<c-w>
inoremap <c-u> <c-g>u<c-u>

" 使用 <c-_> 代替 <c-k>
inoremap <c-_> <c-k>


"-----------------------------------------------------------------------------
"                     命令模式下使用 Emacs 风格的编辑操作
"-----------------------------------------------------------------------------
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <m-f> <c-right>
cnoremap <m-b> <c-left>
cnoremap <m-d> <c-f>de<c-c>

cnoremap <c-p> <up>
cnoremap <c-n> <down>

" ALT 键移动增强
cnoremap <m-h> <c-left>
cnoremap <m-l> <c-right>
cnoremap <m-k> <c-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<cr>

" ctrl+k 删除到行末
cnoremap <c-k> <c-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<cr>
" 使用 <c-_> 代替 <c-k>
cnoremap <c-_> <c-k>

" 打开命令窗口、查询历史窗口
cnoremap <c-j> <c-f>
cnoremap <expr> <c-d> strlen(getcmdline()) == 0 ? "\<esc>" : strlen(getcmdline()) > getcmdpos() - 1 ? "\<Del>" : "\<c-d>"

" 至上/下行末尾
nnoremap <silent> <c-k> :<c-u>execute 'normal! ' . v:count . 'kg_'<cr>
nnoremap <silent> <c-j> :<c-u>execute 'normal! ' . (v:count > 1 ? v:count + 1 : 2) . 'g_'<cr>

function! s:AddToJumpList()
  let l:col = strwidth(getline('.'))
  let l:curCol = getcurpos()[-1]
  return l:curCol < l:col + 1 ? "\<c-\>\<c-o>m`" : ''
endfunction

" 跳转到下一行末尾, 通过<c-o><c-o> 回到跳转点.
inoremap <expr> <c-j> <SID>AddToJumpList() . "\<esc>jA"
inoremap <expr> <m-j> <SID>AddToJumpList() . "\<esc>jA"
inoremap <expr> <m-k> <SID>AddToJumpList() . "\<esc>kA"
inoremap <m-h> <c-left>
inoremap <m-l> <c-right>


"-----------------------------------------------------------------------------
"          tab：创建，关闭，上一个，下一个，首个，末个，左移，右移，
"-----------------------------------------------------------------------------
" 左移 tab
function! Tab_MoveLeft()
  let l:tabnr = tabpagenr() - 2
  if l:tabnr >= 0
    exec 'tabmove ' . l:tabnr
  endif
endfunc

" 右移 tab
function! Tab_MoveRight()
  let l:tabnr = tabpagenr() + 1
  if l:tabnr <= tabpagenr('$')
    exec 'tabmove ' . l:tabnr
  endif
endfunc

function! Tab_Left()
  let l:count = v:count != 0 ? v:count : 1
  let l:currentTab = tabpagenr()
  return l:currentTab - l:count < 1 ? 1 : l:currentTab - l:count
endfunction

function! Tab_Right()
  let l:count = v:count != 0 ? v:count : 1
  let l:currentTab = tabpagenr()
  let l:maxTab = tabpagenr('$')
  return l:currentTab + l:count > l:maxTab ? l:maxTab : l:currentTab + l:count
endfunction

" 快速切换tab 使用标签 参考unimparied
nnoremap <silent> ]g :<c-u>exec "tabn ".Tab_Right()<cr>
nnoremap <silent> [g :<c-u>exec "tabn ".Tab_Left()<cr>
nnoremap <silent> [G :<c-u>tabfirst<cr>
nnoremap <silent> ]G :<c-u>tablast<cr>

noremap <silent> <c-w>th :<c-u>call Tab_MoveLeft()<cr>
noremap <silent> <c-w>tl :<c-u>call Tab_MoveRight()<cr>

" g<tab> 回到上个 tab
noremap <c-w>td :<c-u>tabdo 
noremap <silent> <c-w>tq :<c-u>tabclose<cr>
noremap <silent> <c-w>tc :<c-u>tabclose<cr>
noremap <silent> <c-w>to :<c-u>tabonly<cr>

" windows 上使用 powershell 来作为默认终端
if executable('powershell')
  " powershell 中使用 emacs 键位
  " Set-PSReadLineOption -EditMode Emacs
  noremap <silent> <c-w>tt :<c-u>tab terminal powershell<cr>
  noremap <silent> <c-w>ts :<c-u>terminal powershell<cr>
  noremap <silent> <c-w>tv :<c-u>vertical terminal powershell<cr>
else
  noremap <silent> <c-w>tt :<c-u>tab terminal<cr>
  noremap <silent> <c-w>ts :<c-u>terminal<cr>
  noremap <silent> <c-w>tv :<c-u>vertical terminal<cr>
endif


"-----------------------------------------------------------------------------
"                              窗口切换：ALT+hjkl
"-----------------------------------------------------------------------------
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留
if !exists('$TMUX')
  noremap <silent> <m-h> <c-w>h
  noremap <silent> <m-l> <c-w>l
  noremap <silent> <m-j> <c-w>j
  noremap <silent> <m-k> <c-w>k
endif


if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
  " vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
  " 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
  " 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
  set termwinkey=<c-_>
  tnoremap <silent> <m-h> <c-_>h
  tnoremap <silent> <m-l> <c-_>l
  tnoremap <silent> <m-j> <c-_>j
  tnoremap <silent> <m-k> <c-_>k

  tnoremap <silent> <m-f> <esc>f
  tnoremap <silent> <m-b> <esc>b
  tnoremap <silent> <m-d> <esc>d
  tnoremap <silent> <m-u> <esc>u
  tnoremap <silent> <m-c> <esc>c

  " 终端模式切换普通终端模式
  tnoremap <silent> <m-q> <c-\><c-n>
  tnoremap <silent> <m-p> <c-_>"0

  " tab 切换
  tnoremap ]g <c-_>gt
  tnoremap [g <c-_>gT
  tnoremap ]G <c-_>:<c-u>tablast<cr>
  tnoremap [G <c-_>:<c-u>tabfirst<cr>

  " tnoremap <Esc> <c-_>N
  set notimeout ttimeout timeoutlen=100

elseif has('nvim')
  " neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
  tnoremap <silent> <m-h> <c-\><c-n><c-w>h
  tnoremap <silent> <m-l> <c-\><c-n><c-w>l
  tnoremap <silent> <m-j> <c-\><c-n><c-w>j
  tnoremap <silent> <m-k> <c-\><c-n><c-w>k
  tnoremap <silent> <m-q> <c-\><c-n>
  tnoremap <silent> <m-p> <c-\><c-n>"0pa
endif


"-----------------------------------------------------------------------------
"                             各个模式中的映射增强
"-----------------------------------------------------------------------------
" 排版
nnoremap Q gq

" 保存
nnoremap <silent> <c-s> :w<cr>

" 强制退出
noremap <silent> <leader>Q :<c-u>qall!<cr>
noremap <silent> <leader>S :<c-u>wa \| qall<cr>

" 恢复非高亮
nnoremap <silent> <c-l> :nohlsearch<cr><c-l>

" 在可视模式上的重复宏的功能增强
xnoremap <silent> @ :normal @@<cr>

nnoremap <silent> &  :<c-u>exec '~& ' . (v:count == 0 ? 1 : v:count)<cr>
xnoremap <silent> &  :~&<cr>
nnoremap <silent> g& :%~&<cr>

" 错误导航
nnoremap <silent> [l :<c-u>labove<cr>
nnoremap <silent> ]l :<c-u>lbelow<cr>

" 可以使用 "1p 后用 u. 方式可以获取先前删除文本的内容。详情：redo-register
nnoremap 1p "1p
nnoremap 1P "1P

inoremap <c-l> <c-x><c-l>
inoremap <c-o><c-j> <esc>gi

nnoremap <LeftMouse> m'<LeftMouse>

noremap \ :
