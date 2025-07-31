vim9script
#=============================================================================
#
#      tabsize.vim - 大部分人对 tabsize 都有自己的设置，改这里即可
#
# vim: set ts=2 sw=2 tw=78 et :
#=============================================================================


#-----------------------------------------------------------------------------
#                         默认缩进模式（可以后期覆盖）
#-----------------------------------------------------------------------------
# 设置 TAB 宽度
set tabstop=4

# 设置缩进宽度
set shiftwidth=4

# 如果后面设置了 expandtab 那么展开 tab 为多少字符
set softtabstop=4

# 禁止展开 tab (noexpandtab)
set expandtab

augroup FileTypeTab
  au!
  # 如果你需要 python 里用 tab，那么反注释下面这行字，否则vim会在打开py文件
  # 时自动设置成空格缩进。自动缩进根据 shiftwidth
  # au FileType python setlocal shiftwidth=4 tabstop=4 noexpandtab

  au FileType autohotkey  setlocal ts=2 sw=2 sts=2
  au FileType c,cpp       setlocal ts=8 sw=4 sts=4 noet cinoptions=>s,e0,n0,f0,{0,}0,^0,L-1,:s,=s,l0,b0,gs,hs,N-s,E0,ps,ts,is,+s,c3,C0,/0,(s,us,U0,w0,W0,k0,m0,j0,J0,)20,*70,#0,P0,g0
  au FileType css         setlocal ts=2 sw=2 sts=2
  au FileType dockerfile  setlocal ts=4 sw=4 sts=4
  au FileType graphql     setlocal ts=2 sw=2 sts=2
  au FileType gitconfig   setlocal ts=4 sw=4 sts=4 noet
  au FileType git         setlocal ts=8 sw=8 sts=8 noet
  au FileType html        setlocal ts=2 sw=2 sts=2
  au FileType java        setlocal ts=4 sw=4 sts=4
  au FileType javascript  setlocal ts=2 sw=2 sts=2 suffixesadd=.js
  au FileType json        setlocal ts=2 sw=2 sts=2
  au FileType make        setlocal ts=4 sw=4 sts=4 noexpandtab
  au FileType python      setlocal ts=8 sw=2 sts=2
  au FileType sh          setlocal ts=4 sw=4 sts=4
  au FileType sql         setlocal ts=4 sw=4 sts=4
  au FileType typescript  setlocal ts=2 sw=2 sts=2 suffixesadd=.ts,.d.ts
  au FileType vim         setlocal ts=2 sw=2 sts=2
  au FileType zsh         setlocal ts=4 sw=4 sts=4
  au FileType markdown    setlocal ts=8 sw=8 sts=8
  au FileType asm         setlocal ts=8 sw=8 sts=8 noet
augroup END
