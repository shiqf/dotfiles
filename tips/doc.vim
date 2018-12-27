:r !ls *.[hc]
:%s/^.\+$/echo >> markdown.md; echo \/\\* & \\*\/ >> markdown.md; cat & >> markdown.md/g
:%s/^$/echo '```c' > markdown.md/g
:$r !echo
:%s/^$/echo '```' >> markdown.md/g
:%s/markdown/README/g
:w !sh
:qa!
