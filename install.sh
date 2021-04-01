#!/usr/bin/env bash

# 解决因为数组中 包含空格的字符串 被空格分割，利于添加安装参数
# 保存好原来的IFS的值，方便以后还原回来
PRE_IFS=$IFS
# 设置IFS仅包括换行符
IFS=$'\n'

# 配置文件、命令行工具、有界面工具、vim依赖工具、python工具所需的工具变量
# 方便迁移工作环境，和选择安装所需要的工具。
dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# shellcheck source=./config.sh
source "${dotfileDir}/config.sh"

# cmds guis pips npms
for arg in "$@"
do
    echo "$arg"
    if set | grep -q "^$arg"; then
        case $arg in
            "cmds")
                # 终端所需命令下载
                for cmd in "${cmds[@]}"; do
                    if brew list | grep -q "^${cmd%% *}$"; then
                        echo "${cmd%% *} 未安装---  ... 准备安装"
                        brew install "${cmd}"
                    fi
                done
                ;;
            "guis")
                # gui 软件下载
                for gui in "${guis[@]}"; do
                    if brew cask list | grep -q "^${gui}$"; then
                        echo "${gui%% *} 未安装---  ... 准备安装"
                        brew cask install "${gui}"
                    fi
                done
                ;;
            "pips")
                for pip in "${pips[@]}"; do
                    if pip3 list | grep "${pip}"; then
                        echo "${pip##*/} 未安装---  ... 准备安装"
                        pip3 install "${pip##*/}"
                    fi
                done
                ;;
            "npms")
                for npm in "${npms[@]}"; do
                    if npm list -g | grep -q "${npm##*/}"; then
                        echo "${npm##*/} 未安装---  ... 准备安装"
                        npm install -g --registry=https://registry.npm.taobao.org "${npm##*/}"
                    fi
                done
                ;;
            *) echo "没有安装" ;;
        esac
    fi
done


# 任务执行完毕，把IFS还原回默认值
IFS=$PRE_IFS
