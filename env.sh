dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# aliases 命令别名自定义 ---------------------------------------------------------

alias cls='clear'
alias grep="grep --color=auto"
alias javac="javac -J-Dfile.encoding=utf8"
alias la='ls -a'
alias ll='ls -l'
alias tmux='tmux -2'
alias vi='vim'
alias pdf='mupdf-gl'

# 在命令行直接输入文件名后缀，会在 vim 中打开 ----------------------------------

# 用什么编辑器打开
export EDITOR='vim'

alias envconfig="${EDITOR} ${dotfileDir}/env.sh"
alias zshconfig="${EDITOR} ~/.zshrc"
alias ohmyzsh="${EDITOR} ~/.oh-my-zsh"
alias typora="open -a typora"

alias -s c=${EDITOR}
alias -s html=${EDITOR}
alias -s java=${EDITOR}
alias -s js=${EDITOR}
alias -s rb=${EDITOR}
alias -s txt=${EDITOR}

# 各种打包解压
alias -s bz2='tar -xjvf'
alias -s gz='tar -xzvf'
alias -s tgz='tar -xzvf'
alias -s zip='unzip'

# 功能增强----------------------------------------------------------------------

# FileSearch
function f() { find . -iname "*$1*" ${@:2} }
function r() { grep "$1" ${@:2} -R . }

# mkdir and cd
function mkcd() { mkdir -p "$@" && cd "$_"; }
