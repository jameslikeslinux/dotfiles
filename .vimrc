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

" Enable tabline that shows buffers when only one tab open
let g:airline#extensions#tabline#enabled = 1

if &t_Co == 256 || has("gui_running")
    " Enable true color support
    if has("termguicolors")
        set termguicolors
    endif

    " Set color scheme
    colorscheme Tomorrow-Night-Bright

    " Highlight current line
    set cursorline

    " Let airline use special powerline characters
    let g:airline_powerline_fonts = 1
else
    " Swap the active 'tab' separator characters on plain terminals
    " (let the active tab be surrounded by '|')
    let g:airline#extensions#tabline#left_sep = '|'                                 
    let g:airline#extensions#tabline#left_alt_sep = ' '
endif
