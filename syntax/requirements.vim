" This is the syntax highlighting for requirements buffers.

if exists("b:current_syntax")
    finish
endif

let s:ics = escape(join(g:tagbar_iconchars, ''), ']^\-')
let s:pattern = '\S\@<![' . s:ics . ']\([-+# ]\?\)\@='
execute "syntax match RequirementsFoldIcon '" . s:pattern . "'"

let s:pattern = '\(^[' . s:ics . '] \?\)\@<=[^-+: ]\+[^:]\+$'
execute "syntax match RequirementsKind '" . s:pattern . "'"

syntax match RequirementsLine      '\d' contained
let s:pattern = '\([' . s:ics . '] \?\)\@<=Lines$'
execute "syntax region RequirementsLineGroup matchgroup=RequirementsLineGroupStart start='" . s:pattern . "' end='^$' contains=RequirementsLine" 
highlight default link RequirementsFoldIcon   Statement
highlight default link RequirementsKind       Identifier
highlight default link RequirementsLine       Constant
highlight default link RequirementsLineGroupStart       Comment

let b:current_syntax = "requirements"
