#!/usr/bin/env bash

source ~/dotfiles/softConfigVars.sh

for vimDependCommand in ${vimDependCommands[@]}; do
    brew list | grep "^${vimDependCommand%% *}$"
    if [[ $? -ne 0 ]]; then
        echo "${vimDependCommand%% *} 未安装---  ... 准备安装"
        brew install ${vimDependCommand}
    fi
done

# 安装 vim 插件
vim -c "PlugUpdate"
