" 禁用 vi 兼容模式
set nocompatible

"-----------------------------------------------------------------------------
"                         在 ~/.vim/bundle 下安装插件
"-----------------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundle'))

" 异步运行并把结果放入quickfix中
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

let g:asyncrun_rootmarks = ['.git', '.hg', '.svn', '.root']
let g:asyncrun_open = 10
let g:asynctasks_term_rows = 10    " 设置纵向切割时，高度为 10
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_focus = 0
let g:asyncrun_bell = 1
let g:asyncrun_trim = 1
if has('win64') || has('win32')
  let g:asynctasks_term_pos = 'external'
else
  let g:asynctasks_term_pos = 'curwin'
endif

nnoremap <leader>ar :AsyncRun 
nnoremap <silent> <leader>as :<c-u>AsyncStop<cr>
nnoremap <silent> <leader>am :<c-u>AsyncTaskMacro<cr>
nnoremap <silent> <leader>ae :<c-u>AsyncTaskEdit<cr>
nnoremap <silent> <leader>al :<c-u>AsyncTaskList<cr>

nnoremap <silent> <leader>2 :<c-u>AsyncTask file-obj<cr>
nnoremap <silent> <leader>5 :<c-u>AsyncTask file-run<cr>
nnoremap <silent> <leader>6 :<c-u>AsyncTask project-run<cr>
nnoremap <silent> <leader>7 :<c-u>AsyncTask project-build<cr>
nnoremap <silent> <leader>8 :<c-u>AsyncTask file-debug<cr>
nnoremap <silent> <leader>9 :<c-u>AsyncTask file-build<cr>

" 为其他插件提供重复操作'.'功能
Plug 'tpope/vim-repeat'

" 通过gcc添加或撤销注释
Plug 'tpope/vim-commentary'

" 提供遍历 [b 缓存,[q quickfix 快速修改,[a args 参数列表,[l location,[t tags
" 遍历文件 [f ]f 遍历，git conflict [n ]n
" vim常用设置项 yon 显示数字，yoh 显示高亮，yol 显示不可见字符...
" [<space> 向上增加空行 ]<space> 向下增加空行 ]e [e 交换上下行
" 解码或编码特殊文件字符 xml|html ]x [x   url ]u [u  c风格字符串输出格式 ]y [y
" 普通模式 [<>=][Pp] 缩进粘贴 插入粘贴模式 y[oO] <ctrl-v> -- 不自动增加缩进
Plug 'tpope/vim-unimpaired'

" 添加／删除／改变成对符号 ds, ys, cs, 可视模式使用 S 作为前缀
Plug 'tpope/vim-surround'

" 多单词查询、代替、缩写
Plug 'tpope/vim-abolish'

" Git 支持
Plug 'tpope/vim-fugitive'

" 配对括号和引号自动补全
Plug 'jiangmiao/auto-pairs'

let g:AutoPairsFlyMode            = 0
let g:AutoPairsShortcutBackInsert = '<M-z>'
let g:AutoPairsShortcutToggle     = '<M-a>'
let g:AutoPairsMapCh              = 0
let g:AutoPairsMoveCharacter      = ''
let g:AutoPairsShortcutJump       = ''

" 交换选定范围
Plug 'tommcdo/vim-exchange'

" quickfix 增强
Plug 'yssl/QFEnter'
let g:qfenter_keymap       = {}
let g:qfenter_keymap.open  = ['<CR>', '<2-LeftMouse>']
let g:qfenter_keymap.vopen = ['<c-]>' ,'gO', 's']
let g:qfenter_keymap.hopen = ['<c-x>' ,'o', 'i']
let g:qfenter_keymap.topen = ['<c-t>' ,'O', 'T']

" 基础插件：提供让用户方便的自定义文本对象的接口
Plug 'kana/vim-textobj-user'

" 增加文件文本对象: e   dae yae cie
Plug 'kana/vim-textobj-entire'

" 增加行文本对象: l   dal yal cil
Plug 'kana/vim-textobj-line'

" indent 文本对象：ii/ai 表示当前缩进，vii 选中当缩进，cii 改写缩进
Plug 'kana/vim-textobj-indent'

" 参数文本对象：i,/a, 包括参数或者列表元素
Plug 'sgur/vim-textobj-parameter'

"-----------------------------------------------------------------------------
"     LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"-----------------------------------------------------------------------------
if has('python3')
  " 如果 vim 支持 python 则启用  Leaderf
  if has('win32') || has('win64')
    Plug 'Yggdroot/LeaderF', { 'do': '.\install.bat' }
  else
    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
  endif

  let g:Lf_CtagsFuncOpts = {
        \ 'c': '--kinds-c=f',
        \ 'javascript': '--kinds-javascript=fm',
        \ 'python': '--kinds-python=fmc',
        \ 'typescript': '--kinds-typescript=fmc',
        \ }

  " CTRL+p 打开文件模糊匹配
  let g:Lf_ShortcutF = '<c-p>'

  " ALT+b 打开 buffer 模糊匹配
  let g:Lf_ShortcutB = '<m-b>'

  " CTRL+n 打开当前项目最近使用的文件 MRU，进行模糊匹配
  nnoremap <c-n> :<c-u>LeaderfMruCwd<cr>

  " ALT+n 打开最近使用的文件 MRU，进行模糊匹配
  nnoremap <m-n> :<c-u>LeaderfMru<cr>

  " ALT+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
  nnoremap <m-f> :<c-u>LeaderfFunction<cr>

  " ALT+SHIFT+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
  nnoremap <m-F> :<c-u>LeaderfFunctionAll<cr>

  " ALT+t 打开 tag 列表，i 进入模糊匹配，ESC退出
  nnoremap <m-t> :<c-u>LeaderfBufTag<cr>

  " 全局 tags 模糊匹配
  nnoremap <m-T> :<c-u>LeaderfBufTagAll<cr>

  " 命令历史
  nnoremap <m-c> :<c-u>LeaderfHistoryCmd<cr>

  " Leaderf 自己的命令模糊匹配
  nnoremap <m-s> :<c-u>LeaderfSelf<cr>

  noremap ]r :<c-u>Leaderf --next<cr>
  noremap [r :<c-u>Leaderf --previous<cr>

  " 最大历史文件保存 2048 个
  let g:Lf_MruMaxFiles = 2048

  " 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
  let g:Lf_RootMarkers = ['.root', '.svn', '.git']
  let g:Lf_WorkingDirectoryMode = 'Ac'
  let g:Lf_WindowHeight = 0.30
  let g:Lf_CacheDirectory = expand('~/.vim/cache')

  " ui 定制
  let g:Lf_StlSeparator = { 'left': '>', 'right': '<', 'font': '' }

  " 使用 / 寄存器存储 rg -e 使用的正则表达式
  let g:Lf_RgStorePattern = '/'

  " 显示绝对路径
  let g:Lf_ShowRelativePath = 1

  " 隐藏帮助
  let g:Lf_HideHelp = 1

  let g:Lf_DiscardEmptyBuffer = 1
  " let g:Lf_RememberLastSearch = 1
  let g:Lf_UseVersionControlTool = 0

  " 模糊匹配忽略扩展名
  let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.ico', '*.css']
        \ }

  " 忽略最近文件
  let g:Lf_MruWildIgnore = {
        \ 'dir': ['node_modules'],
        \ 'file': []
        \}

  " MRU 文件忽略扩展名
  let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
  let g:Lf_StlColorscheme = 'powerline'

  " 禁用 function/buftag 的预览功能，可以手动用 p 预览
  let g:Lf_PreviewResult = { 'Function': 0, 'BufTag': 0 }

  " 子命令 Leaderf[!] subCommand 下面中的一个参数, !直接进入普通模式
  " bufTag: 当前缓冲区标签,
  " buffer: 项目缓冲文件名,
  " cmdHistory: 命令行历史,
  " colorscheme: 色彩方案,
  " command: 可用命令,
  " file: 项目文件名,
  " filetype: 项目文件类型指定,
  " function: 当前缓冲区函数,
  " gtags: gnu global符号索引,
  " help: 帮助标签,
  " line: 搜索行在缓冲区中,
  " mru: 最近使用的文件,
  " rg: ripgrep 文本搜索,
  " searchHistory: 搜索命令行历史,
  " self: Leaderf自己的命令,
  " tag: 当前项目所有标签,

  " 使用 ESC 键可以直接退出 leaderf 的 normal 模式
  let g:Lf_NormalMap = {
        \ 'BufTag': [['<ESC>', ':exec g:Lf_py "bufTagExplManager.quit()"<cr>']],
        \ 'Buffer': [['<ESC>', ':exec g:Lf_py "bufExplManager.quit()"<cr>']],
        \ 'File':   [['<ESC>', ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
        \ 'Function': [['<ESC>', ':exec g:Lf_py "functionExplManager.quit()"<cr>']],
        \ 'Mru': [['<ESC>', ':exec g:Lf_py "mruExplManager.quit()"<cr>']],
        \ 'Rg': [['<ESC>', ':exec g:Lf_py "rgExplManager.quit()"<cr>']],
        \ 'Self': [['<ESC>', ':exec g:Lf_py "selfExplManager.quit()"<cr>']],
        \ 'Tag': [['<ESC>', ':exec g:Lf_py "tagExplManager.quit()"<cr>']],
        \ }

  " 开启后不能在普通模式中使用搜索/
  let g:Lf_WindowPosition = 'popup'
  let g:Lf_PopupPosition = [0, 0]
  let g:Lf_PreviewInPopup = 1 " 就可以启用这个功能，缺省未启用。
  let g:Lf_PopupWidth = '0.6'
  let g:Lf_PopupHeight = '0.3'

  let g:Lf_PreviewPopupWidth = 60            " 指定 popup window / floating window 的宽度。
  let g:Lf_PopupPreviewPosition = 'top'      " 指定 popup window / floating window 的位置。
  let g:Lf_PreviewHorizontalPosition = 'top' " 指定 popup window / floating window 的位置。

  " gs: global search(全局查找)
  " --hidden 查找以 '.' 开始的文件或目录
  if executable('rg')
    let g:Lf_RgConfig = ["--max-columns=150", "--glob=!node_modules/*"]
    let g:Lf_UseCache = 0
    let g:Lf_UseMemoryCache = 0
    xnoremap gs :<c-u> --hidden<home><c-r>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<cr>
    nnoremap gs :<c-u><c-r>=printf("%s", expand("<cword>"))<cr>\b" --hidden<home>Leaderf! rg -e "\b
  endif
  noremap <leader>or :<C-U>Leaderf! --recall<CR>
endif

"-----------------------------------------------------------------------------
"                                 结束插件安装
"-----------------------------------------------------------------------------
call plug#end()
