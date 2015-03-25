" This is the main functionality for the requirements plug-in.  This handles
" creating, or jumping to, a __Requirements__ window.
" The window has a list of requirements ordered by requirement number.
"
" TODO consider if it is beneficial to list line numbers and then
" requirements.  Thinking this should be requirement based with an easy listing
" of the requirements found in the file.

" Initialization {{{1
let s:window_name = '__Requirements__'

" s:GotoFileWindow() {{{1
" Try to switch to the window that has requirements' current file loaded in it,
" or open the file in an existing window otherwise.
function! s:GotoFileWindow(fileinfo, ...) abort
    let noauto = a:0 > 0 ? a:1 : 0

    let filewinnr = s:GetFileWinnr(a:fileinfo)

    " If there is no window with the correct buffer loaded then load it
    " into the first window that has a non-special buffer in it.
    if filewinnr == 0
        for i in range(1, winnr('$'))
            call s:goto_win(i, 1)
            if &buftype == '' && !&previewwindow
                execute 'buffer ' . a:fileinfo.bufnr
                break
            endif
        endfor
    else
        call s:goto_win(filewinnr, 1)
    endif

    " To make ctrl-w_p work we switch between the Requirements window and the
    " correct window once
    call s:goto_requirements(noauto)
    call s:goto_win('p', noauto)
endfunction

" s:goto_requirements() {{{1
function! s:goto_requirements(...) abort
    let noauto = a:0 > 0 ? a:1 : 0
    call s:goto_win(bufwinnr(s:window_name), noauto)
endfunction
"
" s:goto_win() {{{2
function! s:goto_win(winnr, ...) abort
    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
                                     \ : 'wincmd ' . a:winnr
    let noauto = a:0 > 0 ? a:1 : 0

    " call s:LogDebugMessage("goto_win(): " . cmd . ", " . noauto)

    if noauto
        noautocmd execute cmd
    else
        execute cmd
    endif
endfunction
