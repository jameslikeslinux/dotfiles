" Enable syntax highlighting
syntax on

" Behave less like vi
set nocompatible
set backspace=2

" Disable auto-indent
set noai

" Use unicode
set encoding=utf-8

" Allow unsaved buffers
set hidden

" Detect puppet filetype
au BufRead,BufNewFile *.pp set filetype=puppet

" Detect Arduino Sketch filetype
au BufRead,BufNewFile *.ino set filetype=cpp

" Detect Elixir filetype
au BufRead,BufNewFile *.ex,*.exs set filetype=elixir

" Load Pathogen
execute pathogen#infect()

" Set color scheme
colorscheme Tomorrow-Night-Bright

" Highlight current line
set cursorline

" Enable airline
set laststatus=2

" Let airline detect mode changes quicker
set ttimeoutlen=50

" Let airline show the mode
set noshowmode

" Airline settings
let g:airline_powerline_fonts=1
