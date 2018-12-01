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
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'cpp', 'python'], 'do': './install.py --clang-completer'}
Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'w0rp/ale', {'for': ['c', 'cpp', 'python']}
Plug 'ludovicchabant/vim-gutentags'
Plug 'sbdchd/neoformat'
Plug 'Shougo/echodoc.vim', {'for': ['c', 'cpp']}
Plug 'jiangmiao/auto-pairs'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim'] }
Plug 'dyng/ctrlsf.vim'
Plug 'terryma/vim-multiple-cursors'
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
set number           " show line number
set relativenumber   " show relative number
set expandtab        " use SPACE instead of TAB when insert TAB
set softtabstop=4    " treat 4 continuous spaces as a TAB
set tabstop=4        " 1 TAB = 4 SPACEs

set autoindent       " auto indent 
set showmatch        " briefly jump to the matching one when a bracket is inserted 
set matchtime=3
set nobackup         " do not keep a backup file
set showcmd          " display incomplete commands
set hlsearch         " highlight search results
set incsearch        " do incremental search
set ignorecase       " ignore case when searching
set smartcase        " no ignorecase if Uppercase char present

set wildmenu         " enhanced auto-completion in COMMAND mode
set cursorline       " hightlight current line

set foldmethod=syntax " syntax highlighting items specify folds
set nofoldenable      " disable fold when start neovim
set splitright        " splitting a window will put it right of the current one
set noshowmode        " disable mode prompt in left bottom corner
set nrformats=        " treat all numbers as decimal

" colorscheme dracula
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'

" lightline config
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" NERDcommenter config
let g:NERDSpaceDelims = 0
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAligh = 'left'
let g:NERDTrimTrailingWhitespace = 1

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

let g:ycm_filetype_whitelist = {
                               \ 'c': 1,
                               \ 'cpp': 1,
                               \ 'python': 1
                               \ }

" vim-gutentags config
let g:gutentags_project_root = ['.git', '.svn', '.root', '.hg', '.project']
let g:gutentags_ctags_tagfile = '.tags'
let s:vim_tags = expand('~/.cache/tags')
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_exclude_filetypes = ['vim', 'text', 'sh', 'cmake', 'json', 'make']
let g:gutentags_modules = ['ctags']
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extras=+q', '--kinds-C++=+pxNUA', '--kinds-C=+px']
let g:gutentags_define_advanced_commands = 1
augroup MyGutentagsStatusLineRefresher
    autocmd!
    autocmd User GutentagsUpdating call lightline#update()
    autocmd User GutentagsUpdated call lightline#update()
augroup END
let g:gutentags_file_list_command = {
            \  'markers': {
                \  '.git': 'git ls-files',
                \  '.hg': 'hg files',
                \  }
            \  }
if !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif

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

" ale config
let g:airline#extensions#ale#enabled = 0
let g:ale_sign_column_always = 1
let g:ale_linters_explicit = 1
let g:ale_echo_msg_format = '[%linter%] [%severity%] %s'
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 0
if uname == 'Darwin'
    let g:ale_linters = {
            \  'c': ['clang'],
            \  'cpp': ['clang'],
            \  'python': ['pylint'],
            \  }
elseif uname == 'Linux'
    let g:ale_linters = {
            \  'c': ['gcc'],
            \  'cpp': ['gcc'],
            \  'python': ['pylint'],
            \  }
endif
nmap <silent> <C-n> <Plug>(ale_next_wrap)
nmap <silent> <S-n> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_detail)
let g:ale_c_parse_compile_commands = 1
if uname == 'Darwin'
    let g:ale_c_clang_options = '-std=gnu99 -m32 -Wall -Wextra -pedantic -Werror'
    let g:ale_cpp_clang_options = '-std=c++11 -Wall -Wextra -pedantic -Werror'
elseif uname == 'Linux'
    let g:ale_c_gcc_options = '-std=gnu99 -m32 -Wall -Wextra -pedantic -Werror'
    let g:ale_cpp_gcc_options = '-std=c++11 -Wall -Wextra -pedantic -Werror'
endif

" cpp-enhanced-highlight config
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1

" vim-multiple-cursors config
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_start_word_key = '<C-j>'
let g:multi_cursor_select_all_word_key = '<M-j>'
let g:multi_cursor_start_key = 'g<C-j>'
let g:multi_cursor_select_all_key = 'g<M-j>'
let g:multi_cursor_next_key = '<C-j>'
let g:multi_cursor_prev_key = '<C-k>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<Esc>'

" Called once right before/after starting selecting multiple cursors
command! YcmUnlock call youcompleteme#EnableCursorMovedAutocommands()
command! YcmLock call youcompleteme#DisableCursorMovedAutocommands()

function! Multiple_cursors_before()
  if &ft == 'c' || &ft == 'cpp'
    exe 'YcmLock'
    exe 'ALEDisable'
  endif
endfunction

function! Multiple_cursors_after()
  if &ft == 'c' || &ft == 'cpp'
    exe 'YcmUnlock'
    exe 'ALEEnable'
  endif
endfunction
