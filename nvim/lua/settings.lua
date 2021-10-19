local utils = require('utils')

local cmd = vim.cmd

cmd 'syntax enable'
cmd 'filetype plugin indent on'

utils.opt('w', 'wrap', false)
utils.opt('w', 'number', true)
utils.opt('b', 'expandtab', true)
utils.opt('o', 'smarttab', true)
utils.opt('o', 'softtabstop', 4)
utils.opt('o', 'shiftwidth', 4)
utils.opt('o', 'tabstop', 4)

utils.opt('o', 'autoindent', true)
utils.opt('o', 'smartindent', true)
utils.opt('o', 'shiftround', true)

utils.opt('o', 'showmatch', true)
utils.opt('o', 'matchtime', 1)
utils.opt('o', 'showcmd', true)
utils.opt('o', 'showmode', false)
utils.opt('o', 'scrolloff', 3)

utils.opt('o', 'hlsearch', true)
utils.opt('o', 'incsearch', true)
-- utils.opt('o', 'ignorecase', true)
utils.opt('o', 'smartcase', true)

utils.opt('o', 'wildmenu', true)

utils.opt('o', 'foldmethod', 'syntax')
utils.opt('o', 'foldenable', false)
utils.opt('o', 'splitbelow', true)
utils.opt('o', 'splitright', true)

utils.opt('o', 'wildmode', 'list:longest')
utils.opt('o', 'clipboard','unnamed,unnamedplus')

utils.opt('o', 'hidden', true)
utils.opt('o', 'updatetime', 300)
utils.opt('o', 'signcolumn', 'number')
utils.opt('o', 'shortmess', 'filnxtToOFc')

utils.opt('o', 'termguicolors', true)
utils.opt('o', 'inccommand', 'nosplit')

utils.opt('o', 'breakindent', true)
utils.opt('o', 'completeopt', 'menuone,noselect')

utils.opt('w', 'foldmethod', 'expr')
utils.opt('w', 'foldexpr', 'nvim_treesitter#foldexpr()')

-- Highlight on yank
cmd 'au TextYankPost * lua vim.highlight.on_yank {on_visual = false}'
cmd 'au BufNewFile,BufRead *.h set filetype=c'

-- hop.nvim config
require('hop').setup()