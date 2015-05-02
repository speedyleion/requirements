" This is the syntax highlighting for requirements buffers.

if exists("b:current_syntax")
    finish
endif

let s:ics = escape(join(g:tagbar_iconchars, ''), ']^\-')
let s:pattern = '\S\@<![' . s:ics . ']\([-+# ]\?\)\@='
execute "syntax match RequirementsFoldIcon '" . s:pattern . "'"

let s:pattern = '\(^[' . s:ics . '] \?\)\@<=[^-+: ]\+[^:]\+$'
let s:end_pattern = '\(^[' . s:ics . '] \?\)\@='
execute "syntax region RequirementsBlock matchgroup=RequirementsKind start ='" . s:pattern . "' end='" . s:end_pattern . "' fold transparent"

syntax match RequirementsLine      '\d' contained
let s:pattern = '\([' . s:ics . '] \?\)\@<=Lines$'
execute "syntax region RequirementsLineBlock matchgroup=RequirementsLineGroupStart start='" . s:pattern . "' end='^$' contains=RequirementsLine fold" 
highlight default link RequirementsFoldIcon   Statement
highlight default link RequirementsKind       Identifier
highlight default link RequirementsLine       Constant
highlight default link RequirementsLineBlockStart       Comment

let b:current_syntax = "requirements"
