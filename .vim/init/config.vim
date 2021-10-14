"=============================================================================
"
"           config.vim - 正常模式下的配置，在 basic.vim 后调用
"
"   - 设置通用前缀空格键
"   - 功能插件开启
"   - 备份设置
"   - 防止tmux下vim的背景色显示异常
"   - 配置微调
"   - 文件类型微调
"
" vim: set ts=4 sw=4 tw=78 noet :
"=============================================================================

"-----------------------------------------------------------------------------
"                  Vim自动把默认剪贴板和系统剪贴板的内容同步
"-----------------------------------------------------------------------------
if has('clipboard')
  set clipboard^=unnamed
endif


"-----------------------------------------------------------------------------
"                                 功能插件开启
"-----------------------------------------------------------------------------
if has("patch-8.1.0311")
  packadd! cfilter
endif

" 调用man程序在vim内部查看命令
runtime ftplugin/man.vim

if (v:version >= 802)
  " 可视模式下的面向字符用 * 号匹配字符串
  function! s:vSetSearch(mode)
    if mode() ==# 'v'
      let temp = @@
      normal! y
      let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
      let @@ = temp
    else
      exec 'keepjumps normal! ' . a:mode . 'N'
      " TODO 为什么要这样才行?
      let temp = @/
      let @/ = temp
    endif
  endfunction

  xnoremap * <cmd>call <sid>vSetSearch('*')<cr>//<cr>
  xnoremap # <cmd>call <sid>vSetSearch('#')<cr>??<cr>
else
  function! s:vSetSearch(cmdtype)
    let temp = @@
    normal! gvy
    let @/ = '\V' . substitute(escape(@@, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @@ = temp
  endfunction

  xnoremap * :call <sid>vSetSearch('/')<cr>/<c-r>=@/<cr><cr>
  xnoremap # :call <sid>vSetSearch('?')<cr>?<c-r>=@/<cr><cr>
endif


"-----------------------------------------------------------------------------
"                       有 tmux 没有的功能键超时（毫秒）
"-----------------------------------------------------------------------------
" 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
set ttimeout

" 功能键超时检测 50 毫秒
set ttimeoutlen=50

if $TMUX != ''
  set ttimeoutlen=35
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
  set ttimeoutlen=85
endif


"-----------------------------------------------------------------------------
"        终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
"        记得设置 ttimeout （见 init-basic.vim） 和 ttimeoutlen （上面）
"-----------------------------------------------------------------------------
if has('nvim') == 0 && has('gui_running') == 0
  function! s:metacode(key)
    exec 'set <M-' . a:key . ">=\e" . a:key
  endfunc
  for i in range(10)
    call s:metacode(nr2char(char2nr('0') + i))
  endfor
  for i in range(26)
    call s:metacode(nr2char(char2nr('a') + i))
    call s:metacode(nr2char(char2nr('A') + i))
  endfor
  for c in [',', '.', '/', ';', '{', '}']
    call s:metacode(c)
  endfor
  for c in ['?', ':', '-', '_', '+', '=', "'"]
    call s:metacode(c)
  endfor
endif


"-----------------------------------------------------------------------------
"                    终端下功能键设置, 功能键终端码矫正
"-----------------------------------------------------------------------------
function! s:key_escape(name, code)
  if has('nvim') == 0 && has('gui_running') == 0
    exec 'set ' . a:name . "=\e" . a:code
  endif
endfunc

let key_maps = {
      \'<F1>'  : 'OP'    , '<F2>'   : 'OQ'    , '<F3>'   : 'OR'    , '<F4>'   : 'OS',
      \'<S-F1>': '[1;2P' , '<S-F2>' : '[1;2Q' , '<S-F3>' : '[1;2R' , '<S-F4>' : '[1;2S',
      \'<S-F5>': '[15;2~', '<S-F6>' : '[17;2~', '<S-F7>' : '[18;2~', '<S-F8>' : '[19;2~',
      \'<S-F9>': '[20;2~', '<S-F10>': '[21;2~', '<S-F11>': '[23;2~', '<S-F12>': '[24;2~' }

for key in keys(key_maps)
  call s:key_escape(key, key_maps[key])
endfor


"-----------------------------------------------------------------------------
"                                   备份设置
"-----------------------------------------------------------------------------
" 无需备份
set nobackup

" 禁用交换文件
set noswapfile

" 禁用 undo文件
set noundofile


"-----------------------------------------------------------------------------
"                        防止tmux下vim的背景色显示异常
"             Refer: http://sunaku.github.io/vim-256color-bce.html
"-----------------------------------------------------------------------------
if &term =~# '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

if has('nvim') == 0
  let &t_SI = "\<Esc>[6 q"   " SI = 插入模式
  if has("patch-7.4.687")
    let &t_SR = "\<Esc>[4 q" " SR = 替换模式
  endif
  let &t_EI = "\<Esc>[2 q"   " EI = 普通模式
endif


"-----------------------------------------------------------------------------
"                                   配置微调
"-----------------------------------------------------------------------------
" 修正 ScureCRT/XShell 以及某些终端乱码问题，主要原因是不支持一些
" 终端控制命令，比如 cursor shaping 这类更改光标形状的 xterm 终端命令
" 会令一些支持 xterm 不完全的终端解析错误，显示为错误的字符，比如 q 字符
" 如果你确认你的终端支持，不会在一些不兼容的终端上运行该配置，可以注释
if (!has('gui_running')) && has('terminal') && has('patch-8.0.1200') && has('nvim') == 0
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

augroup vimStartup
  au!

  " 打开文件时恢复上一次光标所在位置
  autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

augroup END


"-----------------------------------------------------------------------------
"                                 文件类型微调
"-----------------------------------------------------------------------------
augroup InitFileTypesGroup
  " 清除同组的历史 autocommand
  au!

  " 强制对某些扩展名的 filetype 进行纠正
  au BufNewFile,BufRead *.as  setlocal filetype=actionscript
  au BufNewFile,BufRead *.pro setlocal filetype=prolog
  au BufNewFile,BufRead *.es  setlocal filetype=erlang
  au BufNewFile,BufRead *.asc setlocal filetype=asciidoc
  au BufNewFile,BufRead *.vl  setlocal filetype=verilog
  au BufNewFile,BufRead *.mt  setlocal filetype=multi
  au BufNewFile,BufRead *.pt  setlocal filetype=ProtocolFile
  au BufNewFile,BufRead *.pg  setlocal filetype=ProtocolGeneration

  " C/C++ 文件使用 // 作为注释
  au FileType json,javascript,typescript,c,cpp setlocal commentstring=//\ %s
  au FileType autohotkey setlocal commentstring=;\ %s
  au FileType gitconfig,multi,ProtocolFile setlocal commentstring=#\ %s

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
  au FileType qf setlocal nonumber norelativenumber

  au FileType man setlocal nolist

augroup END
