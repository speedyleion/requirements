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
    \ ['top', 0],
    \ ['previewwin_pos', 'topleft'],
    \ ['show_visibility', 1],
    \ ['show_linenumbers', 0],
    \ ['singleclick', 0],
    \ ['sort', 1],
    \ ['systemenc', &encoding],
    \ ['height', 10],
    \ ['zoomwidth', 1],
\ ]

for [opt, val] in s:options
    call s:init_var(opt, val)
endfor
unlet s:options

let s:keymaps = [
    \ ['jump',          '<CR>'],
    \ ['preview',       'p'],
    \ ['previewwin',    'P'],
    \ ['nexttag',       '<C-N>'],
    \ ['prevtag',       '<C-P>'],
    \ ['showproto',     '<Space>'],
    \ ['hidenonpublic', 'v'],
    \
    \ ['openfold',      ['+', '<kPlus>', 'zo']],
    \ ['closefold',     ['-', '<kMinus>', 'zc']],
    \ ['togglefold',    ['o', 'za']],
    \ ['openallfolds',  ['*', '<kMultiply>', 'zR']],
    \ ['closeallfolds', ['=', 'zM']],
    \
    \ ['togglesort', 's'],
    \ ['zoomwin',    'x'],
    \ ['close',      'q'],
    \ ['help',       ['<F1>', '?']],
\ ]

for [map, key] in s:keymaps
    call s:init_var('map_' . map, key)
    unlet key
endfor
unlet s:keymaps
"
" Commands {{{1
command! -nargs=0 Requirements              call requirements#ToggleWindow()
command! -nargs=? RequirementsOpen          call requirements#OpenWindow(<f-args>)
command! -nargs=0 RequirementsOpenAutoClose call requirements#OpenWindow('fcj')
command! -nargs=0 RequirementsClose         call requirements#CloseWindow()
" command! -nargs=? TagbarDebug         call tagbar#StartDebug(<f-args>)
" command! -nargs=0 TagbarDebugEnd      call tagbar#StopDebug()
