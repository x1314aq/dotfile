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

set termguicolors
set background=dark
set laststatus=2

packadd! sonokai
let g:sonokai_disable_italic_comment = 1
silent! colorscheme sonokai

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

nnoremap <leader>t :tag 
nnoremap <leader>T :tselect 
nnoremap <silent> <leader>cw  :cwindow<CR>
nnoremap <silent> <leader>cc  :cclose<CR>
