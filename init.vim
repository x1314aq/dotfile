set nocompatible    " disable vi compatible mode

nnoremap <Space> <Nop>
let mapleader=" "
let uname = substitute(system('uname'), '\n', '', '')

if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.nvim')

Plug 'gruvbox-community/gruvbox'
Plug 'itchyny/lightline.vim'
" Plug 'Valloric/YouCompleteMe', {'for': ['c', 'c.doxygen', 'cpp', 'cpp.doxygen', 'python'], 'do': './install.py --clangd-completer'}
Plug 'neoclide/coc.nvim', {'tag': '*', 'branch': 'release'}
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
" Plug 'jsfaint/gen_tags.vim'
" Plug 'Shougo/echodoc.vim', {'for': ['c', 'cpp']}
Plug 'jiangmiao/auto-pairs'
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim'] }
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-unimpaired'

call plug#end()

" Disable arrow key
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <BS> <Nop>
noremap <Del> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <BS> <Nop>
inoremap <Del> <Nop>

" neovim specifications
syntax on
filetype on
filetype indent on

set number                    " show line number
set relativenumber            " show relative number

set expandtab                 " use SPACE instead of TAB when insert TAB
set smarttab                  "
set softtabstop=4             " treat 4 continuous SPACEs as a TAB
set shiftwidth=4              " use 4 SPACEs when auto format
set tabstop=4                 " 1 TAB = 4 SPACEs

set autoindent                " auto indent
set smartindent               " do smart auto-indent when starting a new line
set shiftround                " round indent to multiple of 'shiftwidth'

set showmatch                 " briefly jump to the matching one when a bracket is inserted
set matchtime=1               " tenths of a second (100ms) to show the matching parenthesis
set nobackup                  " do not keep a backup file
set novisualbell              " turn off visual bell
set visualbell t_vb=          " turn off error beep/flush
set showcmd                   " display incomplete commands
set noshowmode                " do not display current mode because we use lightline.vim instead
set scrolloff=3               " keep 3 lines when scrolling

set hlsearch                  " highlight search results
set incsearch                 " do incremental search
set ignorecase                " ignore case when searching
set smartcase                 " no ignorecase if Uppercase char present

set wildmenu                  " enhanced auto-completion in COMMAND mode
set cursorline                " hightlight current line

set foldmethod=syntax         " syntax highlighting items specify folds
set nofoldenable              " disable fold when start neovim
set splitright                " splitting a window will put it right of the current one
set nrformats=                " treat all numbers as decimal

set hidden
set updatetime=300
set signcolumn=yes
set shortmess+=c

augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
    autocmd BufRead,BufNewFile *.m set filetype=objc
augroup end

autocmd FileType json syntax match Comment +\/\/.\+$+

" quickfix windows
" unimpaired has mapped [q to :cprev, ]q to :cnext, [Q to :cfirst and ]Q to :clast
nnoremap <leader>cw :cwindow<CR>
nnoremap <leader>cc :cclose<CR>

" for DSA
nnoremap <M-w> :silent vnew term://zsh<CR>
nnoremap <M-r> :silent !clang++ -std=c++11 -O0 -g -fsanitize=address % -o qwe<CR>
nnoremap <M-c> :silent !rm -rf qwe*<CR>

" colorscheme dracula
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'

" lightline config
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             ['readonly', 'filename', 'modified' ] ]
      \ },
      \ }

" coc.nvim config
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" close the preview window when completion is done
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" show signature after jump to next placeholder
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" Use `[c` and `]c` to navigate diagnostics
nmap <silent> [c <Plug>(coc-diagnostic-prev)
nmap <silent> ]c <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
" nmap <silent> gD <Plug>(coc-declaration)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> go :<C-u>CocListResume<CR>

" disable CocList
let g:coc_enable_locationlist = 1

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" " echodoc config
" let g:echodoc#enable_at_startup = 1
" let g:echodoc#type = 'virtual'

" LeaderF config
let g:Lf_RootMarkers = ['.git', '.ccls', 'compile_commands.json', '.vim']
let g:Lf_DefaultMode = 'NameOnly'
let g:LF_WildIgnore = {
        \  'dir': ['.svn', '.git', '.ccls-cache'],
        \  'file': ['*.so', '*.o', '*.a']
        \  }
let g:Lf_Ctags = "/usr/local/bin/ctags"
let g:Lf_CtagsFuncOpts = {
        \  'c': '--kinds-C=+px',
        \  'c++': '--kinds-C++=+pxNUA',
        \  }
let g:Lf_DefaultExternalTool = "rg"
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_NoChdir = 1
nnoremap <leader>m  :LeaderfMru<CR>
nnoremap <leader>a  :LeaderfFunction!<CR>
" nnoremap <leader>t  :LeaderfTag<CR>
let g:Lf_NormalMap = {
	\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
	\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
	\ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
	\ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
	\ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
	\ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
	\ }

nnoremap <leader>s :Leaderf! rg -ws -e 
" search word under cursor literally and enter normal mode directly
nnoremap <leader>S :<C-U><C-R>=printf("Leaderf! rg -Fs -e %s ", expand("<cword>"))<CR>
" recall last search. If the result window is closed, reopen it.
nnoremap <M-o> :<C-U>Leaderf! rg --recall<CR>
" automatically generate tags file
let g:Lf_GtagsAutoGenerate = 1
let g:Lf_GtagsSkipUnreadable = 1
nnoremap <leader>t :Leaderf! gtags --auto-jump -d 
nnoremap <M-i> :<C-U>Leaderf! gtags --recall<CR>
nnoremap <C-\>s :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -s %s", expand("<cword>"))<CR><CR>
nnoremap <C-\>c :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -r %s", expand("<cword>"))<CR><CR>
nnoremap <C-]>  :<C-U><C-R>=printf("Leaderf! gtags --literal --auto-jump -d %s", expand("<cword>"))<CR><CR>

" auto-pairs config
let g:AutoPairsMapCh = 0
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutFastWrap = ''

" cpp-enhanced-highlight config
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1
