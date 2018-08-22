#!/usr/bin/env bash

dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${dotfileDir}/softConfigVars.sh

# iterm2 终端安装配置及相关工具下载
if [[ `which brew` == /usr/local/bin/brew ]]; then
    # 终端所需命令下载
    for command in ${commands[@]}; do
        brew list | grep "^${command%% *}$"
        if [[ $? -ne 0 ]]; then
            echo "${command%% *} 未安装---  ... 准备安装"
            brew install ${command}
        fi
    done
    # gui 软件下载
    for gui in ${guis[@]}; do
        brew cask list | grep "^${gui}$"
        if [[ $? -ne 0 ]]; then
            echo "${gui%% *} 未安装---  ... 准备安装"
            brew cask install ${gui}
        fi
    done
fi
