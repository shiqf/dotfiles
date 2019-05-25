#!/usr/bin/env bash

dotfileDir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source ${dotfileDir}/config.sh

# dotfile cmds guis pythons vims uninstall
for arg in "$@"
do
    echo $arg
    if set | grep -q "^$arg"; then
        case $arg in
            "cmds")
                # 终端所需命令下载
                for cmd in ${cmds[@]}; do
                    if brew list | grep -q "^${cmd%% *}$"; then
                        echo "${cmd%% *} ...准备卸载"
                        brew remove ${cmd}
                    fi
                done
                ;;
            "guis")
                # gui 软件下载
                for gui in ${guis[@]}; do
                    if brew cask list | grep -q "^${gui}$"; then
                        echo "${gui%% *} ...准备卸载"
                        brew cask zap ${gui}
                    fi
                done
                ;;
            "pythons") echo "four";;
            "vims")
                for vim in ${vims[@]}; do
                    if brew list | grep -q "^${vim##*/}$"; then
                        echo "${vim##*/} ...准备卸载"
                        brew uninstall ${vim##*/}
                    fi
                done
                ;;
            "dotfiles")
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
                ;;
            *) echo "没有卸载" ;;
        esac
    fi
done
