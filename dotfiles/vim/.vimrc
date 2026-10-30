set nocompatible
set number

set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent

set endofline
set fixendofline

filetype plugin indent on

syntax enable
set termguicolors
if executable('morgh-theme')
  set runtimepath+=/usr/share/morgh/themes/editor/vim
  let s:theme = trim(system('morgh-theme name'))
  if v:shell_error == 0 && s:theme =~# '^shotormorgh-[a-z-]\+$'
    execute 'colorscheme ' . s:theme
  else
    colorscheme shotormorgh-dark
  endif
else
  colorscheme shotormorgh-dark
endif
