#!/usr/bin/env bash

# 根据系统创建相关目录
dirUseBySystem=''
# 配置文件放置目录
dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# windows 7 64位系统 vim-plug 插件需要安装在 ~/.vim/vimfiles/autoload/ 下
if [[ `uname -s` =~ ^MSYS_NT || `uname -s` =~ ^MINGW64_NT ]]; then
    #######################################################################
    #                         windows 环境软件安装                        #
    #######################################################################
    echo 'windows soft downloads'
elif [[ `uname -s` =~ Darwin ]]; then
    #######################################################################
    #                             Mac 环境软件安装                        #
    #######################################################################
    if [[ `which zsh` =~ zsh$ && ! -e ~/.zplug ]]; then
        git clone https://github.com/zplug/zplug ~/.zplug
    fi

    if [[ `which brew` =~ brew$ ]]; then
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
    if [[ ! $SHELL =~ zsh$ ]]; then
        sudo chsh -s `which zsh`
    fi
else
    if [[ `which zsh` =~ zsh$ && ! -e ~/.zplug ]]; then
        git clone https://github.com/zplug/zplug ~/.zplug
    fi
    #######################################################################
    #                         其他环境软件安装                            #
    #######################################################################
    echo 'other system soft downloads'
fi

#######################################################################
#                          需要创建的文件目录                         #
#######################################################################

dires=(
    ~/backup/.                  # 创建备份配置文件夹
    ~/.config/.
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

# neovim 链接
if [[ ! `uname -s` =~ ^MSYS_NT || `uname -s` =~ ^MINGW64_NT ]]; then
    ln -s ~/dotfiles/.vim ~/.config/nvim
fi

#######################################################################
#                          安装 vim 插件目录                          #
#######################################################################

# vim 插件管理插件安装
if [[ `uname -s` =~ ^MSYS_NT || `uname -s` =~ ^MINGW64_NT ]]; then
    # gvim 使用
    if [[ ! -e ~/vimfiles/autoload/plug.vim ]]; then
        curl -fLo ~/vimfiles/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    # 终端中使用
    if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
elif [[ `uname -s` =~ Darwin ]]; then
    if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    # tmux 插件管理插件安装
    if [[ ! -e ~/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm  ~/.tmux/plugins/tpm
    fi
elif [[ `uname -s` =~ Linux ]]; then
    if [[ ! -e ~/.vim/autoload/plug.vim ]]; then
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    fi
    # tmux 插件管理插件安装
    if [[ ! -e ~/.tmux/plugins/tpm ]]; then
        git clone https://github.com/tmux-plugins/tpm  ~/.tmux/plugins/tpm
    fi
else
    :
fi
