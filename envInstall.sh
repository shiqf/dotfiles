#!/usr/bin/env bash

# 根据系统创建相关目录
dirUseBySystem=''
# 配置文件放置目录
dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# windows 7 64位系统 vim-plug 插件需要安装在 ~/.vim/vimfiles/autoload/ 下
if [[ `uname -s` == 'MSYS_NT-6.1' || `uname -s` == 'MINGW64_NT-6.1' ]]; then
    #######################################################################
    #                         windows 环境软件安装                        #
    #######################################################################
    echo 'windows soft downloads'
elif [[ `uname -s` == 'Darwin' ]]; then
    #######################################################################
    #                             Mac 环境软件安装                        #
    #######################################################################
    if [[ `which brew` != /usr/local/bin/brew ]]; then
        #  home brew 软件管理软件
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        brew doctor # 检测程序是否正常权限是否足够
    fi

    # 判断 /etc/shells 中是否包含最新 zsh，添加最新 zsh 命令地址到 shell 配置文件中
    grep -q `which zsh` /etc/shells
    if [[ $? -ne 0 ]]; then
        sudo bash -c "echo `which zsh` >> /etc/shells" 
    fi

    # 切换系统默认 bash 为最新安装 zsh
    if [[ ${SHELL##*/} != 'zsh' ]]; then
        sudo chsh -s `which zsh`
    fi
else
    #######################################################################
    #                         其他环境软件安装                            #
    #######################################################################
    echo 'other system soft downloads'
fi

# 安装 oh-my-zsh 插件
if [[ ! -e ~/.oh-my-zsh ]]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

#######################################################################
#                          需要创建的文件目录                         #
#######################################################################

dires=(
${dotfileDir}/.vim/bundle/. # 创建插件安装文件夹
~/backup/.                  # 创建备份配置文件夹
)

for dir in ${dires[@]}; do
    if [[ ! -e ${dir%/*} ]]; then
        mkdir -p ${dir%/*}
    fi
    if [[ ${dir##*/} != . && ! -e ~/${dir} ]]; then
        ln -s ${dotfileDir}/${dir##*/} ~/${dir}
    fi
done

#######################################################################
#                   配置文件软链接到用户主目录当中去                  #
#######################################################################

# 引入 soft 中的dotfiles变量
source ${dotfileDir}/config.sh

# 匹配的进行删除
# [#%] 尽可能短的从[左右]往[右左]删除字符
# (##|%%) 尽可能长的从[左右]往[右左]删除字符
# ${var([#%]|##|%%)pattern} * 万用符
# 如果配置文件在安装之前存在放入备份文件夹
for dotfile in ${dotfiles[@]}; do
    if [[ -L ~/${dotfile##*/} && -L ~/backup/${dotfile##*/} ]]; then
        echo "删除 ~/backup/${dotfile##*/} 文件"
        rm ~/backup/${dotfile##*/}
        echo "移动 ~/${dotfile##*/} 文件到 backup 文件夹"
        mv ~/${dotfile##*/} ~/backup
    elif [[ -L ~/${dotfile##*/} || -e ~/${dotfile##*/} && ! -L ~/backup/${dotfile##*/} ]]; then
        echo "移动 ~/${dotfile##*/} 文件到 backup 文件夹"
        mv ~/${dotfile##*/} ~/backup
    fi
    echo -e "软链接配置文件 ${dotfileDir}/${dotfile} 到 ~/${dotfile##*/}\n"
    ## 把配置文件软链接到用户主目录中
    ln -s ${dotfileDir}/${dotfile} ~/${dotfile##*/}
done

#######################################################################
#                          安装 vim 插件目录                          #
#######################################################################

# vim 插件管理插件安装
# windows 7 vim-plug 插件需要安装在 ~/.vim/vimfiles/autoload/ 下
# Kernel=`uname -s`
# case $Kernel in  
#     'MSYS_NT-6.1') curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs \
#         https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ;;
#     *) echo -e "\e[1;30m这是什么颜色?\e[0m" ;;  
# esac  

if [[ `uname -s` == 'MSYS_NT-6.1' || `uname -s` == 'MINGW64_NT-6.1' ]]; then
    if [[ ! -e ~/vimfiles/autoload/plug.vim ]]; then
        curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
elif [[ `uname -s` == 'Darwin' ]]; then
    if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    # tmux 插件管理插件安装
    if [[ ! -e ~/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm  ~/.tmux/plugins/tpm
    fi
elif [[ `uname -s` == 'Linux' ]]; then
    if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
else
    :
fi
