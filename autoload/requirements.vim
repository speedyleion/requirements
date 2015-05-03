" This is the main functionality for the requirements plug-in.  This handles
" creating, or jumping to, a __Requirements__ window.
" The window has a list of requirements ordered by requirement number.
"
" TODO consider if it is beneficial to list line numbers and then
" requirements.  Thinking this should be requirement based with an easy listing
" of the requirements found in the file.

" Python imports {{{1
let s:script_folder_path = escape( expand( '<sfile>:p:h' ), '\' )
py import sys
" May want to consider prepending this
exe 'python sys.path = sys.path + ["' . s:script_folder_path . '/../misc"]' 
py import requirements
"}}}

" Initialization {{{1
let s:window_name = '__Requirements__'
let s:icon_closed = g:requirements_iconchars[0]
let s:icon_open   = g:requirements_iconchars[1]
let s:short_help      = 1


" s:ToggleHelp() {{{2
function! s:ToggleHelp() abort
    let s:short_help = !s:short_help

    " Prevent highlighting from being off after adding/removing the help text
    match none

    call s:PrintRequirements("foo")

    execute 1
    redraw
endfunction

" s:PrintHelp() {{{2
function! s:PrintHelp() abort
    if !g:requirements_compact && s:short_help
        silent 0put ='\" Press <F1> or ? for help'
        silent  put _
    elseif !s:short_help
        silent 0put ='\" Requirements keybindings'
        silent  put ='\"'
        silent  put ='\" --------- General ---------'
        silent  put ='\" ' . s:get_map_str('jump') . ': Jump to Requirement Tag'
        silent  put ='\" ' . s:get_map_str('preview') . ': As above, but stay in'
        silent  put ='\"    Requirements window'
        silent  put ='\" ' . s:get_map_str('previewwin') . ': Show Requirement in preview window'
        silent  put ='\" ' . s:get_map_str('nexttag') . ': Go to next Requirement tag'
        silent  put ='\" ' . s:get_map_str('prevtag') . ': Go to previous Requirement tag'
        silent  put ='\"'
        silent  put ='\" ---------- Folds ----------'
        silent  put ='\" ' . s:get_map_str('openfold') . ': Open fold'
        silent  put ='\" ' . s:get_map_str('closefold') . ': Close fold'
        silent  put ='\" ' . s:get_map_str('togglefold') . ': Toggle fold'
        silent  put ='\" ' . s:get_map_str('openallfolds') . ': Open all folds'
        silent  put ='\" ' . s:get_map_str('closeallfolds') . ': Close all folds'
        silent  put ='\"'
        silent  put ='\" ---------- Misc -----------'
        silent  put ='\" ' . s:get_map_str('togglesort') . ': Toggle sort'
        silent  put ='\" ' . s:get_map_str('zoomwin') . ': Zoom window in/out'
        silent  put ='\" ' . s:get_map_str('close') . ': Close window'
        silent  put ='\" ' . s:get_map_str('help') . ': Toggle help'
        silent  put _
    endif
endfunction

function! s:get_map_str(map) abort
    let def = get(g:, 'requirements_map_' . a:map)
    if type(def) == type("")
        return def
    else
        return join(def, ', ')
    endif
endfunction

function! s:PrintRequirements(req_tags) abort
    setlocal modifiable
    silent %delete _
    " call s:PrintHelp()

    " Need to figure out what to do about folds, manual or use vim somehow
    if 0 "kindtag.isFolded()
        let foldmarker = s:icon_closed
    else
        let foldmarker = s:icon_open
    endif

    for req in a:req_tags
        echom req
        silent put =foldmarker . ' ' . req.requirement
        silent put =repeat(' ', g:requirements_indent * 2) . req.text
        silent put _
        silent put =repeat(' ', g:requirements_indent * 2) . foldmarker . ' Lines'
        for line in req.lines
            silent put =repeat(' ', g:requirements_indent * 3) . line
        endfor
        silent put _
    endfor
    setlocal nomodifiable
endfunction

function! s:ProcessBuffer(buf_num) abort
    exe 'python requirements.GetRequirementsFromVIM('.a:buf_num.')'
    
    " Not sure about having one function to do it all here...???
    let req_tags = getbufvar(a:buf_num, 'requirements')
    call s:PrintRequirements(req_tags)
endfunction

" s:OpenWindow() {{{2
function! s:OpenWindow(flags) abort

    let autofocus = a:flags =~# 'f'
    let jump      = a:flags =~# 'j'
    let autoclose = a:flags =~# 'c'

    let curfile = fnamemodify(bufname('%'), ':p')
    let buf_num = bufnr('%')
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

    let openpos = g:requirements_top ? 'topleft ' : 'botright '
    exe 'silent keepalt ' . openpos . g:requirements_height . 'split ' .
                \ s:window_name

    call s:InitWindow(autoclose)

    " Return the buffer number of the current file
    return buf_num

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
    setlocal foldmethod=syntax
    setlocal fillchars=
    setlocal foldtext=getline(v:foldstart)
    setlocal foldexpr&

endfunction

" requirements#OpenWindow() {{{1
function! requirements#OpenWindow(...) abort
    let flags = a:0 > 0 ? a:1 : ''
    let l:buf_num =  s:OpenWindow(flags)
    
    call s:ProcessBuffer(l:buf_num)

endfunction

