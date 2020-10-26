set nocompatible        " use vim defaults
set scrolloff=3         " keep 3 lines when scrolling
set ai                  " set auto-indenting on for programming

set matchtime=1         " tenths of a second (100ms) to show the matching parenthesis
set showcmd             " display incomplete commands
set nobackup            " do not keep a backup file
set number              " show line numbers
set ruler               " show the current row and column

set hlsearch            " highlight searches
set incsearch           " do incremental searching
set showmatch           " jump to matches when entering regexp
set ignorecase          " ignore case when searching
set smartcase           " no ignorecase if Uppercase char present

set visualbell t_vb=    " turn off error beep/flash
set novisualbell        " turn off visual bell

set backspace=indent,eol,start  " make that backspace key work the way it should
set runtimepath=$VIMRUNTIME     " turn off user scripts, https://github.com/igrigorik/vimgolf/issues/129

syntax on               " turn syntax highlighting on by default
filetype on             " detect type of file
filetype indent on      " load indent file for specific file type

set tabstop=4
set shiftwidth=4
set expandtab

set splitright
set wildmenu
set noesckeys

if &term =~# '256color' && ( &term =~# '^screen'  || &term =~# '^tmux' )
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

set termguicolors
set background=dark
set laststatus=2

packadd! dracula
packadd! sonokai
packadd! vim-polyglot
packadd! LeaderF
packadd! lightline
let g:sonokai_disable_italic_comment = 1
silent! colorscheme sonokai

set enc=utf-8
set fileencodings=utf-8,gbk,big5,gb18030,latin1

nnoremap <Space>  <Nop>
let mapleader=" "
if executable("rg")
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
endif

nnoremap <silent> [q  :cprev<CR>
nnoremap <silent> ]q  :cnext<CR>
nnoremap <silent> [Q  :cfirst<CR>
nnoremap <silent> ]Q  :clast<CR>
nnoremap <silent> [a  :prev<CR>
nnoremap <silent> ]a  :next<CR>
nnoremap <silent> [A  :first<CR>
nnoremap <silent> ]A  :last<CR>
nnoremap <silent> [b  :bp<CR>
nnoremap <silent> ]b  :bn<CR>
nnoremap <silent> [B  :bfirst<CR>
nnoremap <silent> ]B  :blast<CR>
nnoremap <silent> [l  :lprev<CR>
nnoremap <silent> ]l  :lnext<CR>
nnoremap <silent> [L  :lfirst<CR>
nnoremap <silent> ]L  :llast<CR>
nnoremap <silent> [t  :tprevious<CR>
nnoremap <silent> ]t  :tnext<CR>
nnoremap <silent> [T  :tfirst<CR>
nnoremap <silent> ]T  :tlast<CR>

nnoremap <silent> <leader>cw  :cwindow<CR>
nnoremap <silent> <leader>cc  :cclose<CR>

" lightline config
let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ]
      \ },
      \ }

" LeaderF config
let g:Lf_WindowPosition = 'popup'
let g:Lf_RootMarkers = ['.git', '.ccls', 'compile_commands.json', '.vim']
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_WildIgnore = {
        \  'dir': ['.svn', '.git', '.ccls-cache'],
        \  'file': ['*.so', '*.o', '*.a']
        \  }
let g:Lf_DefaultExternalTool = "rg"
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_WorkingDirectoryMode = 'c'
let g:Lf_NoChdir = 1
nnoremap <silent> <leader>m  :LeaderfMru<CR>
let g:Lf_NormalMap = {
	\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
	\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
	\ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
	\ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
	\ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
	\ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
	\ }

nnoremap <leader>s :Leaderf! rg -s -e 
nnoremap <leader>S :<C-U><C-R>=printf("Leaderf! rg -F -s -e %s ", expand("<cword>"))<CR>
nnoremap <silent>go :<C-U>Leaderf! --recall<CR>
let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsSource = 2
let g:Lf_GtagsSkipUnreadable = 1
let g:Lf_GtagsfilesCmd = {
    \ '.git': 'git ls-files -- "*.c" "*.cpp" "*.h" "*.hpp"',
    \ }

nnoremap <leader>t :tag 
nnoremap <leader>T :Leaderf tag<CR>
nnoremap <silent> <Leader>a :LeaderfBufTag<CR>
nnoremap <silent> <C-\>a :Leaderf gtags --all --result=ctags-x<CR>
nnoremap <silent> <C-\>s :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -s %s", expand("<cword>"))<CR><CR>
nnoremap <silent> <C-\>c :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -r %s", expand("<cword>"))<CR><CR>
nnoremap <silent> <C-\>d :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -d %s", expand("<cword>"))<CR><CR>
nnoremap <C-\>D :Leaderf! gtags --auto-jump -d 
nnoremap <C-\>S :Leaderf! gtags --auto-jump -s 
nnoremap <C-\>C :Leaderf! gtags --auto-jump -r 
nnoremap <silent> <leader>: :Leaderf cmdHistory<CR>
nnoremap <silent> <leader>/ :Leaderf searchHistory<CR>
let g:Lf_IgnoreCurrentBufferName = 1
nnoremap <silent> [s :<C-U>Leaderf --previous<CR>
nnoremap <silent> ]s :<C-U>Leaderf --next<CR>
let g:Lf_JumpToExistingWindow = 0

" open tag in new tab
nnoremap <silent> <leader><C-]> <C-w><C-]><C-w>T

function ToggleTab()
    if &expandtab
        echo "Toggle TAB"
        set expandtab!
        set softtabstop=0
        set shiftwidth=8
        set tabstop=8
    else
        echo "Toggle SPACE"
        set expandtab
        set softtabstop=4
        set shiftwidth=4
        set tabstop=4
    endif
endfunction

nmap <silent> <M-t> :call ToggleTab()<CR>
