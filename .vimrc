" Behave less like vi
set nocompatible

" Except enable the vi backspace behavior to force myself out of insert mode
" (run as autocmd to avoid conflict with vim-sensible plugin)
autocmd VimEnter,BufNewFile,BufReadPost * silent set backspace=0

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

" Disable wrapping, show indicators on overflow, scroll smoothly
set nowrap list sidescroll=1

" Use more bash-like file completion (don't cycle through options)
set wildmode=longest,list

" Default to four spaces for tabs
set shiftwidth=4
set expandtab

" New-style source code uses two spaces for tabs
autocmd FileType javascript,json,puppet,ruby,yaml setlocal shiftwidth=2

" Makefiles must use hard tabs, but let them appear as four spaces
autocmd FileType make setlocal tabstop=4 noexpandtab

" Create shortcuts to switch between indenting styles:
" default 4-space indent
nnoremap <Leader>0 :setlocal shiftwidth=4 tabstop=8 expandtab<CR>
" modern 2-space indent
nnoremap <Leader>1 :setlocal shiftwidth=2 tabstop=8 expandtab<CR>
" 4-space hard tab
nnoremap <Leader>2 :setlocal shiftwidth=4 tabstop=4 noexpandtab<CR>
" 8-space hard tab
nnoremap <Leader>3 :setlocal shiftwidth=8 tabstop=8 noexpandtab<CR>

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

" We purposefully make Konsole misidentify itself because it's stupid
" See: https://bugs.kde.org/show_bug.cgi?id=344181
if $TERM == 'konsole-256color'
    set term=xterm-256color
endif

" Use nicer colors except on the Linux console
if $TERM !~# '^linux'
    if has("termguicolors")
        set termguicolors
    endif

    " Highlight current line
    set cursorline
endif

" On modern terminals or GUI, enable Powerline characters
if &t_Co >= 256 || has("gui_running")
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
let g:ctrlp_map = '<C-P>'
let g:ctrlp_cmd = 'CtrlP'
