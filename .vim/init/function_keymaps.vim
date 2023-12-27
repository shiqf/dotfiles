"=============================================================================
"
"               function_keymaps.vim - 功能映射
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================
if !exists("g:cvWord")
  let g:cvWord = v:false
endif

if !exists("g:vpaste")
  let g:vpaste = ''
endif

function! s:OriginPattern(reg, isWord = v:false)
  let l:string = getregtype('"') ==# 'V' ? a:reg[0:-2] : a:reg
  if l:string !~ '\W'
    return a:isWord ? '\v<' . l:string . '>' : l:string
  else
    return '\V' . substitute(escape(l:string, '\/'), '\n', '\\n', 'g')
  endif
endfunction

" @@ == @" unname register
" 用寄存器 ""[0(复制), 1(行), -(单行内)], 设置 "/ 作为替换项
function! s:SetReplace(isWord)
  let l:reg = @@
  normal! y
  let @/ = s:OriginPattern(@@, a:isWord)
  let @@ = l:reg
endfunction

" 被替换内容
function! s:Replace(isWord = v:true)
  let l:isWord = a:isWord
  if g:cvWord
    let g:cvWord = v:false
    let l:isWord = v:false
  endif
  if @@ !=# ''
    let @/ = s:OriginPattern(@@, l:isWord)
  endif
endfunction

" 面向字符可视模式下的面向字符用 */# 号匹配字符串. 
function! s:vSetSearch(cmdtype)
  if mode() ==# 'v'
    call s:SetReplace(v:false)
  else
    exec 'keepjumps normal! ' . a:cmdtype . 'N'
    let @/ = @/
  endif
endfunction

xnoremap *  <Cmd>call <SID>vSetSearch('*')<Bar>//<CR>
xnoremap #  <Cmd>call <SID>vSetSearch('#')<Bar>??<CR>

function! s:vVPattern()
  if mode() ==? 'v'
    call s:SetReplace(v:true)
  else
    call s:Replace(v:true)
  endif
endfunction

function! s:vPattern()
  if mode() ==# 'v'
    call s:SetReplace(v:false)
  else
    call s:Replace(v:false)
  endif
endfunction

function! s:vcFlagSet()
  if mode() ==# 'v'
    let g:cvWord = v:true
  endif
endfunction

for key in [ 'c', 's', 'd' ]
  execute 'xnoremap ' .. key .. ' <Cmd>call <SID>vcFlagSet()<CR>' .. key
endfor

" 将修改 "." 命令与 ":s" 命令结合起来
" 用修改("", "/)作为替换项, 修改内容 ". 作为替换内容.
" 面向字符/块的与 g. 的区别是完整单词匹配.
" 列块暂时没有应用 TODO.
xnoremap . <Cmd>call <SID>vVPattern()<Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<Left><Left>
xnoremap g. <Cmd>call <SID>vPattern()<Bar>set hls<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<Left><Left>
" 跳转到与之前修改内容相同的地方并修改(需先有修改操作).
" 使用前用 g. 再通过 "." 命令重复运用.(go to same change context place and do ".")
nnoremap g. <Cmd>call <SID>Replace()<Bar>set hls<CR>cgn<c-r>=getreg('.')<CR><esc>

function! s:FirstCharToLower(reg)
  return a:reg =~ '^\u' ? len(a:reg) > 1 ? tolower(a:reg[0:0]) . a:reg[1:-1] : tolower(a:reg) : a:reg
endfunction

nnoremap gz <Cmd>call <SID>vPattern()<Bar>set hls<CR>
      \:<c-u>S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<Left><Left>
xnoremap gz <Cmd>call <SID>vPattern()<Bar>set hls<CR>
      \:S/<c-r>=<SID>FirstCharToLower(@/)<CR>/<c-r>=<SID>FirstCharToLower(getreg('.'))<CR>/g<Left><Left>

nnoremap <silent> &  :<c-u>exec '~& ' . (v:count == 0 ? 1 : v:count)<CR>
xnoremap <silent> &  :~&<CR>
nnoremap <silent> g& :%~&<CR>

" 在可视模式上的重复宏的功能增强
xnoremap <silent> @ :normal @@<CR>

function! s:P()
  let l:registerName = v:register
  if mode() ==? 'v'
    let g:vpaste = getreg(l:registerName)
    let l:regtype = getregtype(l:registerName)
    exec 'normal! "' . l:registerName . 'pu'
    if l:regtype ==# 'V' && visualmode() ==# 'V'
      let g:vpaste = g:vpaste[0:-2]
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

nmap <Leader>ef :<c-u>edit %%<C-Left>
nmap <Leader>es :<c-u>split %%<C-Left>
nmap <Leader>ev :<c-u>vsplit %%<C-Left>
nmap <Leader>et :<c-u>tabedit %%<C-Left>
nmap <Leader>ew :<c-u>cd <c-r>=expand('%:h').'/'<CR><Home>
nmap <Leader>ee :<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><Home>tab
xmap <Leader>e y:<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><Home>tab

nnoremap <silent><Leader>ed :<c-u>edit <c-r>=expand('%:h')<CR><CR>
nnoremap <silent><Leader>e. :<c-u>edit!<CR>

" 打开 fugitive 插件中的状态窗口
nnoremap <silent> g<CR> :<c-u>Git!<CR>
nnoremap g<space> :<c-u>Git! 

nnoremap <Leader>ge :<c-u>Gedit %
nnoremap <Leader>gl :<c-u>Gclog! --author=
nnoremap <Leader>gc :<c-u> -n<Home>Git! clean -xdf
nnoremap <Leader>gp :<c-u> --all<Home>Git! log --oneline --decorate --graph --author=

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

augroup QFList | autocmd!
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
