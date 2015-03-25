" This is the main plug-in entry for Requirements it has the mappings as well as
" the setting of the global variables.

if &cp || exists('g:loaded_requirements')
    finish
endif

function! s:init_var(var, value) abort
    if !exists('g:requirements_' . a:var)
        execute 'let g:requirements_' . a:var . ' = ' . string(a:value)
    endif
endfunction

let s:options = [
    \ ['autoclose', 0],
    \ ['autofocus', 0],
    \ ['autopreview', 0],
    \ ['autoshowtag', 0],
    \ ['compact', 0],
    \ ['expand', 0],
    \ ['foldlevel', 99],
    \ ['hide_nonpublic', 0],
    \ ['indent', 2],
    \ ['left', 0],
    \ ['previewwin_pos', 'topleft'],
    \ ['show_visibility', 1],
    \ ['show_linenumbers', 0],
    \ ['singleclick', 0],
    \ ['sort', 1],
    \ ['systemenc', &encoding],
    \ ['width', 40],
    \ ['zoomwidth', 1],
\ ]

for [opt, val] in s:options
    call s:init_var(opt, val)
endfor
unlet s:options
