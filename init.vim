set nocompatible

let mapleader=";"

call plug#begin('~/.nvim')

Plug 'morhetz/gruvbox'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'Valloric/YouCompleteMe', {'for': ['c', 'cpp', 'python']}
Plug 'rdnetto/YCM-Generator', {'branch': 'stable'}
Plug 'scrooloose/nerdcommenter'
Plug 'Yggdroot/LeaderF'
Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
Plug 'w0rp/ale', {'for': ['c', 'cpp', 'python']}
Plug 'jsfaint/gen_tags.vim'
Plug 'sbdchd/neoformat'
Plug 'Shougo/echodoc.vim', {'for': ['c', 'cpp']}
Plug 'jiangmiao/auto-pairs'
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-syntax'
Plug 'kana/vim-textobj-function', { 'for':['c', 'cpp', 'vim', 'java'] }
Plug 'sgur/vim-textobj-parameter'
Plug 'wsdjeg/FlyGrep.vim'

call plug#end()

" neovim specifications
set number
" set relativenumber   " 显示相对行号
set expandtab        " 将tab扩展为空格
set softtabstop=4    " 让neovim把连续4个空格视为一个tab
set shiftwidth=4     " 设置格式化时tab占用的空格数
set tabstop=4        " 设置编辑时tab占用的空格数

" set nowrap           " 当一行文字过长时不自动折行
set showmatch

set nohlsearch       " 不高亮搜索结果
set incsearch        " 开启实时搜索功能
" set ignorecase       " 搜索时忽略大小写

set wildmenu         " neovim自身命令行模式智能补全
set cursorline       " 高亮当前行

set foldmethod=syntax " 基于缩进或语法进行代码折叠
set nofoldenable      " 启动neovim时关闭代码折叠
set splitright
set noshowmode

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
let g:ycm_use_ultisnips_completer = 0
let g:ycm_auto_start_csharp_server = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_complete_in_strings = 1
let g:ycm_min_num_of_chars_for_completion = 999
let g:ycm_goto_buffer_command = 'split'
let g:ycm_key_invoke_completion = '<c-z>'
set completeopt-=preview
let g:ycm_add_preview_to_completeopt = 0
noremap <c-z> <NOP>

let g:ycm_semantic_triggers =  {
                               \ 'c,cpp,python': ['re!\w{2}'],
                               \ }

let g:ycm_filetype_whitelist = {
                               \ 'c': 1,
                               \ 'cpp': 1,
                               \ 'h': 1,
                               \ 'hpp': 1,
                               \ 'python': 1
                               \ }

" gen_tags config
let g:loaded_gentags#ctags = 1
let g:gen_tags#ctags_bin = '/usr/local/bin/ctags'
let g:gen_tags#gtags_bin = '/usr/local/bin/gtags'
let g:gen_tags#global_bin = '/usr/local/bin/gtags'
let g:gen_tags#use_cache_dir = 0

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
        \  'c': '--c-kinds=fp',
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

" FlyGrep config
nnoremap <leader>s :FlyGrep<CR>
let g:FlyGrep_input_delay = 100
let g:FlyGrep_search_tools = ['ag']

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
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = {
        \  'c': ['clang'],
        \  'cpp': ['clang'],
        \  'python': ['pylint'],
        \  }
nmap <silent> <C-n> <Plug>(ale_next_wrap)
nmap <silent> <S-n> <Plug>(ale_previous_wrap)
nmap <silent> <C-m> <Plug>(ale_detail)
let g:ale_c_clang_options = '-std=gnu99 -Wall -Wextra -pedantic'
let g:ale_cpp_clang_options = '-std=c++11 -Wall -Wextra -pedantic'

" cpp-enhanced-highlight config
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_concepts_highlight = 1
