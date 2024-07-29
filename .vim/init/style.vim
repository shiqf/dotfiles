vim9script
#=============================================================================
#
#                          style.vim - 显示样式设置
#
#   - 显示设置
#   - 颜色主题：色彩文件位于 colors 目录中
#   - 状态栏设置
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

# 命令行使用插入模式的䃼全样式
set wildmenu wildoptions=pum,fuzzy pumheight=10

#-----------------------------------------------------------------------------
#                     颜色主题：色彩文件位于 colors 目录中
#-----------------------------------------------------------------------------
# 允许 256 色
set t_Co=256

#-----------------------------------------------------------------------------
#                                  状态栏设置
#-----------------------------------------------------------------------------
set statusline=                                 # 清空状态栏
set statusline+=\ %F                            # 文件名
set statusline+=\ [%1*%M%*%{winnr()}%R%H]       # 文件窗口位置
set statusline+=%=                              # 向右对齐
set statusline+=\ %y                            # 文件类型

# 最右边显示文件编码和行号等信息，并且固定在一个 group 中，优先占位
set statusline+=\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %v:%l/%L%)

#-----------------------------------------------------------------------------
#                                   游标形状
#-----------------------------------------------------------------------------
&t_SI = "\<Esc>[6 q"   # SI = 插入模式
&t_SR = "\<Esc>[4 q"   # SR = 替换模式
&t_EI = "\<Esc>[2 q"   # EI = 普通模式
