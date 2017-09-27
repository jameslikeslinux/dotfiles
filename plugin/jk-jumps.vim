if exists('did_jk_jumps_vim') || &cp || version < 700
    finish
endif
let did_jk_jumps_vim = 1

if !exists('g:jk_jumps_minimum_lines')
    let g:jk_jumps_minimum_lines = 7
endif

function! JkJumps(key) range
    exec "normal! ".v:count1.a:key
    if v:count1 >= g:jk_jumps_minimum_lines
        let target = line('.')
        let bkey = 'k'
        if (a:key == 'k')
            let bkey = 'j'
        endif
        exec "normal! ".v:count1.bkey
        exec "normal! ".target."G"
    endif
endfunction

nnoremap <silent> j :<C-U>call JkJumps('j')<CR>
nnoremap <silent> k :<C-U>call JkJumps('k')<CR>
