" 不兼容 vi
set nocompatible
filetype off

" 插件的存放的根文件夹一律在~/.vim/bundle/下
" pulg管理插件软件开始运行
call plug#begin('~/.vim/bundle')

" vim中文说明文档 ./vimcdoc.sh -i安装
Plug 'yianwillis/vimcdoc'

" 打开关闭折叠效果 za
"  基本文本操作功能的增强 {{{

" 异步命令
Plug 'skywind3000/asyncrun.vim'
" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6
" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                 tpope 插件系列                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" vim 的git版本控制命令包装
Plug 'tpope/vim-fugitive'

" fugitive功能拓展
Plug 'gregsexton/gitv', { 'on': [ 'Gitv' ] }

" 异步实时在左测显示符号状态列
Plug 'mhinz/vim-signify'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                   motion                                   "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'Lokaltog/vim-easymotion'
map <leader> <plug>(easymotion-prefix)
nmap <Leader>s <Plug>(easymotion-overwin-f)

" 模式显示所有匹配项
Plug 'haya14busa/incsearch.vim'
map /  <plug>(incsearch-forward)
map ?  <plug>(incsearch-backward)
" map / <plug>(incsearch-stay)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             支持自定义文本对象                             "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
Plug 'kana/vim-textobj-user'
" 增加行文本对象: l   dal yal cil
Plug 'kana/vim-textobj-line'
" 增加文件文本对象: e   dae yae cie
Plug 'kana/vim-textobj-entire'
" 增加缩进文本对象: i   dai yai cii - 相同缩进属于同一块
Plug 'kana/vim-textobj-indent'
" 高亮文本对象: y day yay ciy
Plug 'kana/vim-textobj-syntax'
" 函数文本对象: f daf yaf cif
Plug 'kana/vim-textobj-function', { 'for': [ 'c', 'cpp', 'vim', 'java' ] }
" 函数参数文本对象: da, ya, ci,
Plug 'sgur/vim-textobj-parameter'
let g:vim_textobj_parameter_mapping = ','
" 正则匹配单词的一部分，提供操作可以用operate + (? or i)/（正则模式类型）
Plug 'kana/vim-textobj-lastpat'

" 可视模式下用 * 号匹配字符串
Plug 'nelstrom/vim-visual-star-search'
" 筛选符合条件的 argslist 文件并保存到 args 中去, 使用 argdo 处理匹配文件
Plug 'nelstrom/vim-qargs'

" }}}

" 异步语法检测、自动补全、标签生成{{{

" YouCompleteme及其他智能补全{{{

Plug 'Valloric/YouCompleteMe', { 'do': 'python3 install.py --all' }
" 触发快捷键设置
let g:ycm_key_list_select_completion   = ['<C-n>']
let g:ycm_key_list_previous_completion = ['<C-p>']
let g:SuperTabDefaultCompletionType    = '<C-n>'
" 不显示load python 提示
let g:ycm_confirm_extra_conf=0
" 通过ycm语法检测显示错误符号和警告符号
let g:ycm_error_symbol   = '✗'
let g:ycm_warning_symbol = '⚠'

" 显示 quickfix 列表和 location 列表
Plug 'Valloric/ListToggle'
let g:lt_location_list_toggle_map = '<leader>l'
let g:lt_quickfix_list_toggle_map = '<leader>q'
let g:lt_height = 10

" 语义的自动补全（函数调用提示），进入该项目文件并通过 npm install 安装
Plug 'ternjs/tern_for_vim', { 'for': 'javascript.jsx', 'do': ':!npm install' }

" }}}

" 语法检测{{{
" 异步语法检测
Plug 'w0rp/ale'
" c 或 c++ 需要指定语法分析工具，否则会显示重复的两条数据
let g:ale_linters = {
            \   'javascript': ['eslint'],
            \   'html': ['tidy'],
            \   'c': ['clang'],
            \   'cpp': ['clang']
            \}
" 错误提示符及警告提示符
let g:ale_sign_error='✗'
let g:ale_sign_warning='⚠'

" }}}

" 标签文件自动生成 {{{
" 需要下载Ctags brew install --HEAD universal-ctags/universal-ctags/universal-ctags
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'

" 第一个 GTAGSLABEL 告诉 gtags 默认 C/C++/Java 等六种原生支持的代码直接使用
" gtags 本地分析器，而其他语言使用 pygments 模块。
let $GTAGSLABEL = 'native-pygments'
let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'
let g:cscopeprg = '/usr/local/bin/gtags-cscope'

" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = [ '.root', '.svn', '.git', '.hg', '.project' ]

" 去除生成标签的文件夹
let g:gutentags_ctags_exclude = [ '*.min.js', '*.min.css', 'build', 'vendor', '.git', '*.vim/bundle/*', '.tmux' ]

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 同时开启 ctags 和 gtags 支持：
let g:gutentags_modules = []
if executable('ctags')
    let g:gutentags_modules += ['ctags']
endif
if executable('gtags-cscope') && executable('gtags')
    let g:gutentags_modules += ['gtags_cscope']
endif

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 如果使用 universal ctags 需要增加下面一行
let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

" 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0

" 用于调试
" let g:gutentags_define_advanced_commands = 1
" let g:gutentags_trace = 1

" }}}

" }}}

" 文件搜索，匹配，定位 {{{

" 快速查查文件，缓存，函数等
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
let g:Lf_ShortcutF = '<nop>'
let g:Lf_ShortcutB = '<nop>'
nnoremap f :LeaderfFile<cr>
nnoremap b :LeaderfBuffer<cr>
nnoremap p :LeaderfFunction<cr>
nnoremap t :LeaderfTag<cr>
nnoremap m :LeaderfMru<cr>

" 内容匹配 Ag 类似grep
Plug 'rking/ag.vim'
let g:ag_prg="/usr/local/bin/ag --vimgrep"
" let g:ag_prg="/usr/local/bin/ag --vimgrep --smart-case"
" 搜索通过项目目录代替当前目录
let g:ag_working_path_mode="r"
let g:ag_highlight=1
let g:ag_format="%f:%l:%m"

" }}}

" 窗口显示管理，美化布置 {{{

" 状态栏效果显示 airline {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1
let g:airline_theme='papercolor'
" }}}

" 目录管理nerdtree{{{
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" 设置显示／隐藏标签列表
nnoremap <leader>8 :NERDTreeToggle<cr>

" nerdtree 插件显示修改状态
Plug 'Xuyuanp/nerdtree-git-plugin'

" }}}

" 界面颜色主题{{{

" dracula{{{
Plug 'dracula/vim', { 'as': 'dracula' }
" }}}

" molokai{{{
Plug 'tomasr/molokai'
let g:molokai_original = 1
let g:rehash256 = 1
" }}}

" gruvbox{{{
Plug 'morhetz/gruvbox'
let g:gruvbox_contrast_light = "hard"
let g:gruvbox_hls_cursor = "red"
" }}}

" }}}

" }}}

" 工具拓展{{{

" 方式对齐 {{{
Plug 'godlygeek/tabular'
let g:taabular_loaded = 1
" }}}

" 读取﹣求值﹣输出循环，交互式顶层构件REPL{{{
Plug 'sillybun/vim-repl', { 'do': './install.sh' }
nnoremap <leader>r :REPLToggle<cr>
let g:sendtorepl_invoke_key = '<leader>o'
" 0表示出现在下方，1表示出现在上方，2在左边，3在右边
let g:repl_position = 3
let g:repl_height = 10
let g:repl_program = {
            \   "python": "python3",
            \   "javascript.jsx": "node",
            \   "java": "jshell",
            \   "default": "bash",
            \   }

let g:repl_exit_commands = {
            \   "python": "exit()",
            \   "bash": "exit",
            \   "zsh": "exit",
            \   "node": ".exit",
            \   "jshell": "/exit",
            \   "default": "exit",
            \   }
" }}}

" go语言支持{{{
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let s:packages = [
            \ "github.com/nsf/gocode",
            \ "code.google.com/p/go.tools/cmd/goimports",
            \ "code.google.com/p/rog-go/exp/cmd/godef",
            \ "code.google.com/p/go.tools/cmd/oracle",
            \ "code.google.com/p/go.tools/cmd/gorename",
            \ "github.com/golang/lint/golint",
            \ "github.com/kisielk/errcheck",
            \ "github.com/jstemmer/gotags",
            \ ]
" }}}

" emmet高速编写网页类代码 {{{
Plug 'mattn/emmet-vim'
let g:emmet_html5 = 1

" 帮助emmet显示snippets提示
Plug 'jceb/emmet.snippets'
" }}}

" snippets 片段扩展 {{{
" 通过 VimL 语言的支持
Plug 'honza/vim-snippets'
" 需要通过 Python 的支持
Plug 'SirVer/ultisnips'
let g:UltiSnipsSnippetDirectories  = ["UltiSnips"]
let g:UltiSnipsSnippetsDir         = ["mysnips"] " '~/.vim/bundle/ultisnips/mysnips'
let g:UltiSnipsExpandTrigger       = "<Tab>"
let g:UltiSnipsListSnippets        = '<C-Tab>'
let g:UltiSnipsJumpForwardTrigger  = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" }}}

" " makrdown{{{
" Plug 'iamcco/mathjax-support-for-mkdp', { 'for': 'markdown' }
" Plug 'iamcco/markdown-preview.vim', { 'for': 'markdown', 'on': 'MarkdownPreview' }
" let g:mkdp_path_to_chrome = "open -a Google\\ Chrome"
" " or
" let g:mkdp_path_to_chrome = "/Applications/Google\\ Chrome.app/Contents/MacOS/Google\\ Chrome"
" " }}}

" plantuml{{{
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
" }}}

" }}}

" 绝大多数语言语法高亮支持及括号配对{{{

" 彩虹括号 利用区分括号配对
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1

Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['go']

" }}}

call plug#end()

filetype plugin indent on
