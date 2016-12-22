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

" Load Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Enable airline
set laststatus=2

" Let airline detect mode changes quicker
set ttimeoutlen=50

" Let airline show the mode
set noshowmode

" Hide empty airline sections
let g:airline_skip_empty_sections = 1

" Show tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

if &t_Co == 256 || has("gui_running")
    " Enable true color support
    if has("termguicolors")
        set termguicolors
    endif

    " Highlight current line
    set cursorline

    " Let airline use special powerline characters
    let g:airline_powerline_fonts = 1
endif

" Set color scheme
colorscheme base16-bright
let g:airline_theme='base16'
