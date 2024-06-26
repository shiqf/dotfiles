vim9script
#=============================================================================
#
#                          style.vim - 显示样式设置
#
#   - 显示设置
#   - 颜色主题：色彩文件位于 colors 目录中
#   - 状态栏设置
#   - 更改样式
#   - 游标形状
#
# vim: set ts=2 sw=2 tw=78 et :
#=============================================================================


#-----------------------------------------------------------------------------
#                                   显示设置
#-----------------------------------------------------------------------------
# 总是显示状态栏
set laststatus=2

# 总是显示行号
set number

# " 总是显示侧边栏（用于显示 mark/gitdiff/诊断信息）
# if exists('g:max')
#   set signcolumn=yes
# endif

# 总是显示标签栏
set showtabline=2

# 设置显示制表符等隐藏字符
set list

# 右下角显示命令
set showcmd

# 插入模式在状态栏下面显示 -- INSERT --，
# 先注释掉，默认已经为真了，如果这里再设置一遍会影响 echodoc 插件
set showmode

# 水平切割窗口时，默认在右边显示新窗口
set splitright

# 垂直切割窗口时，默认在下边显示新窗口
set splitbelow

# 不显示计数
set shortmess-=S

#-----------------------------------------------------------------------------
#                     颜色主题：色彩文件位于 colors 目录中
#-----------------------------------------------------------------------------
# 允许 256 色
set t_Co=256

# 设置颜色主题，会在所有 runtimepaths 的 colors 目录寻找同名配置
# colorscheme desert256


# 设置黑色背景
# set background=dark

#-----------------------------------------------------------------------------
#                                  状态栏设置
#-----------------------------------------------------------------------------
set statusline=                                 # 清空状态栏
set statusline+=\ %F                            # 文件名
set statusline+=\ [%1*%M%*%n%R%H]               # buffer 编号和状态
set statusline+=\ %{winnr()}                    # 文件窗口位置
set statusline+=%=                              # 向右对齐
set statusline+=\ %y                            # 文件类型

# 最右边显示文件编码和行号等信息，并且固定在一个 group 中，优先占位
set statusline+=\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %v:%l/%L%)

#-----------------------------------------------------------------------------
#                                   更改样式
#-----------------------------------------------------------------------------
# 更清晰的错误标注：默认一片红色背景，语法高亮都被搞没了
# 只显示红色或者蓝色下划线或者波浪线
hi! clear SpellBad
hi! clear SpellCap
hi! clear SpellRare
hi! clear SpellLocal
if has('gui_running')
  hi! SpellBad gui=undercurl guisp=red
  hi! SpellCap gui=undercurl guisp=blue
  hi! SpellRare gui=undercurl guisp=magenta
  hi! SpellRare gui=undercurl guisp=cyan
else
  hi! SpellBad term=standout ctermfg=1 term=underline cterm=underline
  hi! SpellCap term=underline cterm=underline
  hi! SpellRare term=underline cterm=underline
  hi! SpellLocal term=underline cterm=underline
endif

# 去掉 sign column 的白色背景
hi! SignColumn guibg=NONE ctermbg=NONE

# 修改行号为浅灰色，默认主题的黄色行号很难看，换主题可以仿照修改
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE 
      \ gui=NONE guifg=DarkGrey guibg=NONE

# 修正补全目录的色彩：默认太难看
hi! Pmenu guibg=gray guifg=black ctermbg=gray ctermfg=black
hi! PmenuSel guibg=gray guifg=brown ctermbg=brown ctermfg=gray

#-----------------------------------------------------------------------------
#                                   游标形状
#-----------------------------------------------------------------------------
&t_SI = "\<Esc>[6 q"   # SI = 插入模式
&t_SR = "\<Esc>[4 q"   # SR = 替换模式
&t_EI = "\<Esc>[2 q"   # EI = 普通模式
