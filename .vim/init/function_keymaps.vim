"=============================================================================
"
"               function_keymaps.vim - 功能映射
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================
function! s:OriginPattern(reg, isWord = 0, isLineWise = 0)
  let l:string = visualmode() ==# 'V' && a:isLineWise == 0 ? a:reg[0:-2] : a:reg
  if l:string !~ '\W'
    if a:isWord == 1
      return '\v<' . l:string . '>'
    else
      return l:string
    endif
  else
    return '\V' . substitute(escape(l:string, '\/'), '\n', '\\n', 'g')
  endif
endfunction

" 替换内容
function! s:Replace()
  let l:reg = getregtype('"') ==# 'v' ? getreg('"') : ''
  let @/ = l:reg !=# '' ? s:OriginPattern(l:reg) : ''
endfunction

function s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? len(a:reg) > 1 ? tolower(a:reg[0:0]) . a:reg[1:-1] : tolower(a:reg) : a:reg
endfunction

" 用寄存器 "0, "- 作为替换项
function! s:Pattern(isWord = 0)
  if mode() ==# 'v'
    let l:reg = @@
    normal! y
    let @/ = s:OriginPattern(@@, a:isWord)
    let @@ = l:reg
  else
    let l:reg = getreg('"')
    if getregtype('"') ==# 'v' && l:reg !=# ''
      let @/ = s:OriginPattern(l:reg, a:isWord)
    endif
  endif
endfunction

" 可视模式下的面向字符用 * 号匹配字符串
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

xnoremap * <cmd>call <SID>vSetSearch('*')<CR>//<CR>
xnoremap # <cmd>call <SID>vSetSearch('#')<CR>??<CR>

" 将修改 "." 命令与 ":s" 命令结合起来
" 将修改再次重复运用于匹配的修改原文, 跳转到修改原文并改变通过 "." 命令, 使用前用 g.
" 用修改("0, "-)作为替换项, 修改内容作为替换内容
xnoremap .  <Cmd>call <SID>Pattern(1)<Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<left><left>
nnoremap g. <Cmd>call <SID>Replace() <Bar>set hls<CR>cgn<c-r>=getreg('.')<CR><esc>
xnoremap g. <Cmd>call <SID>Pattern() <Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<left><left>

nnoremap gz <Cmd>call <SID>Pattern()<Bar>set hls<CR>
      \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<left><left>
xnoremap gz <Cmd>call <SID>Pattern()<Bar> set hls<CR>
      \:S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<left><left>

if !exists("g:vpaste")
  let g:vpaste = ''
endif

function! s:P()
  let l:registerName = v:register
  if mode() ==? 'v'
    let g:vpaste = getreg(l:registerName)
    let l:lineWise = getregtype(l:registerName) ==# 'V' ? 1 : 0
    exec 'normal! "' . l:registerName . 'pu'
    let @/ = s:OriginPattern(@", 0, l:lineWise)
  else
    exec 'normal! "' . l:registerName . 'p'
  endif
endfunction

xnoremap <silent>p <Cmd>call <SID>P()<Bar>set hls<Bar>if visualmode() ==? 'v'<Bar>exec 'normal! cgn' . g:vpaste<Bar>endif<CR>

" 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <leader>ef :<c-u>edit %%<c-left>
nmap <leader>es :<c-u>split %%<c-left>
nmap <leader>ev :<c-u>vsplit %%<c-left>
nmap <leader>et :<c-u>tabedit %%<c-left>
nmap <leader>ew :<c-u>cd <c-r>=expand('%:h').'/'<CR><home>
nmap <leader>ee :<c-u>edit <c-r>=getregtype('"') ==# 'v' ? getreg('"') : ''<CR><home>tab
xmap <leader>e y:<c-u>edit <c-r>=getregtype('"') ==# 'v' ? getreg('"') : ''<CR><home>tab

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
