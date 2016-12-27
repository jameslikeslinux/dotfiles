" Behave less like vi
set nocompatible

" Allow unsaved buffers
set hidden

" Set terminal title
set title

" Enable mouse (primarily so mouse selections use visual mode)
set mouse=a

" Automatically copy visual selection to selection clipboard
set clipboard=autoselect

" Let yanks go to selection clipboard
set clipboard+=unnamed

" If available, let all other default register actions go to primary clipboard
if has('unnamedplus')
    set clipboard+=unnamedplus
endif

" Enable more natural window splits
set splitbelow
set splitright

" Show line numbers for jumping around
set relativenumber

" Disable wrapping; show indicators on overflow
set nowrap
set list

" Default to four spaces for tabs
set shiftwidth=4
set expandtab

" New-style source code uses two spaces for tabs
autocmd FileType javascript,json,puppet,ruby setlocal shiftwidth=2

" Makefiles must use hard tabs, but let them appear as four spaces
autocmd FileType make setlocal tabstop=4 noexpandtab

" Create shortcuts to switch between indenting styles
nnoremap <Leader>0 :setlocal shiftwidth=4 tabstop=8 expandtab<CR>   " default 4-space indent
nnoremap <Leader>2 :setlocal shiftwidth=2 tabstop=8 expandtab<CR>   " modern 2-space indent
nnoremap <Leader>4 :setlocal shiftwidth=4 tabstop=4 noexpandtab<CR> " 4-space hard tab
nnoremap <Leader>8 :setlocal shiftwidth=8 tabstop=8 noexpandtab<CR> " 8-space hard tab

" Load Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

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

" Base16 has a confusing match paren color;
" change it to invert the paren (base0F) and cursor (base06) colors
autocmd ColorScheme base16-bright highlight MatchParen ctermbg=07 ctermfg=00 guibg=#be643c guifg=#e0e0e0

" Set color scheme
colorscheme base16-bright

" Airline comes with a base16-bright theme
" but I like the base base16 theme better
let g:airline_theme='base16'

" Use Ctrl+P to invoke CtrlP plugin
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
