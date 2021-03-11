" 禁用 vi 兼容模式
set nocompatible

"-----------------------------------------------------------------------------
"                         在 ~/.vim/bundles 下安装插件
"-----------------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))

" 异步运行并把结果放入quickfix中
Plug 'skywind3000/asyncrun.vim'
Plug 'skywind3000/asynctasks.vim'

let g:asyncrun_rootmarks = ['.git', '.svn', '.root', '.project', '.hg']
let g:asynctasks_term_pos = 'tab'
let g:asyncrun_open = 10
let g:asynctasks_term_rows = 10    " 设置纵向切割时，高度为 10
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_focus = 0
let g:asyncrun_bell =  1
if has('win64') || has('win32')
  let g:asynctasks_term_pos = 'external'
else
  let g:asynctasks_term_pos = 'right'
endif

nnoremap <leader>ar :AsyncRun 
nnoremap <silent> <leader>as :AsyncStop<cr>
nnoremap <silent> <leader>am :AsyncTaskMacro<cr>
nnoremap <silent> <leader>ae :AsyncTaskEdit<cr>
nnoremap <silent> <leader>al :AsyncTaskList<cr>

nnoremap <silent> <leader>5 :AsyncTask file-run<cr>
nnoremap <silent> <leader>6 :AsyncTask project-run<cr>
nnoremap <silent> <leader>7 :AsyncTask project-build<cr>
nnoremap <silent> <leader>8 :AsyncTask file-debug<cr>
nnoremap <silent> <leader>9 :AsyncTask file-build<cr>

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
command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>

" 配对括号和引号自动补全
Plug 'jiangmiao/auto-pairs'

let g:AutoPairsFlyMode            = 0
let g:AutoPairsShortcutBackInsert = '<M-z>'
let g:AutoPairsShortcutToggle     = '<M-a>'
let g:AutoPairsMapCh              = 0
let g:AutoPairsMoveCharacter      = ''
let g:AutoPairsShortcutJump       = ''

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
"      LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
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
  nnoremap <c-n> :LeaderfMruCwd<cr>

  " ALT+n 打开最近使用的文件 MRU，进行模糊匹配
  nnoremap <m-n> :LeaderfMru<cr>

  " ALT+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
  nnoremap <m-f> :LeaderfFunction!<cr>

  " ALT+SHIFT+f 打开函数列表，按 i 进入模糊匹配，ESC 退出
  nnoremap <m-F> :LeaderfFunctionAll!<cr>

  " ALT+t 打开 tag 列表，i 进入模糊匹配，ESC退出
  nnoremap <m-t> :LeaderfBufTag!<cr>

  " 全局 tags 模糊匹配
  nnoremap <m-T> :LeaderfBufTagAll<cr>

  " Leaderf 自己的命令模糊匹配
  nnoremap <m-s> :LeaderfSelf<cr>

  " 最大历史文件保存 2048 个
  let g:Lf_MruMaxFiles = 2048

  " 如何识别项目目录，从当前文件目录向父目录递归知道碰到下面的文件/目录
  let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
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

  " 模糊匹配忽略扩展名
  let g:Lf_WildIgnore = {
        \ 'dir': ['.svn','.git','.hg'],
        \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
        \ }

  " 忽略最近文件
  let g:Lf_MruWildIgnore = {
        \ 'dir': ['node_modules'],
        \ 'file': []
        \ }

  " MRU 文件忽略扩展名
  let g:Lf_MruFileExclude = ['*.so', '*.exe', '*.py[co]', '*.sw?', '~$*', '*.bak', '*.tmp', '*.dll']
  let g:Lf_StlColorscheme = 'powerline'

  " 禁用 function/buftag 的预览功能，可以手动用 p 预览
  let g:Lf_PreviewResult = { 'Function': 0, 'BufTag': 0 }

  " 子命令 Leaderf[!] subCommand 下面中的一个参数, !直接进入普通模式
  "     bufTag: 当前缓冲区标签,
  "     buffer: 项目缓冲文件名,
  "     cmdHistory: 命令行历史,
  "     colorscheme: 色彩方案,
  "     command: 可用命令,
  "     file: 项目文件名,
  "     filetype: 项目文件类型指定,
  "     function: 当前缓冲区函数,
  "     gtags: gnu global符号索引,
  "     help: 帮助标签,
  "     line: 搜索行在缓冲区中,
  "     mru: 最近使用的文件,
  "     rg: ripgrep 文本搜索,
  "     searchHistory: 搜索命令行历史,
  "     self: Leaderf自己的命令,
  "     tag: 当前项目所有标签,

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

  let g:Lf_PreviewPopupWidth = 100 " 指定 popup window / floating window 的宽度。
  let g:Lf_PopupPreviewPosition = 'cursor' " 指定 popup window / floating window 的位置。
  let g:Lf_PreviewHorizontalPosition = 'cursor' " 指定 popup window / floating window 的位置。

  if executable('rg')
    xnoremap gs :<C-U><C-R>=printf("Leaderf! rg -F %s --hidden", leaderf#Rg#visual())<CR><CR>
    nnoremap gs :<C-U> --hidden<home><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR>
  endif
  noremap <leader>gr :<C-U>Leaderf! --recall<CR>

endif

" 提供 ctags/gtags 后台数据库自动更新功能
Plug 'ludovicchabant/vim-gutentags'

" 提供 GscopeFind 命令并自动处理好 gtags 数据库切换
" <leader>cs - 查看光标下符号的引用
" <leader>cg - 查看光标下符号的定义
" <leader>cd - 查看该函数调用了哪些函数
" <leader>cc - 查看有哪些函数调用了该函数
" <leader>ct - 查看光标下字符串
" <leader>ce - 查看光标下正则
" <leader>cf - 查找光标下的文件
" <leader>ci - 查找哪些文件 include 了本文件
" <leader>ca - 查看光标下符号赋值的地方
" <leader>cz - 查看光标下符号分配的位置
Plug 'skywind3000/gutentags_plus'

" 第一个 GTAGSLABEL 告诉 gtags 默认 C/C++/Java 等六种原生支持的代码直接使用
" gtags 本地分析器，而其他语言使用 pygments 模块。
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = expand('~/.gtags.conf')

" 设定项目目录标志：除了 .git/.svn 外，还有 .root 文件
let g:gutentags_project_root = [
      \ '.git',
      \ '.hg',
      \ '.project',
      \ '.root',
      \ '.svn',
      \ 'package.json',
      \ ]

let g:gutentags_exclude_filetypes = ['markdown', 'json', 'css']
let g:gutentags_exclude_project_root = ['/usr/local', '.notags']
" 去除生成标签的文件夹
let g:gutentags_ctags_exclude = ['node_modules', '.cache']

" 指定生成 ctags 的文件, 通过 .gitignore 中的文件，忽略 exclude 配置
if executable('rg')
  let g:gutentags_file_list_command = 'rg --files --color=never'
endif

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 默认生成的数据文件集中到 ~/.cache/tags 避免污染项目目录，好清理
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 默认禁用自动生成
let g:gutentags_modules = []
" 如果有 ctags 可执行就允许动态生成 ctags 文件
if executable('ctags')
  let g:gutentags_modules += ['ctags']
endif
" 如果有 gtags 可执行就允许动态生成 gtags 数据库
if executable('gtags') && executable('gtags-cscope')
  let g:gutentags_modules += ['gtags_cscope']
endif
let g:gutentags_plus_switch = 1

" 设置 ctags 的参数
" let g:gutentags_ctags_extra_args  = ['--fields=+niazSlm', '--extras=+q']
let g:gutentags_ctags_extra_args  = ['--fields=+niazSlm']
let g:gutentags_ctags_extra_args += ['--kinds-c++=+px']
let g:gutentags_ctags_extra_args += ['--kinds-c=+px']

" 使用 universal-ctags 的话需要下面这行，请反注释
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁止 gutentags 自动链接 gtags 数据库
let g:gutentags_auto_add_gtags_cscope = 0

" let g:gutentags_trace = 1
" let g:gutentags_define_advanced_commands = 1

" 提供基于 TAGS 的定义预览，函数参数预览，quickfix 预览
Plug 'skywind3000/vim-preview'

noremap <m-u> :PreviewScroll -1<cr>
noremap <m-i> :PreviewScroll +1<cr>
inoremap <m-u> <c-\><c-o>:PreviewScroll -1<cr>
inoremap <m-i> <c-\><c-o>:PreviewScroll +1<cr>

noremap <m-;> :PreviewTag<cr>
noremap <m-p> :PreviewClose<cr>
noremap <m-,> :PreviewGoto edit<cr>
noremap <m-.> :PreviewGoto tabe<cr>

augroup QuickFixPreview
  autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
  autocmd FileType qf nnoremap <silent><buffer> <m-p> :PreviewClose<cr>
  autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>
  autocmd FileType qf nnoremap <silent><buffer> q <c-w>q
  autocmd FileType qf nnoremap <silent><buffer> o <cr>:cclose<cr>
  autocmd FileType leaderf set nonu
augroup end

Plug 'neoclide/coc.nvim', { 'branch': 'release' }

nnoremap <silent> <leader>q :call asyncrun#quickfix_toggle(g:asyncrun_open)<cr>

"-----------------------------------------------------------------------------
"                                 结束插件安装
"-----------------------------------------------------------------------------
call plug#end()

set relativenumber

" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
" let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide..=',\(^\|\s\s\)\zs\.\S\+'
