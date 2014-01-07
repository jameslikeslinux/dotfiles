" Enable syntax highlighting
syntax on

" Behave less like vi
set nocompatible
set backspace=2

" Disable auto-indent
set noai

" Use unicode
set encoding=utf-8

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
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#tab_nr_type = 1
