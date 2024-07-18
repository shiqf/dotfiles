vim9script
#=============================================================================
#
#           config.vim - 正常模式下的配置，在 basic.vim 后调用
#
#   - 功能插件开启
#   - 备份设置
#   - 防止tmux下vim的背景色显示异常
#   - 配置微调
#   - 文件类型微调
#   - 高亮查找单词后取消高亮
#   - 终端设置，隐藏行号和侧边栏
#
# vim: set ts=2 sw=2 tw=78 et :
#=============================================================================


#-----------------------------------------------------------------------------
#                  Vim自动把默认剪贴板和系统剪贴板的内容同步
#-----------------------------------------------------------------------------
if has('clipboard')
  set clipboard=unnamed
endif

#-----------------------------------------------------------------------------
#                                 功能插件开启
#-----------------------------------------------------------------------------
packadd! cfilter

# 调用man程序在vim内部查看命令
runtime ftplugin/man.vim

#-----------------------------------------------------------------------------
#                       有 tmux 没有的功能键超时（毫秒）
#-----------------------------------------------------------------------------
# 打开功能键超时检测（终端下功能键为一串 ESC 开头的字符串）
set ttimeout

# 功能键超时检测 50 毫秒
set ttimeoutlen=50

if exists('$TMUX')
  set ttimeoutlen=35
  set ttymouse=sgr
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
  set ttimeoutlen=85
endif

if has('nvim') == 0 && has('gui_running') == 0
  #---------------------------------------------------------------------------
  #        终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
  #        记得设置 ttimeout, ttimeoutlen见 （上面）
  #---------------------------------------------------------------------------
  def MetaCode(key: string): void
    exec $"set <M-{key}>=\e{key}"
  enddef

  for i in range(10)
    MetaCode(nr2char(char2nr('0') + i))
  endfor
  for i in range(26)
    MetaCode(nr2char(char2nr('a') + i))
    # MetaCode(nr2char(char2nr('A') + i))
  endfor
  for c in [',', '.', '/', ';', '{', '}', '\']
    MetaCode(c)
  endfor
  for c in ['?', ':', '-', '_', '+', '=', "'"]
    MetaCode(c)
  endfor

  #---------------------------------------------------------------------------
  #                    终端下功能键设置, 功能键终端码矫正
  #---------------------------------------------------------------------------
  def KeyEscape(name: string, code: string): void
    exec $"set {name}=\e{code}"
  enddef

  var key_maps = {
    '<F1>':     'OP',    '<F2>':     'OQ',    '<F3>':     'OR',    '<F4>':     'OS',
    '<S-F1>':  '[1;2P',  '<S-F2>':  '[1;2Q',  '<S-F3>':  '[1;2R',  '<S-F4>':  '[1;2S',
    '<S-F5>': '[15;2~',  '<S-F6>': '[17;2~',  '<S-F7>': '[18;2~',  '<S-F8>': '[19;2~',
    '<S-F9>': '[20;2~', '<S-F10>': '[21;2~', '<S-F11>': '[23;2~', '<S-F12>': '[24;2~',
  }

  for key in keys(key_maps)
    KeyEscape(key, key_maps[key])
  endfor
endif

#-----------------------------------------------------------------------------
#                                   备份设置
#-----------------------------------------------------------------------------
# 无需备份
set nobackup

# 禁用交换文件
set noswapfile

# 禁用 undo文件
set noundofile

#-----------------------------------------------------------------------------
#                        防止tmux下vim的背景色显示异常
#             Refer: http://sunaku.github.io/vim-256color-bce.html
#-----------------------------------------------------------------------------
if &term =~# '256color'
  # disable Background Color Erase (BCE) so that color schemes
  # render properly when inside 256-color tmux and GNU screen.
  # see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

#-----------------------------------------------------------------------------
#                                   配置微调
#-----------------------------------------------------------------------------
# 修正 ScureCRT/XShell 以及某些终端乱码问题，主要原因是不支持一些
# 终端控制命令，比如 cursor shaping 这类更改光标形状的 xterm 终端命令
# 会令一些支持 xterm 不完全的终端解析错误，显示为错误的字符，比如 q 字符
# 如果你确认你的终端支持，不会在一些不兼容的终端上运行该配置，可以注释
if (!has('gui_running')) && has('terminal') && has('nvim') == 0
  set termwinscroll=100000
  g:termcap_guicursor = &guicursor
  g:termcap_t_RS = &t_RS
  g:termcap_t_SH = &t_SH
  set guicursor=
  set t_RS=
  set t_SH=
endif

# 定义一个 DiffOrig 命令用于查看文件改动
if !exists(':DiffOrig')
  command! DiffOrig vert new | set bt=nofile | r ++edit# | :1d | diffthis | wincmd p | diffthis
  nnoremap dr <Cmd>DiffOrig<CR>
endif

augroup VimStartup
  au!

  # 打开文件时恢复上一次光标所在位置
  au BufReadPost * if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
augroup END

#-----------------------------------------------------------------------------
#                                 文件类型微调
#-----------------------------------------------------------------------------
augroup InitFileTypesGroup
  # 清除同组的历史 autocommand
  au!

  # 强制对某些扩展名的 filetype 进行纠正
  au BufNewFile,BufRead *.as    setlocal filetype=actionscript
  au BufNewFile,BufRead *.pro   setlocal filetype=prolog
  au BufNewFile,BufRead *.es    setlocal filetype=erlang
  au BufNewFile,BufRead *.asc   setlocal filetype=asciidoc
  au BufNewFile,BufRead *.vl    setlocal filetype=verilog
  au BufNewFile,BufRead *.mt    setlocal filetype=multi
  au BufNewFile,BufRead *.pt    setlocal filetype=ProtocolFile
  au BufNewFile,BufRead *.pg    setlocal filetype=ProtocolGeneration
  au BufNewFile,BufRead .tasks  setlocal filetype=dosini
  au BufNewFile,BufRead .gitignore,.rgignore,.ignore  setlocal filetype=ignore

  # C/C++ 文件使用 // 作为注释
  au FileType json,javascript,typescript,c,cpp setlocal commentstring=//\ %s
  au FileType autohotkey setlocal commentstring=;\ %s
  au FileType ignore,gitconfig,multi,ProtocolFile setlocal commentstring=#\ %s

  # markdown 允许自动换行
  au FileType markdown setlocal wrap

  # expandtab 使用 tab 自动转化成空格展开
  # lisp 进行微调
  au FileType lisp setlocal ts=8 sts=2 sw=2 et

  # scala 微调
  au FileType scala setlocal sts=4 sw=4 noet

  # haskell 进行微调
  au FileType haskell setlocal et

  # quickfix 隐藏行号
  au FileType qf setlocal nonumber norelativenumber

  au FileType man setlocal nolist
augroup END

#-----------------------------------------------------------------------------
#                             高亮查找单词后取消高亮
#-----------------------------------------------------------------------------
augroup AutoHighlighting
    au!
    au CmdlineLeave /,\? call feedkeys("\<Cmd>noh\<CR>", 'n')
    au InsertEnter * call feedkeys("\<Cmd>noh\<CR>", 'n')
    au CursorHold * call feedkeys("\<Cmd>noh\<CR>", 'n')
    # au CursorHold * call feedkeys("\<Cmd>redraw!\<CR>", 'n')
    nnoremap . <Cmd>exec $'noau normal! {v:count == 0 ? "" : v:count}.'<CR>
augroup END

# # 恢复非高亮
# noremap <silent> <c-l> <Cmd>nohlsearch<Bar>redraw!<CR>

#-----------------------------------------------------------------------------
#                          终端设置，隐藏行号和侧边栏
#-----------------------------------------------------------------------------
if has('terminal') && exists(':terminal') == 2
  if exists('##TerminalOpen')
    augroup VimUnixTerminalGroup
      au!
      au TerminalOpen * setlocal nonumber signcolumn=no
    augroup END
  endif
endif

# Tweaks for browsing
g:netrw_banner = 0        # disable annoying banner
# g:netrw_browse_split = 4  # open in prior window
# g:netrw_altv = 1          # open splits to the right
g:netrw_liststyle = 3     # tree view
# g:netrw_list_hide = netrw_gitignore#Hide()
# g:netrw_list_hide ..= ',\(^\|\s\s\)\zs\.\S\+'
