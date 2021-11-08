"=============================================================================
"
"                    keymaps.vim - 按键设置，按你喜欢更改
"
"   - 插入模式下使用 EMACS 键位
"   - 命令模式下使用 Emacs 风格的编辑操作
"   - 窗口切换：ALT+hjkl
"   - 命令模式下使用 Emacs 风格的编辑操作
"   - TAB：创建，关闭.
"   - 各个模式中的映射增强
"
" vim: set ts=4 sw=4 tw=78 noet :
"=============================================================================
inoremap <c-n> <c-x><c-n>
inoremap <c-p> <c-x><c-p>
inoremap <c-x><c-n> <c-n>
inoremap <c-x><c-p> <c-p>
inoremap <c-l> <c-x><c-l>

" 至上/下行末尾
nnoremap <silent> <c-k> :<c-u>execute 'normal! ' . v:count . 'kg_'<cr>
nnoremap <silent> <c-j> :<c-u>execute 'normal! ' . (v:count > 1 ? v:count + 1 : 2) . 'g_'<cr>

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

" 跳转到下一行末尾, 通过<c-o><c-o> 回到跳转点.
inoremap <c-j> <c-o>m`<c-o>2$

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

cnoremap <c-l> <c-right><right>

" 和在终端下的 ctrl-d 一样的效果
function! s:CtrlD()
  if strlen(getcmdline()) == 0
    return "\<esc>"
  elseif strlen(getcmdline()) > getcmdpos() - 1
    return "\<Del>"
  endif
  return "\<c-d>"
endfunc
cnoremap <expr> <c-d> <SID>CtrlD()


"-----------------------------------------------------------------------------
"          TAB：创建，关闭，上一个，下一个，首个，末个，左移，右移，
"-----------------------------------------------------------------------------
" 快速切换tab 使用标签 参考unimparied
nnoremap <silent> ]g gt
nnoremap <silent> [g gT
nnoremap <silent> [G :<c-u>tabfirst<cr>
nnoremap <silent> ]G :<c-u>tablast<cr>

nnoremap <silent> [l :<c-u>labove<cr>
nnoremap <silent> ]l :<c-u>lbelow<cr>

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

if !exists('g:lasttab')
  let g:lasttab = 1
endif

nnoremap <silent> <c-w><c-t> :<c-u>exe "tabn ".g:lasttab<CR>
autocmd TabLeave * let g:lasttab = tabpagenr()

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
noremap <silent> <c-w>th :<c-u>call Tab_MoveLeft()<cr>
noremap <silent> <c-w>tl :<c-u>call Tab_MoveRight()<cr>

noremap <c-w>td :<c-u>tabdo 


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

inoremap <m-h> <esc><c-w>h
inoremap <m-l> <esc><c-w>l
inoremap <m-j> <esc><c-w>j
inoremap <m-k> <esc><c-w>k

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

function! s:OriginPattern(arg)
  return a:arg =~ '\W' ? '\V' . substitute(escape(a:arg, '\/'), '\n', '\\n', 'g') : a:arg
endfunction

" 替换内容
function! s:Replace()
  let l:temp = '"'->getregtype() ==# 'v' ? '"'->getreg() : ''
  let @/ = l:temp !=# '' ? s:OriginPattern(l:temp) : ''
endfunction

function s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? tolower(a:reg[0:0]) . a:reg[1:-1] : a:reg
endfunction

" 用寄存器 "0, "- 作为替换项
function! s:Pattern()
  if mode() ==# 'v'
    let l:temp = @@
    normal! y
    let @/ = s:OriginPattern(@@)
    let @@ = l:temp
  else
    let l:mode = '"'->getregtype()
    let l:temp = '"'->getreg()
    if l:mode ==# 'v' && l:temp !=# ''
      let @/ = s:OriginPattern(l:temp)
    endif
  endif
endfunction

if v:version >= 802
  " 将修改 "." 命令与 ":s" 命令结合起来
  " 将修改再次重复运用于匹配的修改原文, 跳转到修改原文并改变通过 "." 命令, 使用前用 g.
  nnoremap <silent>g. <cmd>call <SID>Replace() \| set hls<cr>cgn<c-r>='.'->getreg()<cr><esc>
  " 用修改("0, "-)作为替换项, 修改内容作为替换内容
  xnoremap g. <cmd>call <SID>Pattern() \| set hls<cr>:s/<c-r>//<c-r>='.'->getreg()<cr>/g<left><left>
  xnoremap g, <cmd>call <SID>Pattern() \| set hls<cr>
        \:S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
else
  nnoremap <silent>g. :<c-u>call <SID>Replace() \| set hls<cr>cgn<c-r>='.'->getreg()<cr><esc>
  " 字符向可视模式功能缺失
  xnoremap g. :<c-u>call <SID>Pattern() \| set hls<cr>gv:s/<c-r>//<c-r>='.'->getreg()<cr>/g<left><left>
  xnoremap g, :<c-u>call <SID>Pattern() \| set hls<cr>gv
        \:S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
endif

nnoremap & :~&<cr>
xnoremap & :~&<cr>

" 可以使用 "1p 后用 u. 方式可以获取先前删除文本的内容。详情：redo-register
nnoremap 1p "1p
nnoremap 1P "1P

inoremap <c-o><c-m> <esc>gi

" 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <leader>ef :<c-u>edit %%<home>
xmap <leader>e y:<c-u>edit <c-r>='"'->getregtype() ==# 'v' ? '"'->getreg() : ''<cr><home>
nmap <leader>es :<c-u>split %%<home>
nmap <leader>ev :<c-u>vsplit %%<home>
nmap <leader>et :<c-u>tabedit %%<home>
nmap <leader>ew :<c-u>cd <c-r>=expand('%:h').'/'<cr><home>

nnoremap <silent><leader>ed :<c-u>edit <c-r>=expand('%:h')<cr><cr>
nnoremap <silent><leader>e. :<c-u>edit!<cr>

" 打开 fugitive 插件中的状态窗口
nnoremap <silent> g<cr> :<c-u>Git!<cr>
nnoremap g<space> :<c-u>! <home>Git

nnoremap <leader>gp :<c-u> --all<home>Git! log --oneline --decorate --graph
nnoremap <leader>gc :<c-u> -n<home>Git! clean -xdf

xnoremap <silent> ado :diffget<cr>
xnoremap <silent> 2do :diffget //2<cr>
xnoremap <silent> 3do :diffget //3<cr>
nnoremap <silent> 2do :diffget //2<cr>
nnoremap <silent> 3do :diffget //3<cr>

xnoremap <silent> adp :diffput<cr>
xnoremap <silent> 2dp :diffput //2<cr>
xnoremap <silent> 3dp :diffput //3<cr>
nnoremap <silent> 2dp :diffput //2<cr>
nnoremap <silent> 3dp :diffput //3<cr>


"-----------------------------------------------------------------------------
"                                 文件类型映射
"-----------------------------------------------------------------------------
augroup InitFileTypesMapGroup
  " 清除同组的历史 autocommand
  autocmd!

  autocmd FileType vim nnoremap <silent> <leader>s :w \| source %<cr>

augroup END
