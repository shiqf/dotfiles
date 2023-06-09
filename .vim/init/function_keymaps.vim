"=============================================================================
"
"               function_keymaps.vim - 功能映射
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================
function! s:OriginPattern(reg, isWord = 0)
  if a:reg !~ '\W'
    return a:isWord == 1 ? '\v<' . a:reg . '>' : a:reg
  else
    return '\V' . substitute(escape(a:reg, '\/'), '\n', '\\n', 'g')
  endif
endfunction

" 面向字符可视模式下的面向字符用 */# 号匹配字符串. @@ == @" unname register
function! s:vSetSearch(cmdtype)
  if mode() ==# 'v'
    let l:reg = @@
    normal! y
    let @/ = s:OriginPattern(@@)
    let @@ = l:reg
  else
    exec 'keepjumps normal! ' . a:cmdtype . 'N'
    let @/ = @/
  endif
endfunction

xnoremap *  <Cmd>call <SID>vSetSearch('*')<CR>//<CR>
xnoremap #  <Cmd>call <SID>vSetSearch('#')<CR>??<CR>

" 用寄存器 "", "/ 作为替换项
function! s:Pattern(isWord = 0)
  let l:reg = @@
  if mode() ==# 'v'
    normal! y
    let @/ = s:OriginPattern(@@, a:isWord)
    let @@ = l:reg
  else
    if getregtype('"') ==# 'v' && l:reg !=# ''
      let @/ = s:OriginPattern(l:reg, a:isWord)
    endif
  endif
endfunction

" 将修改 "." 命令与 ":s" 命令结合起来
" 用修改("", "/)作为替换项, 修改内容作为替换内容.
" 面向字符的与 g. 的区别是完整单词匹配. 面向行的可视模式与 g. 相同
xnoremap .  <Cmd>call <SID>Pattern(1)<Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<left><left>

" 被替换内容
function! s:Replace()
  let @/ = getregtype('"') ==# 'v' && @@ !=# '' ? s:OriginPattern(@@) : ''
endfunction

" 根据面向字符或行有两种情况(v: "", V: "/), 行与 "." 的可视映射相同. 列块暂时没有应用.
xnoremap g. <Cmd>call <SID>Pattern()<Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<left><left>
" 跳转到与之前修改内容相同的地方并修改(需先有修改操作).
" 使用前用 g. 再通过 "." 命令重复运用.(go to same context change place and do ".")
nnoremap g. <Cmd>call <SID>Replace()<Bar>set hls<CR>cgn<c-r>=getreg('.')<CR><esc>

function s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? len(a:reg) > 1 ? tolower(a:reg[0:0]) . a:reg[1:-1] : tolower(a:reg) : a:reg
endfunction

nnoremap gz <Cmd>call <SID>Pattern()<Bar>set hls<CR>
      \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<left><left>
xnoremap gz <Cmd>call <SID>Pattern()<Bar>set hls<CR>
      \:S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<left><left>

nnoremap <silent> &  :<c-u>exec '~& ' . (v:count == 0 ? 1 : v:count)<cr>
xnoremap <silent> &  :~&<cr>
nnoremap <silent> g& :%~&<cr>

" 在可视模式上的重复宏的功能增强
xnoremap <silent> @ :normal @@<cr>

if !exists("g:vpaste")
  let g:vpaste = ''
endif

function! s:P()
  let l:registerName = v:register
  if mode() ==? 'v'
    let g:vpaste = getreg(l:registerName)
    let l:regtype = getregtype(l:registerName)
    exec 'normal! "' . l:registerName . 'pu'
    if l:regtype ==# 'v' && visualmode() ==# 'V'
      let g:vpaste = g:vpaste . "\n"
    endif
    let @/ = s:OriginPattern(@@)
  else
    exec 'normal! "' . l:registerName . 'p'
  endif
endfunction

" 可视模式下替换选中内容, 并使用 "." 命令复用上次替换内容.
xnoremap <silent>p <Cmd>call <SID>P()<Bar>set hls<Bar>set paste<Bar>
      \if visualmode() ==? 'v'<Bar>exec 'normal! cgn' . g:vpaste<Bar>endif<Bar>set nopaste<CR>

" 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <leader>ef :<c-u>edit %%<c-left>
nmap <leader>es :<c-u>split %%<c-left>
nmap <leader>ev :<c-u>vsplit %%<c-left>
nmap <leader>et :<c-u>tabedit %%<c-left>
nmap <leader>ew :<c-u>cd <c-r>=expand('%:h').'/'<CR><home>
nmap <leader>ee :<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><home>tab
xmap <leader>e y:<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><home>tab

nnoremap <silent><leader>ed :<c-u>edit <c-r>=expand('%:h')<CR><CR>
nnoremap <silent><leader>e. :<c-u>edit!<CR>

" 打开 fugitive 插件中的状态窗口
nnoremap <silent> g<CR> :<c-u>Git!<CR>
nnoremap g<space> :<c-u>Git! 

nnoremap <leader>ge :<c-u>Gedit %
nnoremap <leader>gl :<c-u>Gclog! --author=
nnoremap <leader>gc :<c-u> -n<home>Git! clean -xdf
nnoremap <leader>gp :<c-u> --all<home>Git! log --oneline --decorate --graph --author=

xnoremap <silent> ado :diffget<CR>
xnoremap <silent> 2do :diffget //2<CR>
xnoremap <silent> 3do :diffget //3<CR>
nnoremap <silent> 2do :diffget //2<CR>
nnoremap <silent> 3do :diffget //3<CR>

xnoremap <silent> adp :diffput<CR>
xnoremap <silent> 2dp :diffput //2<CR>
xnoremap <silent> 3dp :diffput //3<CR>
nnoremap <silent> 2dp :diffput //2<CR>
nnoremap <silent> 3dp :diffput //3<CR>


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
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :call QFdelete(bufnr())<CR>
  autocmd BufWinEnter quickfix    vnoremap <silent><buffer>d  :call QFdelete(bufnr())<CR>
  autocmd BufWinEnter quickfix endif
augroup END

if has('terminal')
  let s:term_pos = {} " { bufnr: [winheight, n visible lines] }

  function! EnterTerminalNormalMode()
    if &buftype != 'terminal' || mode('') != 't'
      return 0
    endif
    call feedkeys("\<LeftMouse>\<c-_>N", "x")
    let s:term_pos[bufnr()] = [winheight(winnr()), line('$') - line('w0')]
    call feedkeys("\<ScrollWheelUp>")
  endfunction

  function! ExitTerminalNormalModeIfBottom()
    if &buftype != 'terminal' || !(mode('') == 'n' || mode('') == 'v') 
      return 0
    endif
    let term_pos = s:term_pos[bufnr()]
    let vis_lines = line('$') - line('w0')
    let vis_empty = winheight(winnr()) - vis_lines
    " if size has only expanded, match visible lines on entry
    if term_pos[1] <= winheight(winnr())
      let req_vis = min([winheight(winnr()), term_pos[1]])
      if vis_lines <= req_vis | call feedkeys("i", "x") | endif
      " if size has shrunk, match visible empty lines on entry
    else
      let req_vis_empty = term_pos[0] - term_pos[1]
      let req_vis_empty = min([winheight(winnr()), req_vis_empty])
      if vis_empty >= req_vis_empty | call feedkeys("i", "x") | endif
    endif
  endfunction

  " scrolling up enters normal mode in terminal window, scrolling back to 
  " the cursor's location upon entry resumes terminal mode. only limitation 
  " is that terminal window must have focus before you can scroll to 
  " enter normal mode
  tnoremap <silent> <ScrollWheelUp> <Cmd>call EnterTerminalNormalMode()<CR>
  nnoremap <silent> <ScrollWheelDown> <ScrollWheelDown>:call ExitTerminalNormalModeIfBottom()<CR>
endif
