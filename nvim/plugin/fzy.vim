if exists('g:fzy_loader')
        finish
end
let g:fzy_loader = 1

let s:saved_cpo = &cpo " save user coptions
set cpo&vim " reset to defaults

" Sets the highlight for selected items within the picker.
highlight default link FzySelection Visual
highlight default link FzySelectionCaret FzySelection
highlight default link FzyMultiSelection Type

" "Normal" in the floating windows created by fzy.
highlight default link FzyNormal Normal

" "Normal" in the preview floating windows created by fzy.
highlight default link FzyPreviewNormal Normal

" Border highlight groups.
"   Use FzyBorder to override the default.
"   Otherwise set them specifically
highlight default link FzyBorder FzyNormal
highlight default link FzyPromptBorder FzyBorder
highlight default link FzyResultsBorder FzyBorder
highlight default link FzyPreviewBorder FzyBorder

" Used for highlighting characters that you match.
highlight default link FzyMatching Special

" Used for the prompt prefix
highlight default link FzyPromptPrefix Identifier

" Used for highlighting the matched line inside Previewer. Works only for (vim_buffer_ previewer)
highlight default link FzyPreviewLine Visual
highlight default link FzyPreviewMatch Search

highlight default link FzyPreviewPipe Constant
highlight default link FzyPreviewCharDev Constant
highlight default link FzyPreviewDirectory Directory
highlight default link FzyPreviewBlock Constant
highlight default link FzyPreviewLink Special
highlight default link FzyPreviewSocket Statement
highlight default link FzyPreviewNormal Normal
highlight default link FzyPreviewRead Constant
highlight default link FzyPreviewWrite Statement
highlight default link FzyPreviewExecute String
highlight default link FzyPreviewHyphen NonText
highlight default link FzyPreviewSticky Keyword
highlight default link FzyPreviewSize String
highlight default link FzyPreviewUser Constant
highlight default link FzyPreviewGroup Constant
highlight default link FzyPreviewDate Directory

" Used for Picker specific Results highlighting
highlight default link FzyResultsClass Function
highlight default link FzyResultsConstant Constant
highlight default link FzyResultsField Function
highlight default link FzyResultsFunction Function
highlight default link FzyResultsMethod Method
highlight default link FzyResultsOperator Operator
highlight default link FzyResultsStruct Struct
highlight default link FzyResultsVariable SpecialChar

highlight default link FzyResultsLineNr LineNr
highlight default link FzyResultsIdentifier Identifier
highlight default link FzyResultsNumber Number
highlight default link FzyResultsComment Comment
highlight default link FzyResultsSpecialComment SpecialComment

" Used for git status Results highlighting
highlight default link FzyResultsDiffChange DiffChange
highlight default link FzyResultsDiffAdd DiffAdd
highlight default link FzyResultsDiffDelete DiffDelete
highlight default link FzyResultsDiffUntracked NonText

" Commands
command! -bang FzyFile :lua require('fzy').file()
command! -bang FzyBuffer :lua require('fzy').buffer()

let &cpo = s:saved_cpo " restore user coptions
unlet s:saved_cpo