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
Plug 'sainnhe/sonokai'
Plug 'itchyny/lightline.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
" Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'jiangmiao/auto-pairs'
Plug 'justinmk/vim-dirvish'
Plug 'tpope/vim-unimpaired'
Plug 'sheerun/vim-polyglot'
Plug 'jackguo380/vim-lsp-cxx-highlight', {'for': ['cpp', 'c']}
" Plug 'neovim/nvim-lsp'

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

set termguicolors
set inccommand=nosplit


autocmd FileType json syntax match Comment +\/\/.\+$+

" quickfix windows
" unimpaired has mapped [q to :cprev, ]q to :cnext, [Q to :cfirst and ]Q to :clast
nnoremap <leader>cw :cwindow<CR>
nnoremap <leader>cc :cclose<CR>

" for DSA
nnoremap <M-w> :silent vnew term://$SHELL<CR>
nnoremap <M-W> :silent tabnew term://$SHELL<CR>

"colorscheme gruvbox
colorscheme sonokai
set background=dark
"let g:gruvbox_contrast_dark = 'hard'

" lightline config
let g:lightline = {
      \ 'colorscheme': 'sonokai',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'cocstatus', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'cocstatus': 'coc#status'
      \ },
      \ }
autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

" " nvim-lspconfig
" lua <<EOF
"     require'nvim_lsp'.ccls.setup{}
" EOF
"
" set completeopt-=preview
" set omnifunc=v:lua.vim.lsp.omnifunc
"
" " nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
" nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
" " nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
" " nnoremap <silent> gd    <cmd>lua vim.lsp.buf.implementation()<CR>
" nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
" nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
" nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
" nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>

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
nmap <silent> gD <Plug>(coc-declaration)
" nmap <silent> gy <Plug>(coc-type-definition)
" nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" disable CocList
let g:coc_enable_locationlist = 1

" session management
nmap <silent> gi :<C-u>CocList sessions<CR>
nmap <silent> <M-s> :<C-u>CocCommand session.save<CR>
nmap <silent> <M-q> :<C-u>CocCommand session.load<CR>

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

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
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_NoChdir = 1
let g:Lf_JumpToExistingWindow = 0
let g:Lf_IgnoreCurrentBufferName = 1
let g:Lf_NormalMap = {
	\ "File":   [["<ESC>", ':exec g:Lf_py "fileExplManager.quit()"<CR>']],
	\ "Buffer": [["<ESC>", ':exec g:Lf_py "bufExplManager.quit()"<CR>']],
	\ "Mru":    [["<ESC>", ':exec g:Lf_py "mruExplManager.quit()"<CR>']],
	\ "Tag":    [["<ESC>", ':exec g:Lf_py "tagExplManager.quit()"<CR>']],
	\ "Function":    [["<ESC>", ':exec g:Lf_py "functionExplManager.quit()"<CR>']],
	\ "Colorscheme":    [["<ESC>", ':exec g:Lf_py "colorschemeExplManager.quit()"<CR>']],
	\ }

let g:Lf_GtagsAutoGenerate = 0
let g:Lf_GtagsSource = 2
let g:Lf_GtagsSkipUnreadable = 1
let g:Lf_GtagsfilesCmd = {
    \ '.git': 'git ls-files -- "*.c" "*.cpp" "*.h" "*.hpp"',
    \ }

nnoremap <silent> <leader>m  :LeaderfMru<CR>
nnoremap <leader>s :Leaderf! rg -s -e 
nnoremap <leader>S :<C-U><C-R>=printf("Leaderf! rg -w -F -s -e %s", expand("<cword>"))<CR>
nnoremap <silent>go :<C-U>Leaderf! --recall<CR>
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
nnoremap <silent> [s :<C-U>Leaderf --previous<CR>
nnoremap <silent> ]s :<C-U>Leaderf --next<CR>

" auto-pairs config
let g:AutoPairsMapCh = 0
let g:AutoPairsFlyMode = 1
let g:AutoPairsShortcutJump = ''
let g:AutoPairsShortcutFastWrap = ''

" cpp-enhanced-highlight config
" let g:cpp_class_scope_highlight = 1
" let g:cpp_member_variable_highlight = 1
" let g:cpp_class_decl_highlight = 1
" let g:cpp_concepts_highlight = 1

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
