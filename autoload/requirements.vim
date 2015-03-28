" This is the main functionality for the requirements plug-in.  This handles
" creating, or jumping to, a __Requirements__ window.
" The window has a list of requirements ordered by requirement number.
"
" TODO consider if it is beneficial to list line numbers and then
" requirements.  Thinking this should be requirement based with an easy listing
" of the requirements found in the file.

" Initialization {{{1
let s:window_name = '__Requirements__'

function! requirements#OpenWindow(...) abort
    let flags = a:0 > 0 ? a:1 : ''
    call s:OpenWindow(flags)
endfunction

" s:OpenWindow() {{{2
function! s:OpenWindow(flags) abort
    " call s:LogDebugMessage("OpenWindow called with flags: '" . a:flags . "'")

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
            " call s:HighlightTag(g:tagbar_autoshowtag != 2, 1, curline)
        endif
        " call s:LogDebugMessage("OpenWindow finished, Tagbar already open")
        return
    endif

    " This is only needed for the CorrectFocusOnStartup() function
    let s:last_autofocus = autofocus

    " if !s:Init(0)
    "     return 0
    " endif

    let s:window_opening = 1
    " let openpos = g:tagbar_left ? 'topleft ' : 'botright '
    let openpos = 'botright '
    exe 'silent keepalt ' . openpos . '40' . 'split ' . s:window_name
    unlet s:window_opening

    call s:InitWindow(autoclose)

    " If the current file exists, but is empty, it means that it had a
    " processing error before opening the window, most likely due to a call to
    " currenttag() in the statusline. Remove the entry so an error message
    " will be shown if the processing still fails.
    " if empty(s:known_files.get(curfile))
    "     call s:known_files.rm(curfile)
    " endif

    " call s:AutoUpdate(curfile, 0)
    " call s:HighlightTag(g:tagbar_autoshowtag != 2, 1, curline)

    " if !(g:tagbar_autoclose || autofocus || g:tagbar_autofocus)
    "     call s:goto_win('p')
    " endif

    " call s:LogDebugMessage('OpenWindow finished')
endfunction

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

" s:InitWindow() {{{2
function! s:InitWindow(autoclose) abort
    " call s:LogDebugMessage('InitWindow called with autoclose: ' . a:autoclose)

    setlocal filetype=requirements

    setlocal noreadonly " in case the "view" mode is used
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nolist
    setlocal nowrap
    setlocal winfixwidth
    setlocal textwidth=0
    setlocal nospell

    " if g:tagbar_show_linenumbers == 0
    "     setlocal nonumber
    "     if exists('+relativenumber')
    "         setlocal norelativenumber
    "     endif
    " elseif g:tagbar_show_linenumbers == 1
    "     setlocal number
    " elseif g:tagbar_show_linenumbers == 2
    "     setlocal relativenumber
    " else
    "     set number<
    "     if exists('+relativenumber')
    "         set relativenumber<
    "     endif
    " endif

    setlocal nofoldenable
    setlocal foldcolumn=0
    " Reset fold settings in case a plugin set them globally to something
    " expensive. Apparently 'foldexpr' gets executed even if 'foldenable' is
    " off, and then for every appended line (like with :put).
    setlocal foldmethod&
    setlocal foldexpr&

    " call s:SetStatusLine('current')

    let s:new_window = 1

    let w:autoclose = a:autoclose

    " if has('balloon_eval')
    "     setlocal balloonexpr=TagbarBalloonExpr()
    "     set ballooneval
    " endif

    let cpoptions_save = &cpoptions
    set cpoptions&vim

    " if !hasmapto('JumpToTag', 'n')
    "     call s:MapKeys()
    " endif

    let &cpoptions = cpoptions_save

    " if g:tagbar_expand
    "     let s:expand_bufnr = bufnr('%')
    " endif

    " call s:LogDebugMessage('InitWindow finished')
endfunction

