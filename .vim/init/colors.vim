" 首先需要设置iterm2终端的profiles菜单下的Colors中的
" Color presets 设置为Solarized Dark主题
" 当使用 tmux 或 gui vim 时使用该主题
try
  if exists('$TMUX') || has('gui')
    " Mac自带终端声明为xterm -> 在终端配置高级选项栏中选择 xterm
    " iterm2的终端声明为 xterm-256color ，终端显示zsh主题为 pygmalion
    " 以上zsh主题设置在.zshrc中配置 详见 ~/dotfile/.zshrc
    if strftime('%H') > 8 && strftime('%H') <= 16
      " 早上9点到下午5点为gruvbox dark背景
      set background=dark
      colorscheme gruvbox
    elseif strftime('%H') > 16 && strftime('%H') <= 24
      " 下午5点到晚上12点为dracula dark背景
      set background=dark
      " colorscheme dracula
      colorscheme gruvbox
    elseif strftime('%H') > 0 || strftime('%H') <= 8
      " 晚上凌晨1点到早上8点为molokai dark背景
      set background=dark
      colorscheme molokai
    endif
  else
    set background=dark
    colorscheme gruvbox
  endif
catch /.*/
  echomsg '需要安装插件, 安装命令是 :PlugUpdate'
endtry
