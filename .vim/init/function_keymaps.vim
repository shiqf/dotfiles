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
  let l:temp = getregtype('"') ==# 'v' ? getreg('"') : ''
  let @/ = l:temp !=# '' ? s:OriginPattern(l:temp) : ''
endfunction

function s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? len(a:reg) > 1 ? tolower(a:reg[0:0]) . a:reg[1:-1] : tolower(a:reg) : a:reg
endfunction

" 用寄存器 "0, "- 作为替换项
function! s:Pattern()
  if visualmode() ==# 'v'
    let l:temp = @@
    normal! gvy
    let @/ = s:OriginPattern(@@)
    let @@ = l:temp
  else
    let l:temp = getreg('"')
    if getregtype('"') ==# 'v' && l:temp !=# ''
      let @/ = s:OriginPattern(l:temp)
    endif
  endif
endfunction

if v:version >= 802
  " 可视模式下的面向字符用 * 号匹配字符串
  function! s:vSetSearch(cmdtype)
    if mode() ==# 'v'
      let l:temp = @@
      normal! y
      let @/ = s:OriginPattern(@@)
      let @@ = l:temp
    else
      exec 'keepjumps normal! ' . a:cmdtype . 'N'
      let @/ = @/
    endif
  endfunction

  xnoremap * <cmd>call <SID>vSetSearch('*')<cr>//<cr>
  xnoremap # <cmd>call <SID>vSetSearch('#')<cr>??<cr>
else
  function! s:vSetSearch()
    let l:temp = @@
    normal! gvy
    let @/ = s:OriginPattern(@@)
    let @@ = l:temp
  endfunction

  xnoremap * :<c-u>call <SID>vSetSearch()<cr>//<cr>
  xnoremap # :<c-u>call <SID>vSetSearch()<cr>??<cr>
endif

" 将修改 "." 命令与 ":s" 命令结合起来
" 将修改再次重复运用于匹配的修改原文, 跳转到修改原文并改变通过 "." 命令, 使用前用 g.
" 用修改("0, "-)作为替换项, 修改内容作为替换内容
nnoremap <silent>g. :<c-u>call <SID>Replace() \| set hls<cr>cgn<c-r>=getreg('.')<cr><esc>
xnoremap g. :<c-u>call <SID>Pattern() \| set hls<cr>gv:s/<c-r>//<c-r>=getreg('.')<cr>/g<left><left>
nnoremap gz :<c-u>call <SID>Pattern() \| set hls<cr>
      \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower(getreg('.'))<cr>/g<left><left>
xnoremap gz :<c-u>call <SID>Pattern() \| set hls<cr>gv
      \:S/<c-r>=<SID>FirstCharToLower(@/)<cr>/<c-r>=<SID>FirstCharToLower(getreg('.'))<cr>/g<left><left>

if !exists("g:vpaste")
  let g:vpaste = ''
endif

function! s:P()
  let l:temp = @a
  let g:vpaste = @"
  normal! gv"ay
  let @/ = s:OriginPattern(@a)
  if &cb =~ 'unnamed'
    let g:vpaste = @*
    let @* = @a
  endif
  let @a = l:temp
endfunction

xnoremap <silent> P :<c-u>call <SID>P()<cr>cgn<c-r>=g:vpaste<cr><esc>

" 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <leader>ef :<c-u>edit %%<c-left>
nmap <leader>es :<c-u>split %%<c-left>
nmap <leader>ev :<c-u>vsplit %%<c-left>
nmap <leader>et :<c-u>tabedit %%<c-left>
nmap <leader>ew :<c-u>cd <c-r>=expand('%:h').'/'<cr><home>
nmap <leader>ee :<c-u>edit <c-r>=getregtype('"') ==# 'v' ? getreg('"') : ''<cr><home>tab
xmap <leader>e y:<c-u>edit <c-r>=getregtype('"') ==# 'v' ? getreg('"') : ''<cr><home>tab

nnoremap <silent><leader>ed :<c-u>edit <c-r>=expand('%:h')<cr><cr>
nnoremap <silent><leader>e. :<c-u>edit!<cr>

" 打开 fugitive 插件中的状态窗口
nnoremap <silent> g<cr> :<c-u>Git!<cr>
nnoremap g<space> :<c-u>Git! 

nnoremap <leader>ge :<c-u>Gedit %
nnoremap <leader>gl :<c-u>Gclog! --author=
nnoremap <leader>gc :<c-u> -n<home>Git! clean -xdf
nnoremap <leader>gp :<c-u> --all<home>Git! log --oneline --decorate --graph --author=

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


" 将 quickfix 列表中的文件加入到 arglist 中去重复, 后可以使用 :argdo 命令执行
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction

function! QFdelete(bufnr) range
  let l:qfl = getqflist()
  call remove(l:qfl, a:firstline - 1, a:lastline - 1)
  call setqflist([], 'r', {'items': l:qfl})
  call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction

augroup QFList | au!
  autocmd BufWinEnter quickfix if &bt ==# 'quickfix'
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :call QFdelete(bufnr())<cr>
  autocmd BufWinEnter quickfix    vnoremap <silent><buffer>d  :call QFdelete(bufnr())<cr>
  autocmd BufWinEnter quickfix endif
augroup END
