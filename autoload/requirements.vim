" This is the main functionality for the requirements plug-in.  This handles
" creating, or jumping to, a __Requirements__ window.
" The window has a list of requirements ordered by requirement number.
"
" TODO consider if it is beneficial to list line numbers and then
" requirements.  Thinking this should be requirement based with an easy listing
" of the requirements found in the file.

" Initialization {{{1
let s:window_name = '__Requirements__'

" s:OpenWindow() {{{2
function! s:OpenWindow(flags) abort

    let autofocus = a:flags =~# 'f'
    let jump      = a:flags =~# 'j'
    let autoclose = a:flags =~# 'c'

    let curfile = fnamemodify(bufname('%'), ':p')
    let curline = line('.')

    " If the requirements window is already open check jump flag Also set the
    " autoclose flag if requested
    let requirementswinnr = bufwinnr(s:window_name)
    if requirementswinnr != -1
        if winnr() != requirementswinnr && jump
            call s:goto_win(requirementswinnr)
        endif
        return
    endif

    " let openpos = g:tagbar_left ? 'topleft ' : 'botright '
    let openpos = 'botright '
    exe 'silent keepalt ' . openpos . '10' . 'split ' . s:window_name

    call s:InitWindow(autoclose)

endfunction

" s:goto_win() {{{2
function! s:goto_win(winnr, ...) abort
    let cmd = type(a:winnr) == type(0) ? a:winnr . 'wincmd w'
                                     \ : 'wincmd ' . a:winnr
    let noauto = a:0 > 0 ? a:1 : 0

    if noauto
        noautocmd execute cmd
    else
        execute cmd
    endif
endfunction

" s:InitWindow() {{{2
" This sets up all of the Vim parameters for the requirements window.
" This will override user defaults, but they will be local to the requirements
" window.
function! s:InitWindow(autoclose) abort

    setlocal filetype=requirements

    setlocal noreadonly " in case the "view" mode is used
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nowrap
    setlocal winfixheight
    setlocal textwidth=0
    setlocal nospell

    setlocal nofoldenable
    setlocal foldcolumn=0
    " Reset fold settings in case a plugin set them globally to something
    " expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
    " off, and then for every appended line (like with :put).
    setlocal foldmethod&
    setlocal foldexpr&

endfunction

" requirements#OpenWindow() {{{1
function! requirements#OpenWindow(...) abort
    let flags = a:0 > 0 ? a:1 : ''
    call s:OpenWindow(flags)
endfunction

