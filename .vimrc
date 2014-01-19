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

" Set terminal title
set title

" Detect puppet filetype
au BufRead,BufNewFile *.pp set filetype=puppet

" Detect Arduino Sketch filetype
au BufRead,BufNewFile *.ino set filetype=cpp

" Detect Elixir filetype
au BufRead,BufNewFile *.ex,*.exs set filetype=elixir

" Detect ImplicitCAD filetype
au BufRead,BufNewFile *.escad set filetype=openscad

" Load Pathogen
execute pathogen#infect()

" Enable airline
set laststatus=2

" Let airline detect mode changes quicker
set ttimeoutlen=50

" Let airline show the mode
set noshowmode

if &t_Co == 256 || has("gui_running")
    " Set color scheme
    colorscheme Tomorrow-Night-Bright

    " Highlight current line
    set cursorline

    " Let airline use special powerline characters
    let g:airline_powerline_fonts = 1
endif
