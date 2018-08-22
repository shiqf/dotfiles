#!/usr/bin/env bash

dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${dotfileDir}/softConfigVars.sh

# 匹配的进行删除
# [#%] 尽可能短的从[左右]往[右左]删除字符
# (##|%%) 尽可能长的从[左右]往[右左]删除字符
# ${var([#%]|##|%%)pattern}  * 万用符
for dotfile in ${dotfiles[@]}; do
    if [[ -L ~/${dotfile##*/} ]]; then
        echo "删除 ~/${dotfile##*/} 文件"
        rm ~/${dotfile##*/}
    fi
    if [[ -L ~/backup/${dotfile##*/} ]]; then
        echo "删除 ~/backup/${dotfile##*/} 文件"
        rm ~/backup/${dotfile##*/}
    fi
done
