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

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'c.doxygen', 'cpp', 'cpp.doxygen', 'python'], 'do': './install.py --clang-completer'}
Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'jsfaint/gen_tags.vim'
Plug 'Shougo/echodoc.vim', {'for': ['c', 'cpp']}
Plug 'jiangmiao/auto-pairs'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim'] }
Plug 'dyng/ctrlsf.vim'
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

augroup project
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
augroup end

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

" YCM config
let g:ycm_confirm_extra_conf = 0
let g:ycm_use_ultisnips_completer = 0
let g:ycm_auto_start_csharp_server = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
let g:ycm_min_num_of_chars_for_completion = 999
let g:ycm_goto_buffer_command = 'same-buffer'
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
noremap <c-z> <NOP>
nnoremap <leader>gd :YcmCompleter GoTo<CR>

let g:ycm_semantic_triggers =  {
                               \ 'c,cpp,python': ['re!\w{2}'],
                               \ }

" gen_tags config
let g:gen_tags#ctags_opts = ['--fields=+niazS', '--extras=+q', '--kinds-C=+px', '--kinds-C++=+pxNUA']
let g:gen_tags#gtags_opts = ['-c', '--verbose', '--sqlite3']
let g:gen_tags#ctags_auto_gen = 1
let g:gen_tags#gtags_auto_gen = 1

" echodoc config
let g:echodoc_enable_at_startup = 1

" LeaderF config
let g:Lf_RootMarkers = ['.git', '.root']
let g:Lf_DefaultMode = 'NameOnly'
let g:LF_WildIgnore = {
        \  'dir': ['.svn', '.git'],
        \  'file': ['*.so', '*.o', '*.a']
        \  }
let g:Lf_Ctags = "/usr/local/bin/ctags"
let g:Lf_CtagsFuncOpts = {
        \  'c': '--kinds-C=+px',
        \  'c++': '--kinds-C++=+pxNUA',
        \  }
let g:Lf_DefaultExternalTool = "ag"
let g:Lf_HideHelp = 1
let g:Lf_ShowHidden = 1
let g:Lf_WorkingDirectoryMode = 'Ac'
nnoremap <leader>m  :LeaderfMru<CR>
nnoremap <leader>a  :LeaderfFunction!<CR>
nnoremap <leader>t  :LeaderfTag<CR>
let g:Lf_NormalMap = {
	\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
	\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
	\ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
	\ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
	\ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
	\ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
	\ }

" CtrlSF config
let g:ctrlsf_search_mode = 'async'
let g:ctrlsf_ackprg = 'ag'
let g:ctrlsf_confirm_save = 0
let g:ctrlsf_default_root = 'project+fw'
let g:ctrlsf_absolute_file_path = 0
let g:ctrlsf_extra_root_marker = ['.root', '.project']
let g:ctrlsf_default_view_mode = 'normal'
let g:ctrlsf_case_sensitive = 'yes'
let g:ctrlsf_auto_focus = {
    \  "at": "done",
    \  "duration_less_than": 1000,
    \  }
nmap <leader>s <Plug>CtrlSFPrompt
nmap <leader>S <Plug>CtrlSFCwordPath
vmap <leader>s <Plug>CtrlSFVwordExec
vmap <leader>S <Plug>CtrlSFVwordPath

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
