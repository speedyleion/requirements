" This is the syntax highlighting for requirements buffers.

if exists("b:current_syntax")
    finish
endif

let s:ics = escape(join(g:tagbar_iconchars, ''), ']^\-')
let s:pattern = '\S\@<![' . s:ics . ']\([-+# ]\?\)\@='
execute "syntax match RequirementsFoldIcon '" . s:pattern . "'"

let s:pattern = '\(^[' . s:ics . '] \?\)\@<=[^-+: ]\+[^:]\+$'
execute "syntax match RequirementsKind '" . s:pattern . "'"

syntax match RequirementsHelp      '^".*' contains=RequirementsHelpKey,RequirementsHelpTitle
syntax match RequirementsHelpKey   '" \zs.*\ze:' contained
syntax match RequirementsHelpTitle '" \zs-\+ \w\+ -\+' contained

highlight default link RequirementsHelp       Comment
highlight default link RequirementsHelpKey    Identifier
highlight default link RequirementsHelpTitle  PreProc
highlight default link RequirementsFoldIcon   Statement
highlight default link RequirementsHighlight  Search
highlight default link RequirementsKind       Identifier

let b:current_syntax = "requirements"
