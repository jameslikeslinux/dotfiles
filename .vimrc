" Behave less like vi
set nocompatible

" Allow unsaved buffers
set hidden

" Set terminal title
set title

" Highlight current line
set cursorline

" Enable mouse (primarily so mouse selections use visual mode)
set mouse=a

" SGR mouse mode is supported by virtually every modern terminal, including my
" patched version of rxvt-unicode.  It is needed to support events beyond column
" 223.  Vim's SGR mode is backwards compatible with the older xterm2 protocol.
set ttymouse=sgr

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

" Show command as it's being typed
set showcmd

" Use space as leader in a way that it still appears in the showcmd
map <Space> <Leader>

" Make switching between buffers easier
nnoremap <Leader>n :bn<CR>
nnoremap <Leader>p :bp<CR>
nnoremap <Leader>a <C-^>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>w :w<CR>

" Create shortcuts to switch between indenting styles:
" indent with spaces:
nnoremap <Leader>2 :setlocal shiftwidth=2 tabstop=8 expandtab<CR>
nnoremap <Leader>4 :setlocal shiftwidth=4 tabstop=8 expandtab<CR>
nnoremap <Leader>8 :setlocal shiftwidth=8 tabstop=8 expandtab<CR>

" indent with tabs:
nnoremap <Leader>2 :setlocal shiftwidth=2 tabstop=2 noexpandtab<CR>
nnoremap <Leader>4 :setlocal shiftwidth=4 tabstop=4 noexpandtab<CR>
nnoremap <Leader>8 :setlocal shiftwidth=8 tabstop=8 noexpandtab<CR>

" sturdiva mode
" (maintain existing shiftwidth, but also enable hard tabs)
nnoremap <Leader>s :setlocal tabstop=8 noexpandtab<CR>

" Default to four spaces for tabs
set shiftwidth=4
set expandtab

augroup indentation
    autocmd!

    " New-style source code uses two spaces for tabs
    autocmd FileType javascript,json,puppet,ruby,yaml setlocal shiftwidth=2

    " Makefiles must use hard tabs, but let them appear as four spaces
    autocmd FileType make setlocal tabstop=4 noexpandtab
augroup end

" Load Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Let airline show the mode
set noshowmode

" Hide empty airline sections
let g:airline_skip_empty_sections = 1

" Show fancy tabline when more than one tab exists
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#tab_min_count = 2

" Enable powerline characters on supported terminals
if &term =~# 'powerline'
    let g:airline_powerline_fonts = 1

    " Use more common, single-width glyphs for line count and whitespace
    " problem indicator (utf8proc incorrectly reports the airline defaults as
    " two spaces wide)
    if !exists('g:airline_symbols')
        let g:airline_symbols = {}
    endif
    let g:airline_symbols.linenr = ''
    let g:airline_symbols.maxlinenr = '≡'
    let g:airline_symbols.whitespace = '!'
endif

" Enable true-color on supported terminals
if &term =~# 'truecolor'
    set termguicolors
endif

" Tell vim how to use true colors in tmux
" See: help xterm-true-color
if &term =~# 'tmux'
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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

augroup special_filetypes
    autocmd!

    " http://vim.wikia.com/wiki/Always_start_on_first_line_of_git_commit_message
    autocmd FileType gitcommit call setpos('.', [0, 1, 1, 0])
augroup end

" XXX: Work around painfully slow syntax highlighting for ruby/perl/others:
" use the legacy regexp engine.  Bug reports suggest this problem is specific
" to 'relativenumber' configurations, but the slowness arises with 'hlsearch'
" too.
set regexpengine=1
