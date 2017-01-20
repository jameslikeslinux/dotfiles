" Behave less like vi
set nocompatible

" Except enable the vi backspace behavior to force myself out of insert mode
" (run as autocmd to avoid conflict with vim-sensible plugin)
autocmd VimEnter,BufNewFile,BufReadPost * silent set backspace=0

" Allow unsaved buffers
set hidden

" Set terminal title
set title

" Highlight current line
set cursorline

" Enable mouse (primarily so mouse selections use visual mode)
set mouse=a

" Vim defaults to ttymouse=xterm under tmux which doesn't work through SSH
if $TERM =~# '^tmux'
    set ttymouse=xterm2
endif

" Automatically copy visual selection to selection clipboard
set clipboard=autoselect

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

" Don't use separators for the buffer/tab list
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''

" On modern terminals or GUI, enable Powerline characters
if &t_Co >= 256 || has("gui_running")
    let g:airline_powerline_fonts = 1
endif

" Konsole doesn't support special Base16 colors despite advertising itself
" as xterm-265color by default.  I configure it to say it's konsole-256color
" so I can detect it here and enable true color support.
if $TERM ==# 'konsole-256color'
    set term=xterm-256color
    set termguicolors
endif

" Set color scheme
colorscheme mine

" The base16 airline theme pulls colors from the main color scheme
let g:airline_theme='base16'

" But it's not perfect, so we modify it as follows
function! AirlineThemePatch(palette)
    if &t_Co <= 16
        " On low color terminals bold can change color, so disable bold
        let a:palette.accents.bold[4] = 'none'
        let a:palette.normal.airline_a[4] = 'none'
        let a:palette.insert.airline_a[4] = 'none'
        let a:palette.visual.airline_a[4] = 'none'

        " And just use plain reverse color for inactive status bars
        let s:inactive = ['', '', '', '', 'reverse']
        let a:palette.inactive = airline#themes#generate_color_map(s:inactive, s:inactive, s:inactive, s:inactive, s:inactive, s:inactive)
        let a:palette.inactive_modified = a:palette.inactive
    endif
endfunction
let g:airline_theme_patch_func = 'AirlineThemePatch'

" Configure fuzzy finder
let g:ctrlp_map = '<C-p>'
let g:ctrlp_cmd = 'CtrlP'
let g:ctrlp_show_hidden = 1
