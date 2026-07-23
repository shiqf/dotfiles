if len(v:argv) >= 3
  let config = str2nr(v:argv[2])
else
  let config = 0
endif
source ~/.vim/init.vim
