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

-- options for nvim-tree.lua
vim.g.nvim_tree_width = 40
vim.g.nvim_tree_ignore = {'.git', '.cache', '.ccls-cache'}
vim.g.nvim_tree_hide_dotfiles = 1
vim.g.nvim_tree_auto_close = 1
vim.g.nvim_tree_follow = 1
vim.g.nvim_tree_hijack_cursor = 1
vim.g.nvim_tree_update_cwd = 1
vim.g.nvim_tree_show_icons = {git = 0, folders = 1, files = 0, folder_arrows = 1}

local tree_cb = require('nvim-tree.config').nvim_tree_callback
vim.g.nvim_tree_bindings = {
  -- default mappings
  { key = {"<CR>", "o"},                  cb = tree_cb("edit") },
  { key = "<C-]>",                        cb = tree_cb("cd") },
  { key = "<C-v>",                        cb = tree_cb("vsplit") },
  { key = "<C-x>",                        cb = tree_cb("split") },
  { key = "<C-t>",                        cb = tree_cb("tabnew") },
  { key = "<",                            cb = tree_cb("prev_sibling") },
  { key = ">",                            cb = tree_cb("next_sibling") },
  { key = "P",                            cb = tree_cb("parent_node") },
  { key = "<BS>",                         cb = tree_cb("close_node") },
  { key = "<S-CR>",                       cb = tree_cb("close_node") },
  { key = "<Tab>",                        cb = tree_cb("preview") },
  { key = "K",                            cb = tree_cb("first_sibling") },
  { key = "J",                            cb = tree_cb("last_sibling") },
  { key = "I",                            cb = tree_cb("toggle_ignored") },
  { key = "H",                            cb = tree_cb("toggle_dotfiles") },
  { key = "R",                            cb = tree_cb("refresh") },
  { key = "a",                            cb = tree_cb("create") },
  { key = "d",                            cb = tree_cb("remove") },
  { key = "r",                            cb = tree_cb("rename") },
  { key = "<C-r>",                        cb = tree_cb("full_rename") },
  { key = "x",                            cb = tree_cb("cut") },
  { key = "c",                            cb = tree_cb("copy") },
  { key = "p",                            cb = tree_cb("paste") },
  { key = "y",                            cb = tree_cb("copy_name") },
  { key = "Y",                            cb = tree_cb("copy_path") },
  { key = "gy",                           cb = tree_cb("copy_absolute_path") },
  { key = "[c",                           cb = tree_cb("prev_git_item") },
  { key = "]c",                           cb = tree_cb("next_git_item") },
  { key = "-",                            cb = tree_cb("dir_up") },
  { key = "q",                            cb = tree_cb("close") },
  { key = "g?",                           cb = tree_cb("toggle_help") },
}

-- hop.nvim config
require('hop').setup()
