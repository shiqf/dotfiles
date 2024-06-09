vim9script
#=============================================================================
#
#               function_keymaps.vim - 功能映射
#
# vim: set ts=2 sw=2 tw=78 et :
#=============================================================================
if !exists("g:cvWord")
  g:cvWord = v:false
endif

if !exists("g:vpaste")
  g:vpaste = ''
endif

def OriginPattern(reg: string, isWord: bool = v:false): string
  var stringReg = getregtype('"') ==# 'V' ? reg[0 : -2] : reg
  if stringReg !~ '\W'
    return isWord ? '\v<' .. stringReg .. '>' : stringReg
  else
    return '\V' .. substitute(escape(stringReg, '\/'), '\n', '\\n', 'g')
  endif
enddef

# @@ == @" unname register
# 用寄存器 ""[0(复制), 1(行), -(单行内)], 设置 "/ 作为替换项
def SetReplace(isWord: bool): void
  var reg = getreg('@')
  normal! y
  setreg('/', OriginPattern(getreg('@'), isWord))
  setreg('@', reg)
enddef

# 面向字符可视模式下的面向字符用 */# 号匹配字符串.
def VSetSearch(cmdtype: string): void
  if mode() ==# 'v'
    SetReplace(v:false)
  else
    exec 'keepjumps normal! ' .. cmdtype .. 'N'
    setreg('/', getreg('/'))
  endif
enddef

xnoremap *  <Cmd>call <SID>VSetSearch('*')<Bar>//<CR>
xnoremap #  <Cmd>call <SID>VSetSearch('#')<Bar>??<CR>

# 被替换内容
def Replace(isWord: bool = v:true): void
  var isword = isWord
  if g:cvWord
    g:cvWord = v:false
    isword = v:false
  endif
  var reg = getreg('@')
  if reg !=# ''
    setreg('/', OriginPattern(reg, isword))
  endif
enddef

def PatternVv(): void
  if mode() ==? 'v' | SetReplace(v:true) | else | Replace(v:true) | endif
enddef

def PatternV(): void
  if mode() ==# 'v' | SetReplace(v:false) | else | Replace(v:false) | endif
enddef

def VcFlagSet(): void
  if mode() ==# 'v' | g:cvWord = v:true | endif
enddef

for key in ['c', 's', 'd']
  execute 'xnoremap ' .. key .. ' <Cmd>call <SID>VcFlagSet()<CR>' .. key
endfor

# 将修改 "." 命令与 ":s" 命令结合起来
# 用修改("", "/)作为替换项, 修改内容 ". 作为替换内容.
# 可视模式面向字符的与 g. 的区别是单词的完整匹配与否.
# 面向字符行的与 g. 的区别是: . 的是选中的行全部替换.
# g. 选中的行作为范围. 修改内容为之前小的修改
# 列块暂时没有应用 TODO.
# xnoremap . <Cmd>call <SID>SetReplaceAndSetHighlight()<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<Left><Left>
xnoremap . <Cmd>call <SID>PatternVv()<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<Left><Left>
xnoremap g. <Cmd>call <SID>PatternV()<CR>:s/<c-r>//<c-r>=getreg('.')<CR>/g<Left><Left>

# 跳转到与之前修改内容相同的地方并修改(需先有修改操作).
# 使用前用 g. 再通过 "." 命令重复运用.(go to same change context place and do ".")
nnoremap g. <Cmd>call <SID>Replace()<Bar>set hls<CR>cgn<c-r>=getreg('.')<CR><Esc>

def WordToLower(reg: string): string
  return reg =~ '^\u' ? tolower(reg) : reg
enddef

nnoremap gz <Cmd>call <SID>PatternV()<CR>
      \:<c-u>S/<c-r>=<SID>WordToLower(@/)<CR>/<c-r>=<SID>WordToLower(getreg('.'))<CR>/g<Left><Left>

# 面向字符的, 与面向行的两种
xnoremap gz <Cmd>call <SID>PatternV()<CR>
      \:S/<c-r>=<SID>WordToLower(@/)<CR>/<c-r>=<SID>WordToLower(getreg('.'))<CR>/g<Left><Left>

nnoremap <silent> &  :<c-u>exec '~& ' .. (v:count == 0 ? 1 : v:count)<CR>
xnoremap <silent> &  :~&<CR>
nnoremap <silent> g& :%~&<CR>

# 在可视模式上的重复宏的功能增强
xnoremap <silent> @ :normal @@<CR>

def P()
  var registerName = v:register
  if mode() ==? 'v'
    g:vpaste = getreg(registerName)
    var regtype = getregtype(registerName)
    exec 'normal! "' .. registerName .. 'pu'
    if regtype ==# 'V' && visualmode() ==# 'V'
      g:vpaste = g:vpaste[0 : -2]
    endif
    setreg('/', OriginPattern(getreg('@')))
  else
    exec 'normal! "' .. registerName .. 'p'
  endif
enddef

# 可视模式下替换选中内容, 并使用 "." 命令复用上次替换内容.
xnoremap <silent>p <Cmd>call <SID>P()<Bar>set hls<Bar>set paste<Bar>
      \if visualmode() ==? 'v'<Bar>exec 'normal! cgn' .. g:vpaste<Bar>endif<Bar>set nopaste<CR>

# 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <Leader>ef :<c-u>edit %%<C-Left>
nmap <Leader>es :<c-u>split %%<C-Left>
nmap <Leader>ev :<c-u>vsplit %%<C-Left>
nmap <Leader>et :<c-u>tabedit %%<C-Left>
nmap <Leader>ew :<c-u>cd <c-r>=expand('%:h') .. '/'<CR><Home>
nmap <Leader>ee :<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><Home>tab
xmap <Leader>e y:<c-u>edit <c-r>=getregtype('"') ==# 'v' ? @@ : ''<CR><Home>tab

nnoremap <silent><Leader>ed :<c-u>edit <c-r>=expand('%:h')<CR><CR>
nnoremap <silent><Leader>e. :<c-u>edit!<CR>

# 打开 fugitive 插件中的状态窗口
nnoremap <silent> g<CR> :<c-u>Git!<CR>
nnoremap g<space> :<c-u> <Home>Git!

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

def QFdelete(bufnr: number): void
  var qfl = getqflist()
  var firstline: number
  var lastline: number
  if mode() !~ 'v'
    firstline = line('.')
    lastline = firstline + (v:count > 0 ? v:count - 1 : 0)
  else
    firstline = line("'<")
    lastline = line("'>")
  endif
  remove(qfl, firstline - 1, lastline - 1)
  setqflist([], 'r', {'items': qfl})
  setpos('.', [bufnr, firstline, 1, 0])
enddef

def Count(): string
  if v:count == 0 | return '' | else | return string(v:count) | endif
enddef

augroup QFList | autocmd!
  autocmd BufWinEnter quickfix if &bt ==# 'quickfix'
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dd :<c-u>call <SID>QFdelete(bufnr())<CR>
  autocmd BufWinEnter quickfix    xnoremap <silent><buffer>d  :call <SID>QFdelete(bufnr())<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>ds :<c-u>Cfilter //<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>dc :<c-u>Cfilter! //<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>[d :<c-u>colder<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>]d :<c-u>cnewer<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>[D :<c-u>1chistory<CR>
  autocmd BufWinEnter quickfix    nnoremap <silent><buffer>]D :<c-u>exec getqflist({'nr': '$'}).nr .. 'chistory'<CR>
  autocmd BufWinEnter quickfix    nnoremap         <buffer>dh :<c-u>exec <SID>Count() .. 'chistory'<CR>
  autocmd BufWinEnter quickfix endif
augroup END

# 将 quickfix 列表中的文件加入到 arglist 中去重复, 后可以使用 :argdo 命令执行
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
def QuickfixFilenames(): string
  var buffer_numbers = {}
  for quickfix_item in getqflist()
    buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
enddef

if has('terminal')
  var term_pos = {} # { bufnr: [winheight, n visible lines] }

  def EnterTerminalNormalMode(): void
    if &buftype != 'terminal' || mode() != 't'
      return
    endif
    feedkeys("\<LeftMouse>\<c-_>N", "x")
    term_pos[bufnr()] = [winheight(winnr()), line('$') - line('w0')]
    feedkeys("\<ScrollWheelUp>")
  enddef

  def ExitTerminalNormalModeIfBottom(): void
    if &buftype != 'terminal' || !(mode() == 'n' || mode() == 'v')
      return
    endif
    var term = term_pos[bufnr()]
    var vis_lines = line('$') - line('w0')
    var vis_empty = winheight(winnr()) - vis_lines
    # if size has only expanded, match visible lines on entry
    if term[1] <= winheight(winnr())
      var req_vis = min([winheight(winnr()), term[1]])
      if vis_lines <= req_vis | feedkeys("i", "x") | endif
    # if size has shrunk, match visible empty lines on entry
    else
      var req_vis_empty = term[0] - term[1]
      req_vis_empty = min([winheight(winnr()), req_vis_empty])
      if vis_empty >= req_vis_empty | feedkeys("i", "x") | endif
    endif
  enddef

  # scrolling up enters normal mode in terminal window, scrolling back to
  # the cursor's location upon entry resumes terminal mode. only limitation
  # is that terminal window must have focus before you can scroll to
  # enter normal mode
  tnoremap <silent> <ScrollWheelUp> <Cmd>call <SID>EnterTerminalNormalMode()<CR>
  nnoremap <silent> <ScrollWheelDown> <ScrollWheelDown><Cmd>call <SID>ExitTerminalNormalModeIfBottom()<CR>
endif
