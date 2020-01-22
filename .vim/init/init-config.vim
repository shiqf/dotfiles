"======================================================================
"
" init-config.vim - 正常模式下的配置，在 init-basic.vim 后调用
"
"======================================================================
" vim: set ts=4 sw=4 tw=78 noet :

" 设置通用前缀空格键
let mapleader="\<Space>"

" Vim自动把默认剪贴板和系统剪贴板的内容同步
if has('clipboard')
    set clipboard^=unnamed,unnamedplus
elseif has('unix') && executable('xclip') && executable('xsel')
    vnoremap <silent><m-y> y:call
                \ system('echo -n ' . getreg('@0') . ' \| xclip -sel c')<cr>
endif

packadd! termdebug
packadd! matchit

" 设置鼠标功能
if has('mouse')
    set mouse=a
endif

"----------------------------------------------------------------------
" 终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
" 记得设置 ttimeout （见 init-basic.vim） 和 ttimeoutlen （上面）
"----------------------------------------------------------------------
function! Terminal_MetaMode(mode)
    set ttimeout
    if $TMUX !=# ''
        set ttimeoutlen=35
    elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
        set ttimeoutlen=85
    endif
    if has('nvim') || has('gui_running')
        return
    endif
    function! s:metacode(mode, key)
        if a:mode == 0
            exec 'set <M-'.a:key.">=\e".a:key
        else
            exec 'set <M-'.a:key.">=\e]{0}".a:key.'~'
        endif
    endfunc
    for i in range(10)
        call s:metacode(a:mode, nr2char(char2nr('0') + i))
    endfor
    for i in range(26)
        call s:metacode(a:mode, nr2char(char2nr('a') + i))
        call s:metacode(a:mode, nr2char(char2nr('A') + i))
    endfor
    if a:mode != 0
        for c in [',', '.', '/', ';', '[', ']', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_', '+', '=']
            call s:metacode(a:mode, c)
        endfor
    else
        for c in [',', '.', '/', ';', '{', '}']
            call s:metacode(a:mode, c)
        endfor
        for c in ['?', ':', '-', '_', '+', '=', "'"]
            call s:metacode(a:mode, c)
        endfor
    endif
endfunc


function! Terminal_KeyEscape(name, code)
    if has('nvim') || has('gui_running')
        return
    endif
    exec 'set '.a:name."=\e".a:code
endfunc


command! -nargs=0 -bang VimMetaInit call Terminal_MetaMode(<bang>0)
command! -nargs=+ VimKeyEscape call Terminal_KeyEscape(<f-args>)


function! Terminal_FnInit(mode)
    if has('nvim') || has('gui_running')
        return
    endif
    if a:mode == 1
        VimKeyEscape <F1> OP
        VimKeyEscape <F2> OQ
        VimKeyEscape <F3> OR
        VimKeyEscape <F4> OS
        VimKeyEscape <S-F1> [1;2P
        VimKeyEscape <S-F2> [1;2Q
        VimKeyEscape <S-F3> [1;2R
        VimKeyEscape <S-F4> [1;2S
        VimKeyEscape <S-F5> [15;2~
        VimKeyEscape <S-F6> [17;2~
        VimKeyEscape <S-F7> [18;2~
        VimKeyEscape <S-F8> [19;2~
        VimKeyEscape <S-F9> [20;2~
        VimKeyEscape <S-F10> [21;2~
        VimKeyEscape <S-F11> [23;2~
        VimKeyEscape <S-F12> [24;2~
    endif
endfunc


call Terminal_MetaMode(0)
call Terminal_FnInit(1)


"----------------------------------------------------------------------
" 防止tmux下vim的背景色显示异常
" Refer: http://sunaku.github.io/vim-256color-bce.html
"----------------------------------------------------------------------
if &term =~# '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
endif

if exists('$TMUX') && has('mac')
    " 普通模式是方块，插入模式是竖线
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=2\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_SR = "\<Esc>]50;CursorShape=2\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif


"----------------------------------------------------------------------
" 备份设置
"----------------------------------------------------------------------

" 无需备份
set nobackup

" 禁用交换文件
set noswapfile

" 禁用 undo文件
set noundofile

"----------------------------------------------------------------------
" 配置微调
"----------------------------------------------------------------------

" 修正 ScureCRT/XShell 以及某些终端乱码问题，主要原因是不支持一些
" 终端控制命令，比如 cursor shaping 这类更改光标形状的 xterm 终端命令
" 会令一些支持 xterm 不完全的终端解析错误，显示为错误的字符，比如 q 字符
" 如果你确认你的终端支持，不会在一些不兼容的终端上运行该配置，可以注释
if has('nvim')
    set guicursor=
elseif (!has('gui_running')) && has('terminal') && has('patch-8.0.1200')
    let g:termcap_guicursor = &guicursor
    let g:termcap_t_RS = &t_RS
    let g:termcap_t_SH = &t_SH
    set guicursor=
    set t_RS=
    set t_SH=
endif

" 定义一个 DiffOrig 命令用于查看文件改动
if !exists(':DiffOrig')
    command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif


"----------------------------------------------------------------------
" 文件类型微调
"----------------------------------------------------------------------

augroup InitFileTypesGroup

    " 清除同组的历史 autocommand
    au!

    " C/C++ 文件使用 // 作为注释
    au FileType json,typescript,c,cpp setlocal commentstring=//\ %s

    " markdown 允许自动换行
    au FileType markdown setlocal wrap

    " expandtab 使用 tab 自动转化成空格展开
    " lisp 进行微调
    au FileType lisp setlocal ts=8 sts=2 sw=2 et

    " scala 微调
    au FileType scala setlocal sts=4 sw=4 noet

    " haskell 进行微调
    au FileType haskell setlocal et

    " quickfix 隐藏行号
    au FileType qf setlocal nonumber

    " 强制对某些扩展名的 filetype 进行纠正
    au BufNewFile,BufRead *.as  setlocal filetype=actionscript
    au BufNewFile,BufRead *.pro setlocal filetype=prolog
    au BufNewFile,BufRead *.es  setlocal filetype=erlang
    au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
    au BufNewFile,BufRead *.vl  setlocal filetype=verilog

    " 打开文件时恢复上一次光标所在位置
    autocmd BufReadPost *
                \ if line("'\"") > 1 && line("'\"") <= line("$") |
                \    exe "normal! g`\"" |
                \ endif

augroup END

" 跳转到对应语言项目中
augroup FileJump
    autocmd!

    autocmd BufLeave *.c    normal! mC
    autocmd BufLeave *.html normal! mH
    autocmd BufLeave *.js   normal! mJ
    autocmd BufLeave *.ts   normal! mT
augroup END
