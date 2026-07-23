if config == 0
  colorscheme retrobox
elseif config == 1
  colorscheme habamax
  set completeopt+=fuzzy
else
  colorscheme slate
  set completeopt+=preinsert,nearest
endif
