"=============================================================================
"
"               function_keymaps.vim - 功能映射
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================

function! s:OriginPattern(arg)
  return a:arg =~ '\W' ? '\V' . substitute(escape(a:arg, '\/'), '\n', '\\n', 'g') : a:arg
endfunction

" 替换内容
function! s:Replace()
  let temp = '"'->getregtype() ==# 'v' ? '"'->getreg() : ''
  let @/ = temp !=# '' ? s:OriginPattern(temp) : ''
endfunction

function s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? len(a:reg) > 1 ? tolower(a:reg[0:0]) . a:reg[1:-1] : tolower(a:reg) : a:reg
endfunction

" 用寄存器 "0, "- 作为替换项
function! s:Pattern()
  if mode() ==# 'v'
    let temp = @@
    normal! y
    let @/ = s:OriginPattern(@@)
    let @@ = temp
  else
    let mode = '"'->getregtype()
    let temp = '"'->getreg()
    if mode ==# 'v' && temp !=# ''
      let @/ = s:OriginPattern(temp)
    endif
  endif
endfunction

if v:version >= 802
  " 可视模式下的面向字符用 * 号匹配字符串
  function! s:vSetSearch(cmdtype)
    if mode() ==# 'v'
      let temp = @@
      normal! y
      let @/ = s:OriginPattern(@@)
      let @@ = temp
    else
      exec 'keepjumps normal! ' . a:cmdtype . 'N'
      " TODO 为什么要这样才行?
      let @/ = @/
    endif
  endfunction

  xnoremap * <cmd>call <SID>vSetSearch('*')<cr>//<cr>
  xnoremap # <cmd>call <SID>vSetSearch('#')<cr>??<cr>
  " 将修改 "." 命令与 ":s" 命令结合起来
  " 将修改再次重复运用于匹配的修改原文, 跳转到修改原文并改变通过 "." 命令, 使用前用 g.
  nnoremap <silent>g. <cmd>call <SID>Replace() \| set hls<cr>cgn<c-r>='.'->getreg()<cr><esc>
  " 用修改("0, "-)作为替换项, 修改内容作为替换内容
  xnoremap g. <cmd>call <SID>Pattern() \| set hls<cr>:s/<c-r>//<c-r>='.'->getreg()<cr>/g<left><left>
  nnoremap gS <cmd>call <SID>Pattern() \| set hls<cr>
        \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
  xnoremap g, <cmd>call <SID>Pattern() \| set hls<cr>
        \:S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
else
  function! s:vSetSearch(cmdtype)
    let temp = @@
    normal! gvy
    let @/ = s:OriginPattern(@@)
    let @@ = temp
  endfunction

  xnoremap * :call <SID>vSetSearch('/')<cr>/<c-r>=@/<cr><cr>
  xnoremap # :call <SID>vSetSearch('?')<cr>?<c-r>=@/<cr><cr>
  nnoremap <silent>g. :<c-u>call <SID>Replace() \| set hls<cr>cgn<c-r>='.'->getreg()<cr><esc>
  " 字符向可视模式功能缺失
  xnoremap g. :<c-u>call <SID>Pattern() \| set hls<cr>gv:s/<c-r>//<c-r>='.'->getreg()<cr>/g<left><left>
  nnoremap gS :<c-u>call <SID>Pattern() \| set hls<cr>
        \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
  xnoremap g, :<c-u>call <SID>Pattern() \| set hls<cr>gv
        \:S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower('.'->getreg())<cr>/g<left><left>
endif

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

" 将 quickfix 列表中的文件加入到 arglist 中去重复, 后可以使用 :argdo 命令执行
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

