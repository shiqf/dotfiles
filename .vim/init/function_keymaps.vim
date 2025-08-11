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
    return isWord ? $'\v<{stringReg}>' : stringReg
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
    exec $'keepjumps normal! {cmdtype}N'
    setreg('/', getreg('/'))
  endif
enddef

xnoremap * <Cmd>call <SID>VSetSearch('*')<Bar>//<CR>
xnoremap # <Cmd>call <SID>VSetSearch('#')<Bar>??<CR>

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
  execute $'xnoremap {key} <Cmd>call <SID>VcFlagSet()<CR>{key}'
endfor

####################################################
# *** 映射的正常模式使用的是无名寄存器作为替代项 ***
####################################################

# 将修改 "." 命令与 ":s" 命令结合起来
# 用修改("", "/)作为替换项, 修改内容 ". 作为替换内容.
# 可视模式面向字符的与 g. 的区别是单词的完整匹配与否.
# 面向字符行的与 g. 的区别是: . 的是选中的行全部替换.
# g. 选中的行作为范围. 修改内容为之前小的修改
# 列块暂时没有应用 TODO.
xnoremap .  <Cmd>call <SID>PatternVv()<CR>:s/<C-R>//<C-R>=getreg('.')<CR>/gc<Left><Left>
xnoremap g. <Cmd>call <SID>PatternV()<CR>:s/<C-R>//<C-R>=getreg('.')<CR>/gc<Left><Left>

# 跳转到与之前修改内容相同的地方并修改(需先有修改操作).
# 使用前用 g. 再通过 "." 命令重复运用.(go to same change context place and do ".")
nnoremap g. <Cmd>call <SID>Replace()<Bar>set ei=all<CR>cgn<C-R>=getreg('.')<CR><Esc><Cmd>set ei=<Bar>set hls<CR>

def WordToLower(reg: string): string
  return reg =~ '^\u' ? tolower(reg) : reg
enddef

nnoremap gz <Cmd>call <SID>PatternV()<CR>
      \:<C-U>gc<Home>S/<C-R>=<SID>WordToLower(@/)<CR>/<C-R>=<SID>WordToLower(getreg('.'))<CR>/

# 面向字符的, 与面向行的两种
xnoremap gz <Cmd>call <SID>PatternV()<CR>
      \:S/<C-R>=<SID>WordToLower(@/)<CR>/<C-R>=<SID>WordToLower(getreg('.'))<CR>/gc<Left><Left>

nnoremap <silent> &  :&&<CR>
xnoremap <silent> &  :~&<CR>
nnoremap <silent> g& :%~&<CR>

# 在可视模式上的重复宏的功能增强
xnoremap <silent> @ :normal @@<CR>

def P()
  var registerName = v:register
  if mode() ==? 'v'
    g:vpaste = getreg(registerName)
    var regtype = getregtype(registerName)
    exec $'normal! "{registerName}pu'
    if regtype ==# 'V' && visualmode() ==# 'V'
      g:vpaste = g:vpaste[0 : -2]
    endif
    setreg('/', OriginPattern(getreg('@')))
  else
    exec $'normal! "{registerName}p'
  endif
enddef

# 可视模式下替换选中内容, 并使用 "." 命令复用上次替换内容.
xnoremap <silent>p <Cmd>call <SID>P()<Bar>set paste<Bar>
      \if visualmode() ==? 'v'<Bar>exec $'normal! cgn{g:vpaste}'<Bar>endif<Bar>set nopaste<Bar>set hls<CR>

# 在命令行中展开当前文件的目录
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:p:r') : '%%'

nmap <Leader>ee :<C-U>edit %%<C-Left>
nmap <Leader>es :<C-U>split %%<C-Left>
nmap <Leader>ev :<C-U>vsplit %%<C-Left>
nmap <Leader>et :<C-U>tabedit %%<C-Left>
nmap <Leader>ew :<C-U>lcd <C-R>=$'{expand('%:p:h')}/'<CR><Home>
nmap <Leader>er :<C-U>lcd -<CR>
nmap <Leader>ef <Cmd>setl path=.,,<CR>:<C-U>find <Home>vert s

nnoremap <Leader>ed <Cmd>exec $'edit {expand('%:h')}'<CR>
nnoremap <Leader>e. <Cmd>edit!<CR>

if !exists('g:no_plugin')
  # 打开 fugitive 插件中的状态窗口
  nnoremap <silent> g<CR> <Cmd>Git!<Bar>exec 'normal gu'<CR>
  nnoremap g<space> :<C-U>Git! 

  g:fugitiveWinnr = 0
  g:gitWinnr = 0
  def DiffWinOpened(): number
    for nr in range(1, winnr('$'))
      if &diff == v:true
        if getwinvar(nr, '&ft') ==# 'fugitive'
          g:fugitiveWinnr = nr
          return nr
        endif
        if getwinvar(nr, '&ft') ==# 'git'
          g:gitWinnr = nr
          return nr
        endif
      endif
    endfor
    return 0
  enddef

  def DiffMoveAction(c: string): void
    if g:fugitiveWinnr != 0
      exec $':{g:fugitiveWinnr}wincmd w'
      exec $'normal {v:count1}{c}mdv'
      g:fugitiveWinnr = 0
      return
    endif
    if g:gitWinnr != 0
      exec $':{g:fugitiveWinnr}wincmd w'
      wincmd o
      exec $'normal {v:count1}{c}mo'
      g:gitWinnr = 0
      return
    endif
  enddef

  def FirstOrLastAction(c: string): void
    if g:fugitiveWinnr != 0
      exec $':{g:fugitiveWinnr}wincmd w'
      if c ==# '[' | exec 'normal gUdv' | elseif c ==# ']' | exec 'normal gU][dv' | endif
      g:fugitiveWinnr = 0
    endif
    if g:gitWinnr != 0
      exec $':{g:fugitiveWinnr}wincmd w'
      wincmd o
      if c ==# '[' | exec 'normal gg]mo' | elseif c ==# ']' | exec 'normal G[mo' | endif
      g:gitWinnr = 0
    endif
  enddef

  nnoremap [d <Cmd>if <SID>DiffWinOpened() != 0<Bar>call <SID>DiffMoveAction('[')<Bar>else<Bar>exec 'normal! [d'<Bar>endif<CR>
  nnoremap ]d <Cmd>if <SID>DiffWinOpened() != 0<Bar>call <SID>DiffMoveAction(']')<Bar>else<Bar>exec 'normal! ]d'<Bar>endif<CR>
  nnoremap [D <Cmd>if <SID>DiffWinOpened() != 0<Bar>call <SID>FirstOrLastAction('[')<Bar>else<Bar>exec 'normal! [D'<Bar>endif<CR>
  nnoremap ]D <Cmd>if <SID>DiffWinOpened() != 0<Bar>call <SID>FirstOrLastAction(']')<Bar>else<Bar>exec 'normal! ]D'<Bar>endif<CR>

  def FugitiveWinOpened(): number
    for nr in range(1, winnr('$'))
      if &diff == v:true && getwinvar(nr, '&ft') ==# 'fugitive'
        g:fugitiveWinnr = nr
        return nr
      endif
    endfor
    return 0
  enddef

  def FugitiveAction(): void
    if g:fugitiveWinnr != 0
      exec $':{g:fugitiveWinnr}wincmd w'
      normal s
      g:fugitiveWinnr = 0
    endif
  enddef
  nnoremap <c-s> <Cmd>if <SID>FugitiveWinOpened() != 0<Bar>call <SID>FugitiveAction()<Bar>endif<CR>

  nnoremap <Leader>ge :<C-U>Gedit %<Left>
  nnoremap <Leader>gt :<C-U>Gtabedit %<Left>
  nnoremap <Leader>gl :<C-U>Gclog! --author=
  nnoremap <Leader>gc :<C-U> -n<Home>Git! clean -xdf
  nnoremap <Leader>gp :<C-U> --all<Home>Git! log --oneline --decorate --graph --author=

  xnoremap <silent> ado <Cmd>diffget<CR>
  xnoremap <silent> 2do <Cmd>diffget //2<CR>
  xnoremap <silent> 3do <Cmd>diffget //3<CR>
  nnoremap <silent> 2do <Cmd>diffget //2<CR>
  nnoremap <silent> 3do <Cmd>diffget //3<CR>

  xnoremap <silent> adp <Cmd>diffput<CR>
  xnoremap <silent> 2dp <Cmd>diffput //2<CR>
  xnoremap <silent> 3dp <Cmd>diffput //3<CR>
  nnoremap <silent> 2dp <Cmd>diffput //2<CR>
  nnoremap <silent> 3dp <Cmd>diffput //3<CR>
endif

def QFdelete(bufnr: number, firstline: number, lastline: number): void
  var qfl = getqflist()
  remove(qfl, firstline - 1, lastline - 1)
  setqflist([], 'r', {'items': qfl})
  setpos('.', [bufnr, firstline, 1, 0])
enddef

def Count(): string
  if v:count == 0 | return '' | else | return string(v:count) | endif
enddef

def QuickfixFilenames(): string
  var buffer_numbers = {}
  for quickfix_item in getqflist()
    if quickfix_item['valid'] == 1
      buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
    endif
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
enddef
# 将 quickfix 列表中的文件加入到 arglist 中去重复, 后可以使用 :argdo 命令执行
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()

def RangeViusal(): string
  return $'{line("'<")},{line("'>"})'
enddef

def RangeNormal(): string
  var firstLine = line('.')
  var lastLine = firstLine + v:count1 - 1
  return $'{firstLine},{lastLine}'
enddef

augroup QFList
  au!
  au BufWinEnter quickfix if &bt ==# 'quickfix'
  au BufWinEnter quickfix    nnoremap <silent><buffer> dd <Cmd>call <SID>QFdelete(bufnr(), line('.'), line('.') + v:count1 - 1)<CR>
  au BufWinEnter quickfix    xnoremap <silent><buffer> d  :<C-U>call <SID>QFdelete(bufnr(), line("'<"), line("'>"))<CR>
  au BufWinEnter quickfix    nnoremap <silent><buffer> ds <Cmd>Cfilter //<CR>
  au BufWinEnter quickfix    nnoremap <silent><buffer> dc <Cmd>Cfilter! //<CR>
  au BufWinEnter quickfix    nnoremap <silent><buffer> [F <Cmd>1chistory<CR>
  au BufWinEnter quickfix    nnoremap <silent><buffer> ]F <Cmd>exec getqflist({'nr': '$'}).nr .. 'chistory'<CR>
  au BufWinEnter quickfix    nnoremap <buffer> dh         <Cmd>exec $'{<SID>Count()}chistory'<CR>
  au BufWinEnter quickfix    nnoremap <buffer> d<space>   :<C-U>Cfilter /<C-R><C-W>/<Left>
  au BufWinEnter quickfix    nnoremap <buffer> A          <Cmd>Qargs<Bar>q<Bar>args<CR>
  au BufWinEnter quickfix    nnoremap <buffer> cd         :<C-U><C-R>=<SID>RangeNormal()<CR>cdo s//<C-R>=getreg('.')<CR>/gc<Left><Left><Left>
  au BufWinEnter quickfix    xnoremap <buffer> cd         :<C-U><C-R>=<SID>RangeViusal()<CR>cdo s//<C-R>=getreg('.')<CR>/gc<Left><Left><Left>
  au BufWinEnter quickfix    noremap  <buffer> cf         :<C-U>/g <Bar> update<Home>cfdo %s//<C-R>=getreg('.')<CR>
  au BufWinEnter quickfix endif
augroup END

if has('terminal')
  var term_pos = {}

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

    var flag = v:false
    for key in keys(term_pos)
      if string(bufnr()) == key
        flag = v:true
        break
      endif
    endfor
    if flag == v:false
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
