## 文档生成方法

使用doc.vim

在项目目录中使用

```bash
vim -s doc.vim # doc.vim文件路径自己指定
```

doc.vim 中的内容

```
" 在命令运行目录读取c结尾的文件列表
:r !ls *.c
" 每个文件在makrdown文件中换行、插入文件名、插入文件内容
:%s/^.\+$/echo >> markdown.md; echo \/\\* & \\*\/ >> markdown.md; cat & >> markdown.md/g
" 在markdown文件中首行中用```c
:%s/^$/echo '```c' > markdown.md/g
" 添加末尾空行
:$r !echo
" 在markdown文件中末行中用```
:%s/^$/echo '```' >> markdown.md/g
" 定义markdown文件名称
:%s/markdown/2/g
" 运行命令
:w !sh
" 退出
:qa!
```
