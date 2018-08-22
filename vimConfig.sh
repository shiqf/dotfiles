#!/usr/bin/env bash

# 解决因为数组中 包含空格的字符串 被空格分割，利于添加安装参数
# 保存好原来的IFS的值，方便以后还原回来
PRE_IFS=$IFS
# 设置IFS仅包括换行符
IFS=$'\n'

dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${dotfileDir}/softConfigVars.sh

for vimDependCommand in ${vimDependCommands[@]}; do
    brew list | grep "^${vimDependCommand##*/}$"
    if [[ $? -ne 0 ]]; then
        echo "${vimDependCommand##*/} 未安装---  ... 准备安装"
        brew install ${vimDependCommand##*/}
    fi
done

# 安装 vim 插件
vim +PlugUpdate +qall

# 任务执行完毕，把IFS还原回默认值
IFS=$PRE_IFS
