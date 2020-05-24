"======================================================================
"
" init-keymaps.vim - 按键设置，按你喜欢更改
"
"   - 快速移动
"   - 标签切换
"   - 窗口切换
"   - 终端支持
"   - 编译运行
"   - 符号搜索
"
" vim: set ts=4 sw=4 tw=78 noet :
"======================================================================


" 在普通和可视模式上重复上次替换
nnoremap <silent> & :~&<CR>
xnoremap <silent> & :~&<CR>
xnoremap <silent> . :normal ;.<CR>
xnoremap <silent> @ :normal @@<CR>

nnoremap 1p "1p
nnoremap 1P "1P
inoremap <m-y> <c-a>

nnoremap Q gq

onoremap ]z V]z
onoremap [z V[z

"----------------------------------------------------------------------
" INSERT 模式下使用 EMACS 键位
"----------------------------------------------------------------------
inoremap <c-f> <right>
inoremap <c-b> <left>
inoremap <c-a> <c-\><c-o>_
inoremap <c-e> <esc>g_a
inoremap <m-f> <c-right>
inoremap <m-b> <c-left>

" 类似终端下的 ctrl-y
inoremap <c-y> <c-a>

" 跳转到下一行末尾
inoremap <c-j> <c-o>m`<c-o>2$

" ctrl+k 删除到行末
inoremap <c-k> <c-\><c-o>"_d$

" 使用 <c-_> 代替 <c-k>
inoremap <c-_> <c-k>


"----------------------------------------------------------------------
" 命令模式下使用 Emacs 风格的编辑操作
"----------------------------------------------------------------------
cnoremap <c-f> <right>
cnoremap <c-b> <left>
cnoremap <c-a> <home>
cnoremap <c-e> <end>
cnoremap <m-f> <c-right>
cnoremap <m-b> <c-left>
cnoremap <m-d> <c-right><c-w>

cnoremap <c-p> <up>
cnoremap <c-n> <down>

" ALT 键移动增强
cnoremap <m-h> <c-left>
cnoremap <m-l> <c-right>

" ctrl+k 删除到行末
cnoremap <c-k> <c-\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<cr>

" 使用 <c-_> 代替 <c-k>
cnoremap <c-_> <c-k>

" 使用 ctrl-x ctrl-e 打开命令、查询等历史窗口, 类似终端
cnoremap <c-x><c-e> <c-f>

" 和在终端下的 ctrl-d 一样的效果
function! Cd()
    if strlen(getcmdline()) == 0
        return "\<esc>"
    elseif strlen(getcmdline()) != 0 && strlen(getcmdline()) > getcmdpos() - 1
        return "\<Del>"
    else
        return "\<c-d>"
    endif
endfunc
cnoremap <expr> <c-d> Cd()

"----------------------------------------------------------------------
" TAB：创建，关闭，上一个，下一个，首个，末个，左移，右移，
"----------------------------------------------------------------------

" 快速切换tab 使用标签 参考unimparied
nnoremap ]g gt
nnoremap [g gT
nnoremap [G :tabfirst<cr>
nnoremap ]G :tablast<cr>

" 左移 tab
function! Tab_MoveLeft()
    let l:tabnr = tabpagenr() - 2
    if l:tabnr >= 0
        exec 'tabmove '.l:tabnr
    endif
endfunc

" 右移 tab
function! Tab_MoveRight()
    let l:tabnr = tabpagenr() + 1
    if l:tabnr <= tabpagenr('$')
        exec 'tabmove '.l:tabnr
    endif
endfunc

noremap <silent> <c-w>tn :tabnew<cr>
noremap <silent> <c-w>tq :tabclose<cr>
noremap <silent> <c-w>to :tabonly<cr>
noremap <silent> <c-w>tt :tab terminal<cr>
noremap <silent> <c-w>th :call Tab_MoveLeft()<cr>
noremap <silent> <c-w>tl :call Tab_MoveRight()<cr>
noremap <c-w>td :tabdo 


"----------------------------------------------------------------------
" 窗口切换：ALT+hjkl
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留
"----------------------------------------------------------------------
noremap <m-h> <c-w>h
noremap <m-l> <c-w>l
noremap <m-j> <c-w>j
noremap <m-k> <c-w>k
inoremap <m-h> <esc><c-w>h
inoremap <m-l> <esc><c-w>l
inoremap <m-j> <esc><c-w>j
inoremap <m-k> <esc><c-w>k

if has('terminal') && exists(':terminal') == 2 && has('patch-8.1.1')
    " vim 8.1 支持 termwinkey ，不需要把 terminal 切换成 normal 模式
    " 设置 termwinkey 为 CTRL 加减号（GVIM），有些终端下是 CTRL+?
    " 后面四个键位是搭配 termwinkey 的，如果 termwinkey 更改，也要改
    set termwinkey=<c-_>
    tnoremap <m-h> <c-_>h
    tnoremap <m-l> <c-_>l
    tnoremap <m-j> <c-_>j
    tnoremap <m-k> <c-_>k

    tnoremap <m-f> <c-right>
    tnoremap <m-b> <c-left>
    tnoremap <m-d> <esc>d
    tnoremap <m-u> <esc>u
    tnoremap <m-c> <esc>c

    " 终端模式切换普通终端模式
    tnoremap <m-q> <c-\><c-n>
    tnoremap <m-p> <c-_>"0

    " tab 切换
    tnoremap ]g <c-_>gt
    tnoremap [g <c-_>gT
    tnoremap ]G <c-_>:tablast<cr>
    tnoremap [G <c-_>:tabfirst<cr>

    " tnoremap <Esc> <c-_>N
    set notimeout ttimeout timeoutlen=100

    if has('win32') || has('win64')
        tnoremap <c-u> <esc>
        tnoremap <c-d> exit<cr>
        tnoremap <c-l> cls<cr>
        tnoremap <c-p> <up>
        tnoremap <c-n> <down>
        tnoremap <c-a> <home>
        tnoremap <c-e> <end>
    endif

elseif has('nvim')
    " neovim 没有 termwinkey 支持，必须把 terminal 切换回 normal 模式
    tnoremap <m-h> <c-\><c-n><c-w>h
    tnoremap <m-l> <c-\><c-n><c-w>l
    tnoremap <m-j> <c-\><c-n><c-w>j
    tnoremap <m-k> <c-\><c-n><c-w>k
    tnoremap <m-q> <c-\><c-n>
    tnoremap <m-p> <c-\><c-n>"0pa
endif
