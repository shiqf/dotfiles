"=============================================================================
"
"             basic.vim - 基础配置，该配置需要兼容 vim tiny 模式
"
"             所有人都能接受的配置，不掺渣任何 keymap, 和偏好设置
"
"   - 基础设置
"   - 搜索设置
"   - 编码设置
"   - 允许 Vim 自带脚本根据文件类型自动设置缩进等
"   - 语法高亮设置
"   - 其他设置
"   - 设置代码折叠
"   - 设置鼠标功能
"   - 文件搜索和补全时忽略下面扩展名
"
" vim: set ts=2 sw=2 tw=78 et :
"=============================================================================


"-----------------------------------------------------------------------------
"                                   基础设置
"-----------------------------------------------------------------------------
" 禁用 vi 兼容模式
set nocompatible

" 补全内容选项 help complete
set complete=.,w,t

set viminfo^=!

" 禁用声音
" set visualbell t_vb=

" 设置 Backspace 键模式
if !has('nvim') && has("patch-8.2.0590")
  set backspace=3
else
  set backspace=2
endif

" 自动缩进
set autoindent

" 打开 C/C++ 语言缩进优化
" set cindent

" 关闭自动换行
set nowrap

" 显示光标位置
set ruler

" 命令行历史记录数
set history=200

" 增减去除八进制
set nrformats-=octal

" 在插入,替换,选择可以移动到下一行
set whichwrap+=<,>,[,]

"-----------------------------------------------------------------------------
"                                   搜索设置
"-----------------------------------------------------------------------------
" 搜索时忽略大小写
set ignorecase

" 智能搜索大小写判断，默认忽略大小写，除非搜索内容包含大写字母
set smartcase

" 开启高亮搜索内容, 通 <c-l> 消除高亮 ( 做了映射 )
set hlsearch

" 查找输入时动态增量显示查找结果
set incsearch

"-----------------------------------------------------------------------------
"                                   编码设置
"-----------------------------------------------------------------------------
if has('multi_byte')
  " 内部工作编码
  set encoding=utf-8

  " 文件默认编码
  set fileencoding=utf-8

  " 打开文件时自动尝试下面顺序的编码
  set fileencodings=ucs-bom,utf-8,gbk,gb18030,big5,euc-jp,euc-kr,latin1
endif


"-----------------------------------------------------------------------------
"                 允许 Vim 自带脚本根据文件类型自动设置缩进等
"-----------------------------------------------------------------------------
if 1
  filetype plugin indent on
endif


"-----------------------------------------------------------------------------
"                                 语法高亮设置
"-----------------------------------------------------------------------------
if !exists("g:syntax_on")
  syntax enable
endif


"-----------------------------------------------------------------------------
"                                   其他设置
"-----------------------------------------------------------------------------
" 显示匹配的括号
set showmatch

" 显示括号匹配的时间
set matchtime=2

" 显示最后一行
set display=lastline

" 延迟绘制（提升性能）
set lazyredraw

" 错误格式
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m

" 设置分隔符可视
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<

" 设置 tags：当前文件所在目录往上向根目录搜索直到碰到 .tags 文件
" 或者 Vim 当前目录包含 .tags 文件
set tags=./.tags;,.tags,tags

" 如遇Unicode值大于255的文本，不必等到空格再折行
" 合并两行中文时，不在中间加空格
set formatoptions+=mB

" fileformats 文件换行符，默认使用 unix 换行符
set fileformats=unix,dos,mac

" 使文件在修改后（不保存），能够使用命令在缓存文件之间跳转
set hidden

"-----------------------------------------------------------------------------
"                                 设置代码折叠
"-----------------------------------------------------------------------------
if has('folding')
  " 允许代码折叠
  set foldenable

  " 代码折叠默认使用缩进
  set foldmethod=indent

  " 默认打开所有缩进
  set foldlevel=99
endif


"-----------------------------------------------------------------------------
"                                 设置鼠标功能
"-----------------------------------------------------------------------------
if has('mouse')
  if &term =~ 'xterm'
    set mouse=a
  else
    set mouse=nvi
  endif
endif

"-----------------------------------------------------------------------------
"                                 比较模式配置
"-----------------------------------------------------------------------------
if has("patch-8.1.0360")
    set diffopt+=internal,algorithm:histogram
endif

"-----------------------------------------------------------------------------
"                        文件搜索和补全时忽略下面扩展名
"-----------------------------------------------------------------------------
set suffixes=.bak,~,.o,.h,.info,.swp,.obj,.pyc,.pyo,.egg-info,.class " 临时文件

" set wildignore=*.bak,*.info,*.egg-info,*.tmp " 临时文件
set wildignore=*.o,*.obj,*~,*.exe,*.a,*.pdb,*.lib,cscope.* " 补全时忽略
set wildignore+=*.so,*.dll,*.swp,*.egg,*.jar,*.class,*.pyc,*.pyo,*.bin,*.dex,*.min.* " 编译文件
set wildignore+=*.zip,*.7z,*.rar,*.gz,*.tar,*.gzip,*.bz2,*.tgz,*.xz " MacOSX/Linux 压缩文件
set wildignore+=*DS_Store*,*.ipch
set wildignore+=*.gem
set wildignore+=*.png,*.jpg,*.gif,*.bmp,*.tga,*.pcx,*.ppm,*.img,*.iso,*.svg,*.ico
set wildignore+=*.so,*.swp,*.zip,*/.Trash/**,*.pdf,*.dmg,*/.rbenv/**
set wildignore+=*/.nx/**,*.app,*.git,.git
set wildignore+=*.wav,*.mp3,*.ogg,*.pcm
set wildignore+=*.mht,*.suo,*.sdf,*.jnlp
set wildignore+=*.chm,*.epub,*.pdf,*.mobi,*.ttf
set wildignore+=*.mp4,*.avi,*.flv,*.mov,*.mkv,*.swf,*.swc
set wildignore+=*.ppt,*.pptx,*.docx,*.xlt,*.xls,*.xlsx,*.odt,*.wps
set wildignore+=*.msi,*.crx,*.deb,*.vfd,*.apk,*.ipa,*.msu
set wildignore+=*.gba,*.sfc,*.078,*.nds,*.smd,*.smc
set wildignore+=*.linux2,*.win32,*.darwin,*.freebsd,*.linux,*.android
set wildignore+=*/.git/**/*,*/.hg/**/*,*/.svn/**/* " 版本控制文件
set wildignore+=*.sln,*.Master,*.csproj,*.csproj.user,*.cache

" javascritp/typescript 忽略
set wildignore+=*sites/*/files/*,*.flac,*.less,*.map,*.scss,*.swo
