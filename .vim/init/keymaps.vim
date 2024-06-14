vim9script
#=============================================================================
#
#                    keymaps.vim - 按键设置，按你喜欢更改
#
#   - 插入模式下使用 EMACS 键位
#   - 命令模式下使用 Emacs 风格的编辑操作
#   - 窗口切换：ALT+hjkl
#   - 命令模式下使用 Emacs 风格的编辑操作
#   - tab：创建，关闭，上一个，下一个，首个，末个，左移，右移
#   - 各个模式中的映射增强
#
# vim: set ts=2 sw=2 tw=78 et :
#=============================================================================


#-----------------------------------------------------------------------------
#                          插入模式 命令模式下使用 EMACS 键位
#-----------------------------------------------------------------------------
noremap! <c-f> <Right>
noremap! <c-b> <Left>
noremap! <c-e> <End>
noremap! <m-f> <C-Right>
noremap! <m-b> <C-Left>

inoremap <c-a> <c-\><c-o>_
inoremap <m-d> <Esc>g`^cw

# 类似终端下的 ctrl-y
inoremap <c-y> <c-a>

inoremap <c-w> <c-g>u<c-w>
inoremap <c-u> <c-g>u<c-u>

# 使用 <c-_> 代替 <c-k>
noremap! <c-_> <c-k>

noremap! <m-h> <Left>
noremap! <m-l> <Right>
noremap! <m-k> <Up>
noremap! <m-j> <Down>

# 跳转到下一行末尾, 通过<c-o><c-o> 回到跳转点.
inoremap <m-o> <c-o><c-o>
inoremap <m-i> <c-o><c-i>

def AddToJumpList(): string
  var col = strwidth(getline('.'))
  var curCol = getcurpos()[-1]
  return curCol < col + 1 ? "\<c-\>\<c-o>m`" : ''
enddef

inoremap <expr> <c-j> $"{<SID>AddToJumpList()}\<Esc>jA"
inoremap <expr> <c-k> col('$') == getpos('.')[-2] ? $"{<SID>AddToJumpList()}\<Esc>kA" : "<c-\><c-o>\"_d$"

#-----------------------------------------------------------------------------
#                     命令模式下使用 Emacs 风格的编辑操作
#-----------------------------------------------------------------------------
cnoremap <c-a> <Home>
cnoremap <m-d> <c-f>de<c-c>

cnoremap <c-p> <Up>
cnoremap <c-n> <Down>

# ctrl+k 删除到行末
cnoremap <c-k> <c-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>

# 打开命令窗口、查询历史窗口
cnoremap <c-j>  <c-f>
cnoremap <expr> <c-d> strlen(getcmdline()) == 0 ? "\<Esc>" : strlen(getcmdline()) > getcmdpos() - 1 ? "\<Del>" : "\<c-d>"

#-----------------------------------------------------------------------------
#          tab：创建，关闭，上一个，下一个，首个，末个，左移，右移，
#-----------------------------------------------------------------------------
# 左移 tab
def TabMoveLeft(): void
  var tabnr = tabpagenr() - 2
  if tabnr >= 0
    exec $'tabmove {tabnr}'
  endif
enddef

# 右移 tab
def TabMoveRight(): void
  var tabnr = tabpagenr() + 1
  if tabnr <= tabpagenr('$')
    exec $'tabmove {tabnr}'
  endif
enddef

def TabLeft(): number
  var currentTab = tabpagenr()
  if currentTab == 1 && v:count1 == 1
    return tabpagenr('$')
  endif
  return currentTab - v:count1 > 1 ? currentTab - v:count1 : 1
enddef

def TabRight(): number
  var currentTab = tabpagenr()
  var maxTab = tabpagenr('$')
  if v:count1 == 1 && currentTab == maxTab
    return 1
  endif
  return currentTab + v:count1 > maxTab ? maxTab : currentTab + v:count1
enddef

# 快速切换tab 使用标签 参考unimparied
nnoremap <silent> ]g <Cmd>exec $"tabn {<SID>TabRight()}"<CR>
nnoremap <silent> [g <Cmd>exec $"tabn {<SID>TabLeft()}"<CR>
nnoremap <silent> [G <Cmd>tabfirst<CR>
nnoremap <silent> ]G <Cmd>tablast<CR>

noremap <silent> <c-w>th <Cmd>call <SID>TabMoveLeft()<CR>
noremap <silent> <c-w>tl <Cmd>call <SID>TabMoveRight()<CR>

# g<tab> 回到上个 tab
noremap <c-w>td : <Home>tabdo
noremap <silent> <c-w>tq <Cmd>tabclose<CR>
noremap <silent> <c-w>tc <Cmd>tabclose<CR>
noremap <silent> <c-w>to <Cmd>tabonly<CR>

# windows 上使用 powershell 来作为默认终端
if executable('powershell')
  # powershell 中使用 emacs 键位
  # Set-PSReadLineOption -EditMode Emacs
  noremap <silent> <c-w>tt <Cmd>tab terminal powershell<CR>
  noremap <silent> <c-w>ts <Cmd>terminal powershell<CR>
  noremap <silent> <c-w>tv <Cmd>vertical terminal powershell<CR>
else
  noremap <silent> <c-w>tt <Cmd>tab terminal<CR>
  noremap <silent> <c-w>ts <Cmd>terminal<CR>
  noremap <silent> <c-w>tv <Cmd>vertical terminal<CR>
endif

#-----------------------------------------------------------------------------
#                              窗口切换：ALT+hjkl
#-----------------------------------------------------------------------------
# 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
# bash/zsh 及带文本界面的程序中都是重要键位需要保留
if !exists('$TMUX')
  noremap <silent> <m-h> <c-w>h
  noremap <silent> <m-l> <c-w>l
  noremap <silent> <m-j> <c-w>j
  noremap <silent> <m-k> <c-w>k
endif

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
  # vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
  # 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
  # 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
  set termwinkey=<c-_>
  tnoremap <silent> <m-h> <c-_>h
  tnoremap <silent> <m-l> <c-_>l
  tnoremap <silent> <m-j> <c-_>j
  tnoremap <silent> <m-k> <c-_>k

  tnoremap <silent> <m-f> <Esc>f
  tnoremap <silent> <m-b> <Esc>b
  tnoremap <silent> <m-d> <Esc>d

  # 终端模式切换普通终端模式
  tnoremap <silent> <m-q> <c-\><c-n>
  tnoremap <silent> <m-p> <c-_>"0

  # tab 切换
  tnoremap ]g <c-_>gt
  tnoremap [g <c-_>gT
  tnoremap ]G <Cmd>tablast<CR>
  tnoremap [G <Cmd>tabfirst<CR>

  # tnoremap <Esc> <c-_>N
  set notimeout ttimeout timeoutlen=100

elseif has('nvim')
  # neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
  tnoremap <silent> <m-h> <c-\><c-n><c-w>h
  tnoremap <silent> <m-l> <c-\><c-n><c-w>l
  tnoremap <silent> <m-j> <c-\><c-n><c-w>j
  tnoremap <silent> <m-k> <c-\><c-n><c-w>k
  tnoremap <silent> <m-q> <c-\><c-n>
  tnoremap <silent> <m-p> <c-\><c-n>"0pa
endif

#-----------------------------------------------------------------------------
#                             各个模式中的映射增强
#-----------------------------------------------------------------------------
# 排版
nnoremap Q gq

# 保存
nnoremap <silent> <c-s> :w<CR>

# 强制退出
noremap <silent> <Leader>Q <Cmd>qall!<CR>
noremap <silent> <Leader>S <Cmd>wa \| qall<CR>

# 恢复非高亮
nnoremap <silent> <c-l> <Cmd>nohlsearch<Bar>redraw!<CR>

# 至上/下行末尾
nnoremap <silent> <c-k> <Cmd>exec $'normal! {v:count1}kg_'<CR>
nnoremap <silent> <c-j> <Cmd>exec $'normal! {v:count1 + 1}g_'<CR>

# 错误导航
nnoremap <silent> [l <Cmd>labove<CR>
nnoremap <silent> ]l <Cmd>lbelow<CR>

# 可以使用 "1p 后用 u. 方式可以获取先前删除文本的内容。详情：redo-register
nnoremap 1p "1p
nnoremap 1P "1P

inoremap <c-l> <c-x><c-l>
inoremap <c-o><c-j> <Esc>gi

nnoremap <LeftMouse> m'<LeftMouse>

cnoremap <c-l> <C-Right><Right>

xnoremap <c-c> "+y
xnoremap <m-l> >gv
xnoremap <m-h> <gv
