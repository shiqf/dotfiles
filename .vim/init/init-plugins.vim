"=============================================================================
"
"                              init-plugins.vim
"
"                     默认情况下的分组，可以再前面覆盖之
"                         计算当前 vim-init 的子路径
"                        在 ~/.vim/bundles 下安装插件
"
"   - 基础插件
"   - 增强插件
"   - 文本对象：textobj 全家桶
"   - 文件类型扩展
"   - themes
"   - NERDTree
"   - 自动生成 ctags/gtags，并提供自动索引功能
"   - ale：动态语法检查
"   - LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
"   - ycm 基于语义的自动补全
"   - 代码片段拓展
"
" vim: set ts=4 sw=4 tw=78 noet :
"=============================================================================


"-----------------------------------------------------------------------------
"                     默认情况下的分组，可以再前面覆盖之
"-----------------------------------------------------------------------------
if !exists('g:bundle_group')
    let g:bundle_group  = ['basic', 'enhanced', 'textobj', 'filetypes']
    " tags 标签、文件快速导航、智能补全、语法检测、代码片段
    let g:bundle_group += ['tags', 'leaderf', 'ycm', 'ale', 'snippets']
    " 状态栏、目录
    let g:bundle_group += ['themes', 'nerdtree']
    " 工具、调试、markdown
    let g:bundle_group += ['tool', 'debug', 'markdown']
endif


"-----------------------------------------------------------------------------
"                          计算当前 vim-init 的子路径
"-----------------------------------------------------------------------------
let s:home = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
function! s:path(path)
    let path = expand(s:home .. '/' .. a:path )
    return substitute(path, '\\', '/', 'g')
endfunc


"-----------------------------------------------------------------------------
"                         在 ~/.vim/bundles 下安装插件
"-----------------------------------------------------------------------------
call plug#begin(get(g:, 'bundle_home', s:home .. '/bundles'))

" " vim 中文说明文档 ./vimcdoc.sh -i安装
Plug 'yianwillis/vimcdoc', { 'do': './vimcdoc.sh -i' }
" Plug 'yianwillis/vimcfaq'

"-----------------------------------------------------------------------------
"                                   基础插件
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'basic') >= 0
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

    " 多单词[多文件]查询、代替、缩写
    Plug 'tpope/vim-abolish'

    " 支持 fugitive 的Gbrowse 功能
    " Plug 'tpope/vim-rhubarb'
    " Git 支持
    Plug 'tpope/vim-fugitive'
    command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
    nnoremap <silent> <leader>gp :G log --oneline --decorate --graph --all<cr>

endif


"-----------------------------------------------------------------------------
"                                   增强插件
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'enhanced') >= 0
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

    noremap <leader>ar :AsyncRun 
    nnoremap <silent> <leader>as :AsyncStop<cr>
    nnoremap <silent> <leader>am :AsyncTaskMacro<cr>
    nnoremap <silent> <leader>ae :AsyncTaskEdit<cr>
    nnoremap <silent> <leader>al :AsyncTaskList<cr>

    nnoremap <silent> <leader>5 :AsyncTask file-run<cr>
    nnoremap <silent> <leader>6 :AsyncTask project-run<cr>
    nnoremap <silent> <leader>7 :AsyncTask project-build<cr>
    nnoremap <silent> <leader>8 :AsyncTask file-debug<cr>
    nnoremap <silent> <leader>9 :AsyncTask file-build<cr>

    " 全文快速移动, <leader>f{char} 即可触发
    Plug 'easymotion/vim-easymotion', { 'on': [
                \    '<plug>(easymotion-overwin-f)',
                \    '<plug>(easymotion-f)',
                \    '<plug>(easymotion-F)',
                \    '<plug>(easymotion-j)',
                \    '<plug>(easymotion-k)',
                \   ]
                \ }
    map <leader>s <plug>(easymotion-overwin-f)
    map <leader>f <plug>(easymotion-f)
    map <leader>F <plug>(easymotion-F)
    map <leader>j <plug>(easymotion-j)
    map <leader>k <plug>(easymotion-k)
    " 忽略大小写
    let g:EasyMotion_smartcase = 1

    " 配对括号和引号自动补全
    Plug 'jiangmiao/auto-pairs', {
                \ 'for': [ 'c', 'cpp', 'java', 'javascript', 'json',
                \     'make', 'python', 'snippets', 'typescript', 'vim' ]
                \ }

    let g:AutoPairsFlyMode            = 0
    let g:AutoPairsShortcutBackInsert = '<M-z>'
    let g:AutoPairsShortcutToggle     = '<M-a>'
    let g:AutoPairsMapCh              = 0
    let g:AutoPairsMoveCharacter      = ''
    let g:AutoPairsShortcutJump       = ''

    " 交换选定范围
    Plug 'tommcdo/vim-exchange'
    let g:exchange_no_mappings=1
    nmap co <Plug>(Exchange)
    vmap x <Plug>(Exchange)
    nmap coc <Plug>(ExchangeClear)
    nmap coo <Plug>(ExchangeLine)

    " 展示开始画面，显示最近编辑过的文件
    Plug 'mhinz/vim-startify'

    " 默认不显示 startify
    let g:startify_disable_at_vimenter    = 0
    let g:startify_session_dir            = '~/.vim/session'
    let g:startify_session_persistence    = 1
    let g:startify_session_delete_buffers = 1
    let g:startify_session_autoload       = 0
    let g:startify_change_to_dir          = 1
    let g:startify_bookmarks              = [
                \   {'v': '~/.vimrc'},
                \   {'z': '~/.zshrc'},
                \ ]

    " 用于在侧边符号栏显示 git/svn 的 diff
    Plug 'mhinz/vim-signify'

    " signify 调优
    let g:signify_vcs_list               = ['git', 'svn']
    let g:signify_sign_add               = '+'
    let g:signify_sign_delete            = '_'
    let g:signify_sign_delete_first_line = '-'
    let g:signify_sign_change            = '~'
    let g:signify_sign_changedelete      = g:signify_sign_change

    " git 仓库使用 histogram 算法进行 diff
    let g:signify_vcs_cmds = {
                \ 'git': 'git diff --no-color --diff-algorithm=histogram --no-ext-diff -U0 -- %f',
                \}

    " 给不同语言提供字典补全，插入模式下 c-x c-k 触发
    Plug 'asins/vim-dict'
    let g:vim_dict_config = {
                \ 'html': ['css', 'javascript'],
                \}

    " " 使用 :CtrlSF 命令进行模仿 sublime 的 grep
    " Plug 'dyng/ctrlsf.vim'

    " " 提供 gist 接口
    " Plug 'lambdalisue/vim-gista', { 'on': 'Gista' }
endif


"-----------------------------------------------------------------------------
"                           文本对象：textobj 全家桶
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'textobj') >= 0

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

    " 函数文本对象：if/af 支持 c/c++/vim/java
    Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }

    " " 提供 python 相关文本对象，if/af 表示函数，ic/ac 表示类
    " Plug 'bps/vim-textobj-python', { 'for': 'python' }
    " let g:textobj_python_no_default_key_mappings = 1

    " " 语法文本对象：iy/ay 基于语法的文本对象
    " Plug 'kana/vim-textobj-syntax'

    " 提供 uri/url 的文本对象，iu/au 表示
    " Plug 'jceb/vim-textobj-uri'
endif


"-----------------------------------------------------------------------------
"                                 文件类型扩展
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'filetypes') >= 0

    " 额外语法文件
    Plug 'justinmk/vim-syntax-extra', { 'for': ['bison', 'c', 'cpp', 'flex'] }

    " C++ 语法高亮增强，支持 11/14/17 标准
    Plug 'octol/vim-cpp-enhanced-highlight', { 'for': ['c', 'cpp'] }

    " python 语法文件增强
    Plug 'vim-python/python-syntax', { 'for': ['python'] }

    " " typescript 语法文件增强
    " Plug 'leafgarland/typescript-vim', { 'for': ['typescript'] }

    " powershell 脚本文件的语法高亮
    " Plug 'pprovost/vim-ps1', { 'for': 'ps1' }

    " lua 语法高亮增强
    " Plug 'tbastos/vim-lua', { 'for': 'lua' }

    " rust 语法增强
    " Plug 'rust-lang/rust.vim', { 'for': 'rust' }
endif


"-----------------------------------------------------------------------------
"                                    themes
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'themes') >= 0
    " 一次性安装一大堆 colorscheme
    Plug 'flazz/vim-colorschemes'

    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    let g:airline_left_sep                        = ''
    let g:airline_left_alt_sep                    = ''
    let g:airline_right_sep                       = ''
    let g:airline_right_alt_sep                   = ''
    let g:airline_powerline_fonts                 = 1
    let g:airline_exclude_preview                 = 1
    let g:airline_section_b                       = '%n'
    let g:airline_theme                           = 'deus'
    let g:airline#extensions#branch#enabled       = 0
    let g:airline#extensions#syntastic#enabled    = 0
    let g:airline#extensions#fugitiveline#enabled = 0
    let g:airline#extensions#csv#enabled          = 0
    let g:airline#extensions#vimagit#enabled      = 0
endif


"-----------------------------------------------------------------------------
"                                   NERDTree
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'nerdtree') >= 0
    Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
    Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    let g:NERDTreeMinimalUI = 1
    let g:NERDTreeDirArrows = 1
    let g:NERDTreeHijackNetrw = 0
    noremap <leader>nt :NERDTreeToggle<cr>
endif


"-----------------------------------------------------------------------------
"                   自动生成 ctags/gtags，并提供自动索引功能
"-----------------------------------------------------------------------------
" 不在 git/svn 内的项目，需要在项目根目录 touch 一个空的 .root 文件
" 详细用法见：https://zhuanlan.zhihu.com/p/36279445
if index(g:bundle_group, 'tags') >= 0

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

    let g:gutentags_exclude_filetypes = ['startify']

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
endif


"-----------------------------------------------------------------------------
"                        ale：动态语法检查
"-----------------------------------------------------------------------------
if index(g:bundle_group, 'ale') >= 0
    Plug 'dense-analysis/ale'

    " 设定延迟和提示信息
    let g:ale_completion_delay = 500
    let g:ale_echo_delay = 20
    let g:ale_lint_delay = 500
    let g:ale_echo_msg_format = '[%linter%] %code: %%s'

    " 设定检测的时机：normal 模式文字改变，或者离开 insert模式
    " 禁用默认 INSERT 模式下改变文字也触发的设置，太频繁外，还会让补全窗闪烁
    let g:ale_lint_on_text_changed = 'normal'
    let g:ale_lint_on_insert_leave = 1

    " 在 linux/mac 下降低语法检查程序的进程优先级（不要卡到前台进程）
    if has('win32') == 0 && has('win64') == 0 && has('win32unix') == 0
        let g:ale_command_wrapper = 'nice -n5'
    endif

    " 允许 airline 集成
    let g:airline#extensions#ale#enabled = 1

    " 编辑不同文件类型需要的语法检查器
    let g:ale_linters = {
                \ 'bash': ['shellcheck'],
                \ 'c': ['gcc'],
                \ 'cpp': ['gcc'],
                \ 'go': ['go build', 'gofmt'],
                \ 'java': ['javac'],
                \ 'javascript': ['eslint'],
                \ 'lua': ['luac'],
                \ 'python': ['flake8', 'pylint'],
                \ 'typescript': ['eslint', 'tslint'],
                \ }


    " 获取 pylint, flake8 的配置文件，在 init/tools/conf 下面
    function s:lintcfg(name)
        let conf = s:path('tools/conf/')
        let path1 = conf .. a:name
        let path2 = expand('~/.vim/linter/' .. a:name)
        if filereadable(path2)
            return path2
        endif
        return shellescape(filereadable(path2) ? path2 : path1)
    endfunc

    " 设置 flake8/pylint 的参数
    let g:ale_python_flake8_options  = '--conf=' .. s:lintcfg('flake8.conf')
    let g:ale_python_pylint_options  = '--rcfile=' .. s:lintcfg('pylint.conf')
    let g:ale_python_pylint_options ..= ' --disable=W'
    let g:ale_c_gcc_options          = '-Wall -O2 -std=c11'
    let g:ale_cpp_gcc_options        = '-Wall -O2 -std=c++14'
    let g:ale_c_cppcheck_options     = ''
    let g:ale_cpp_cppcheck_options   = ''

    let g:ale_linters.text = ['textlint', 'write-good', 'languagetool']

    " 如果没有 gcc 只有 clang 时（FreeBSD）
    if executable('clang') && executable('gcc') == 0
        let g:ale_linters.c   += ['clang', 'cppcheck']
        let g:ale_linters.cpp += ['clang', 'cppcheck']
    endif

    " 错误提示符及警告提示符
    let g:ale_sign_error='x'
    let g:ale_sign_warning='^'
endif


if has('python3')
    "-------------------------------------------------------------------------
    " LeaderF：CtrlP / FZF 的超级代替者，文件模糊匹配，tags/函数名 选择
    "-------------------------------------------------------------------------
    if index(g:bundle_group, 'leaderf') >= 0
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
        nnoremap <m-F> :LeaderfFunctionAll<cr>

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

        " let g:Lf_UseVersionControlTool = 0
        " 模糊匹配忽略扩展名
        let g:Lf_WildIgnore = {
                    \ 'dir': ['.svn','.git','.hg'],
                    \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.ico']
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

        let g:Lf_PreviewPopupWidth = 60            " 指定 popup window / floating window 的宽度。
        let g:Lf_PopupPreviewPosition = 'top'      " 指定 popup window / floating window 的位置。
        let g:Lf_PreviewHorizontalPosition = 'top' " 指定 popup window / floating window 的位置。

        " gs: global search(全局查找)
        " --hidden 查找以 '.' 开始的文件或目录
        if executable('rg')
            xnoremap gs :<C-U><C-R>=printf("Leaderf! rg -F %s", leaderf#Rg#visual())<CR><CR>
            nnoremap gs :<C-U> --hidden<home><C-R>=printf("Leaderf! rg -F %s", expand("<cword>"))<CR>
        endif
        noremap <leader>nr :<C-U>Leaderf! --recall<CR>

        Plug 'skywind3000/leaderf-snippet'
        inoremap <c-x><c-j> <c-\><c-o>:Leaderf snippet<cr>
        let g:Lf_PreviewResult.snippet = 1

    endif


    "-------------------------------------------------------------------------
    "                          ycm 基于语义的自动补全
    "-------------------------------------------------------------------------
    if index(g:bundle_group, 'ycm') >= 0
        " 显示 quickfix 列表和 location 列表
        Plug 'Valloric/ListToggle'
        let g:lt_location_list_toggle_map = '<leader>l'
        let g:lt_quickfix_list_toggle_map = '<leader>q'
        let g:lt_height = 10

        if has('win64') || has('win32')
            Plug 'ycm-core/YouCompleteMe', { 'do': 'python install.py --clangd-completer --ts-completer' }
        else
            Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer --ts-completer --java-completer' }
        endif

        let g:ycm_max_diagnostics_to_display = 0

        " 触发快捷键设置
        let g:ycm_key_list_select_completion   = ['<c-n>']
        let g:ycm_key_list_previous_completion = ['<c-p>']
        let g:ycm_key_list_stop_completion = ['<c-s>']
        let g:ycm_key_invoke_completion = '<c-z>'
        " 当用户的光标位于诊断行上时用于显示完整诊断文本。默认 <leader>d
        let g:ycm_key_detailed_diagnostics = '<leader>d'

        if has('nvim')
            set completeopt+=preview
            " 禁用预览功能：扰乱视听 默认 0 为禁用
            let g:ycm_add_preview_to_completeopt = 0
            let g:ycm_autoclose_preview_window_after_completion = 1
        else
            set completeopt+=popup
        endif

        let g:ycm_server_log_level = 'info'
        " 禁用诊断功能：我们用前面更好用的 ALE 代替, 默认 0
        let g:ycm_show_diagnostics_ui = 0
        let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
        " 不显示load python 提示
        let g:ycm_confirm_extra_conf=0
        " 通过ycm语法检测显示错误符号和警告符号
        " let g:ycm_error_symbol   = '✗'
        " let g:ycm_warning_symbol = '⚠'
        let g:ycm_always_populate_location_list = 1

        " 打开 ultisnipes, 默认 1
        " let g:ycm_use_ultisnips_completer = 0
        " 输入最少字符开启字符补全功能 默认 2
        " let g:ycm_min_num_of_chars_for_completion = 2
        " 显示字符候选标识符最少的字符数 默认 0
        let g:ycm_min_num_identifier_candidate_chars = 4
        " 最大语义补全符数量 默认 50
        " let g:ycm_max_num_candidates = 50
        " 最大标识符数量 默认 10
        let g:ycm_max_num_identifier_candidates = 5
        " 设置为 0 时，不再触发语义补全
        " let g:ycm_auto_trigger = 1
        " c 语言中的 #include 会自动补全文件
        let g:ycm_complete_in_strings=1
        " 设置为 1 时，补全标识符信息会从注释中获取 默认为 0
        " let g:ycm_collect_identifiers_from_comments_and_strings = 1
        " 当此选项设置为1时，YCM的标识符完成器还将从标记文件中收集标识符
        let g:ycm_collect_identifiers_from_tags_files = 1

        " 两个字符自动触发语义补全
        let g:ycm_semantic_triggers = {
                    \ 'c,cpp': ['re!\w{2}'],
                    \ 'python,java,go,erlang,perl,cs,lua': ['re!\w{2}'],
                    \ 'javascript,typescript': ['re!([A-Z]\w|\w[A-Z]|\w{2}[A-Z]|\w{4})'],
                    \ }

        " 关闭相关文件类型的语义补全
        let g:ycm_filetype_specific_completion_to_disable = {
                    \ 'gitcommit': 1
                    \}

        "---------------------------------------------------------------------
        " Ycm 白名单（非名单内文件不启用 YCM），避免打开个 1MB 的 txt 分析半天
        "---------------------------------------------------------------------
        let g:ycm_filetype_whitelist = {
                    \ 'asciidoc': 1,
                    \ 'asm': 1,
                    \ 'asm68k': 1,
                    \ 'asmh8300': 1,
                    \ 'bash': 1,
                    \ 'basic': 1,
                    \ 'c': 1,
                    \ 'cmake': 1,
                    \ 'coffee': 1,
                    \ 'conf': 1,
                    \ 'config': 1,
                    \ 'cpp': 1,
                    \ 'cs': 1,
                    \ 'cson': 1,
                    \ 'css': 1,
                    \ 'dosini': 1,
                    \ 'erlang': 1,
                    \ 'go': 1,
                    \ 'haskell': 1,
                    \ 'html': 1,
                    \ 'java': 1,
                    \ 'javascript': 1,
                    \ 'json': 1,
                    \ 'less': 1,
                    \ 'lhaskell': 1,
                    \ 'lisp': 1,
                    \ 'lua': 1,
                    \ 'make': 1,
                    \ 'man': 1,
                    \ 'markdown': 1,
                    \ 'masm': 1,
                    \ 'matlab': 1,
                    \ 'maxima': 1,
                    \ 'nasm': 1,
                    \ 'objc': 1,
                    \ 'objcpp': 1,
                    \ 'perl': 1,
                    \ 'perl6': 1,
                    \ 'php': 1,
                    \ 'ps1': 1,
                    \ 'python': 1,
                    \ 'ruby': 1,
                    \ 'rust': 1,
                    \ 'scheme': 1,
                    \ 'sdl': 1,
                    \ 'sh': 1,
                    \ 'tasm': 1,
                    \ 'typescript': 1,
                    \ 'vb': 1,
                    \ 'vim': 1,
                    \ 'zimbu': 1,
                    \ 'zsh': 1,
                    \ }

        let g:ycm_auto_hover = ''
        let s:ycm_hover_popup = -1
        function s:Hover()
            let response = youcompleteme#GetCommandResponse( 'GetDoc' )
            if response == ''
                return
            endif
            call popup_hide( s:ycm_hover_popup )
            let s:ycm_hover_popup = popup_atcursor( balloon_split( response ), {} )
        endfunction

        augroup ycmFileTypeMap
            autocmd!

            autocmd FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,rust,typescript
                        \ nnoremap gd :YcmCompleter GoTo<CR>

            " 重构后的结果会加入到 quickfix 中，方便查看修改
            autocmd FileType c,cpp,objc,objcpp,cuda,java,javascript,typescript,rust,cs
                        \ nnoremap gcr :YcmCompleter RefactorRename 

            autocmd FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,rust,typescript
                        \ nnoremap gcs :YcmCompleter RestartServer<CR>

            autocmd FileType c,cpp,objc,objcpp,cuda,java,javascript,go,typescript,rust,cs
                        \ nnoremap gcf :YcmCompleter Format<CR>

            autocmd FileType c,cpp,objc,objcpp,cuda,java,javascript,go,python,typescript,rust
                        \ nnoremap gct :YcmCompleter GetType<CR>

            autocmd FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,python,typescript,rust
                        \ nnoremap <silent>gcd :call <SID>Hover()<CR>

            autocmd FileType java,javascript,typescript
                        \ nnoremap gco :YcmCompleter OrganizeImports<CR>

            autocmd FileType c,cpp,objc,objcpp,cuda,cs,go,java,javascript,rust,typescript
                        \ nnoremap gcx :YcmCompleter FixIt<CR>
        augroup end
    endif


    "-------------------------------------------------------------------------
    "                        代码片段拓展
    "-------------------------------------------------------------------------
    if index(g:bundle_group, 'snippets') >= 0
        " snippets 片段扩展, 需要通过 Python 的支持
        Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
        let g:UltiSnipsSnippetDirectories  = ['UltiSnips', 'mysnippets']
        let g:UltiSnipsEnableSnipMate = 0
        let g:UltiSnipsExpandTrigger       = '<tab>'
        let g:UltiSnipsJumpForwardTrigger  = '<c-j>'
        let g:UltiSnipsJumpBackwardTrigger = '<c-k>'
        let g:UltiSnipsListSnippets        = '<c-l>'
        let g:UltiSnipsEditSplit           = 'vertical'
        nnoremap <leader>ns :snippets<home>UltiSnipsAddFiletypes 

    endif


    if index(g:bundle_group, 'debug') >= 0
        if has('win64') || has('win32')
            Plug 'puremourning/vimspector', {'do': 'python install_gadget.py --all --force-enable-node --disable-tcl --update-gadget-config'}
        else
            Plug 'puremourning/vimspector', {'do': 'python3 install_gadget.py --all --force-enable-node --disable-tcl --update-gadget-config'}
        endif
        let g:vimspector_enable_mappings = 'HUMAN'
    endif
endif


if index(g:bundle_group, 'tool') >= 0
    " emmet高速编写网页类代码
    Plug 'mattn/emmet-vim', { 'for': ['html', 'css', 'jsx'] }
    let g:emmet_html5 = 1

    " 帮助emmet显示snippets提示
    Plug 'jceb/emmet.snippets', { 'for': ['html'] }

    Plug 'sillybun/vim-repl'
    let g:repl_program = {
                \   'python': 'python3',
                \   'javascript': 'node',
                \   'typescript': 'ts-node',
                \   'r': 'R',
                \   'lua': 'lua',
                \   'default': 'zsh',
                \   }

    let g:repl_exit_commands = {
                \   'python': 'quit()',
                \   'bash': 'exit',
                \   'zsh': 'exit',
                \   'node': '.exit',
                \   'ts-node': '.exit',
                \   'jshell': '/exit',
                \   'default': 'exit',
                \   }

    let g:repl_predefine_python = {
                \   'numpy': 'import numpy as np',
                \   'matplotlib': 'from matplotlib import pyplot as plt'
                \   }
    let g:repl_cursor_down = 1
    let g:repl_python_automerge = 1
    let g:repl_ipython_version = '7'
    nnoremap <leader>nl :REPLToggle<Cr>
    let g:repl_position = 3
    let g:repl_stayatrepl_when_open = 0

    Plug 'mbbill/undotree'
    nnoremap <silent> <leader>nu :UndotreeToggle<CR>
    if has("persistent_undo")
        set undodir=$HOME."/.undodir"
        set undofile
    endif

    " 对齐
    Plug 'godlygeek/tabular'

    " tmux 相关
    if exists('$TMUX')
        " tmux 中使用vim 复制
        Plug 'roxma/vim-tmux-clipboard'

        Plug 'benmills/vimux'
        function! s:run_tmux(opts)
            let cwd = getcwd()
            call VimuxRunCommand('cd ' .. shellescape(cwd) .. '; ' .. a:opts.cmd)
        endfunction

        let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
        let g:asyncrun_runner.tmux = function('s:run_tmux')

        nnoremap <leader>vp :VimuxPromptCommand<cr>
        nnoremap <leader>vl :VimuxRunLastCommand<cr>
        nnoremap <leader>vi :VimuxInspectRunner<cr><
        nnoremap <leader>vz :VimuxZoomRunner<cr>

        " Plug 'christoomey/vim-tmux-navigator'
        " let g:tmux_navigator_no_mappings = 1
        " nnoremap <silent> <m-h> :TmuxNavigateLeft<cr>
        " nnoremap <silent> <m-j> :TmuxNavigateDown<cr>
        " nnoremap <silent> <m-k> :TmuxNavigateUp<cr>
        " nnoremap <silent> <m-l> :TmuxNavigateRight<cr>
        " nnoremap <silent> <m-\> :TmuxNavigatePrevious<cr>
    endif

    " " 预览命令行命令效果
    " Plug 'markonm/traces.vim'

    " 彩虹括号 利用区分括号配对
    Plug 'luochen1990/rainbow'
    let g:rainbow_active = 1

    Plug 'voldikss/vim-translator', { 'on': ['<Plug>TranslateW', '<Plug>TranslateWV'] }
    nmap <c-k> <Plug>TranslateW
    vmap <c-k> <Plug>TranslateWV

    Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
    nnoremap <leader>, :<c-u>'<home>WhichKey '

    Plug 'liuchengxu/vista.vim'
    nnoremap <leader>nv :Vista!!<cr>

    " Plug 'jceb/vim-orgmode'
endif


if index(g:bundle_group, 'markdown') >= 0
    Plug 'mzlogin/vim-markdown-toc', { 'for': [ 'markdown' ] }
    let g:vmt_auto_update_on_save = 1
    let g:vmt_cycle_list_item_markers = 1
    Plug 'plasticboy/vim-markdown', { 'for': [ 'markdown' ] }
    Plug 'iamcco/markdown-preview.nvim', {
                \ 'do': 'cd app & yarn install --registry=https://registry.npm.taobao.org',
                \ 'for': [ 'markdown' ]
                \ }
    let g:vim_markdown_math = 1
    let g:mkdp_preview_options = {
                \ 'mkit': {},
                \ 'katex': {},
                \ 'uml': {},
                \ 'maid': {},
                \ 'disable_sync_scroll': 0,
                \ 'sync_scroll_type': 'middle',
                \ 'hide_yaml_meta': 1,
                \ 'sequence_diagrams': {},
                \ 'flowchart_diagrams': {}
                \ }
endif

"-----------------------------------------------------------------------------
"                                 结束插件安装
"-----------------------------------------------------------------------------
call plug#end()
