" Fix for color xterms in Solaris.
" From :help xterm-color
if &term =~ "xterm"
  if has("terminfo")
    set t_Co=8
    set t_Sf=[3%p1%dm
    set t_Sb=[4%p1%dm
  else
    set t_Co=8
    set t_Sf=[3%dm
    set t_Sb=[4%dm
  endif
endif

" Enable syntax highlighting
syntax on

" Show cursor position
set ruler

" Behave less like vi
set nocompatible
set backspace=2

" Spaces for tabs
set tabstop=4
set shiftwidth=4
set expandtab

" Detect puppet filetype
au BufRead,BufNewFile *.pp set filetype=puppet

" Detect Arduino Sketch filetype
au BufRead,BufNewFile *.ino set filetype=cpp
