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

inoremap <c-a> <Cmd>normal! _<CR>
inoremap <m-d> <Cmd>normal! de<CR>

# 类似终端下的 ctrl-y
inoremap <c-y> <c-a>

if !exists('g:no_plugin')
  inoremap <c-w> <c-g>u<c-w>
  inoremap <c-u> <c-g>u<c-u>
endif

# 使用 <m-;> 代替 <c-k>
noremap! <m-;> <c-k>

noremap! <m-h> <Left>
noremap! <m-l> <Right>
noremap! <m-k> <Up>
noremap! <m-j> <Down>
noremap! <m-p> <C-R>0

# 下/上行至末尾
nnoremap <silent> <c-j> <Cmd>exec $'normal! {v:count1 + 1}g_'<CR>
nnoremap <silent> <c-k> <Cmd>exec $'normal! {v:count1}kg_'<CR>

def AddToJumpList(): string
  var col = strwidth(getline('.'))
  var curCol = getcurpos()[-1]
  return curCol < col + 1 ? "\<c-\>\<c-o>m`" : ''
enddef

inoremap <expr> <c-j> $"{<SID>AddToJumpList()}\<Esc>jA"
inoremap <expr> <c-k> col('$') == getpos('.')[-2] ? $"{<SID>AddToJumpList()}\<Esc>kA" : "<c-\><c-o>\"_d$"

inoremap <c-s> <c-e>
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
  var tabnr = max([tabpagenr() - v:count1 - 1, 0])
  exec $'tabmove {tabnr}'
enddef

# 右移 tab
def TabMoveRight(): void
  var tabnr = min([tabpagenr() + v:count1, tabpagenr('$')])
  exec $'tabmove {tabnr}'
enddef

def TabLeft(): number
  var currentTab = tabpagenr()
  if currentTab == 1 && v:count1 == 1
    return tabpagenr('$')
  endif
  return max([currentTab - v:count1, 1])
enddef

def TabRight(): number
  var currentTab = tabpagenr()
  var maxTab = tabpagenr('$')
  if v:count1 == 1 && currentTab == maxTab
    return 1
  endif
  return min([currentTab + v:count1, maxTab])
enddef

# 快速切换tab 使用标签 参考unimparied
nnoremap <silent> <m-;><m-h> <Cmd>call <SID>TabMoveLeft()<CR>
nnoremap <silent> <m-;><m-l> <Cmd>call <SID>TabMoveRight()<CR>
nnoremap <silent> <m-;>h <Cmd>exec $"tabn {<SID>TabLeft()}"<CR>
nnoremap <silent> <m-;>l <Cmd>exec $"tabn {<SID>TabRight()}"<CR>
nnoremap <silent> <m-;>H <Cmd>tabfirst<CR>
nnoremap <silent> <m-;>L <Cmd>tablast<CR>
nnoremap <silent> <m-o>  <Cmd>normal! g<tab><CR>

# g<tab> 回到上个 tab
nnoremap <m-;>d   :<C-U>tabdo 
nnoremap <silent> <m-;>q <Cmd>tabclose<CR>
nnoremap <silent> <m-;>c <Cmd>tabclose<CR>
nnoremap <silent> <m-;>o <Cmd>tabonly<CR>

# windows 上使用 powershell 来作为默认终端
if executable('powershell')
  # powershell 中使用 emacs 键位
  # Set-PSReadLineOption -EditMode Emacs
  nnoremap <silent> <m-;>t <Cmd>tab terminal powershell<CR>
  nnoremap <silent> <m-;>s <Cmd>terminal powershell<CR>
  nnoremap <silent> <m-;>v <Cmd>vertical terminal powershell<CR>
else
  nnoremap <silent> <m-;>t <Cmd>tab terminal<CR>
  nnoremap <silent> <m-;>s <Cmd>terminal<CR>
  nnoremap <silent> <m-;>v <Cmd>vertical terminal<CR>
endif

#-----------------------------------------------------------------------------
#                              窗口切换：ALT+hjkl
#-----------------------------------------------------------------------------
if !exists('$TMUX') || exists('g:no_plugin')
  # 传统的 CTRL-W+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL-W+hjkl 在
  # bash/zsh 及带文本界面的程序中都是重要键位需要保留
  nnoremap <silent> <m-h> <Cmd>wincmd h<CR>
  nnoremap <silent> <m-l> <Cmd>wincmd l<CR>
  nnoremap <silent> <m-j> <Cmd>wincmd j<CR>
  nnoremap <silent> <m-k> <Cmd>wincmd k<CR>
  nnoremap <silent> <m-\> <Cmd>wincmd p<CR>

  tnoremap <silent> <m-h> <Cmd>wincmd h<CR>
  tnoremap <silent> <m-l> <Cmd>wincmd l<CR>
  tnoremap <silent> <m-j> <Cmd>wincmd j<CR>
  tnoremap <silent> <m-k> <Cmd>wincmd k<CR>
  tnoremap <silent> <m-\> <Cmd>wincmd p<CR>
endif

if has('terminal') && exists(':terminal') == 2
  # vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
  # 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
  # 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
  set termwinkey=<c-_>
  tnoremap <silent> <m-f> <Esc>f
  tnoremap <silent> <m-b> <Esc>b
  tnoremap <silent> <m-d> <Esc>d

  tmap <m-;> <c-_>
  # 终端模式切换普通终端模式
  tnoremap <silent> <m-q> <c-\><c-n>
  tnoremap <silent> <m-p> <c-_>"0

  # tab 切换
  tnoremap <c-_><m-h> <Cmd>call <SID>TabMoveLeft()<Bar>redraw!<CR>
  tnoremap <c-_><m-l> <Cmd>call <SID>TabMoveRight()<Bar>redraw!<CR>
  tnoremap <c-_>h <Cmd>normal! gT<CR>
  tnoremap <c-_>l <Cmd>normal! gt<CR>
  tnoremap <c-_>H <Cmd>tabfirst<CR>
  tnoremap <c-_>L <Cmd>tablast<CR>
  tnoremap <m-o>  <Cmd>normal! g<tab><CR>

  tnoremap <silent> <c-_>t <Cmd>tab terminal<CR>
  tnoremap <silent> <c-_>s <Cmd>terminal<CR>
  tnoremap <silent> <c-_>v <Cmd>vertical terminal<CR>
  # tnoremap <Esc> <c-_>N
  set notimeout ttimeout timeoutlen=100

  tnoremap <m-:> <c-_>:
endif

#-----------------------------------------------------------------------------
#                             各个模式中的映射增强
#-----------------------------------------------------------------------------
# 排版
nnoremap Q gq

# # 保存
# nnoremap <silent> <c-s> <Cmd>w<CR>

# 强制退出
noremap <silent> <Leader>Q <Cmd>qall!<CR>
noremap <silent> <Leader>S <Cmd>wall<Bar>qall<CR>

# 错误导航
nnoremap <silent> [l <Cmd>exec $'{v:count1}labove'<CR>
nnoremap <silent> ]l <Cmd>exec $'{v:count1}lbelow'<CR>

# 可以使用 "1p 后用 u. 方式可以获取先前删除文本的内容。详情：redo-register
nnoremap 1p "1p
nnoremap 1P "1P

inoremap <c-l> <c-x><c-l>
inoremap <c-o><c-j> <Esc>gi

# 跳转到下一行末尾, 通过<c-o><c-o> 回到跳转点.
inoremap <m-o> <c-o><c-o>
inoremap <m-i> <c-o><c-i>

def PathOption(): void
  setl path&
  setl path-=/usr/include
  if &ft ==# 'c' || &ft ==# 'cpp'
    if has('macunix')
      setl path+=/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include/**2
    elseif has('unix')
      setl path+=/usr/include/**2
    endif
    setl path+=**5
  endif
  try
    normal! gf
  catch /.*/
    echo v:exception
  endtry
  set path<
enddef
nnoremap gf <Cmd>call <SID>PathOption()<CR>

# # 恢复非高亮
# noremap <silent> <c-l> <Cmd>nohlsearch<Bar>redraw!<CR>

nnoremap y<c-e> y$
