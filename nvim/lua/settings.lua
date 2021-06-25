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
  ["<CR>"]           = tree_cb("edit"),
  ["<C-]>"]          = tree_cb("cd"),
  ["<C-v>"]          = tree_cb("vsplit"),
  ["<C-x>"]          = tree_cb("split"),
  ["<C-t>"]          = tree_cb("tabnew"),
  ["<"]              = tree_cb("prev_sibling"),
  [">"]              = tree_cb("next_sibling"),
  ["<BS>"]           = tree_cb("close_node"),
  ["<S-CR>"]         = tree_cb("close_node"),
  ["<Tab>"]          = tree_cb("preview"),
  ["I"]              = tree_cb("toggle_ignored"),
  ["H"]              = tree_cb("toggle_dotfiles"),
  ["R"]              = tree_cb("refresh"),
  ["a"]              = tree_cb("create"),
  ["d"]              = tree_cb("remove"),
  ["r"]              = tree_cb("rename"),
  ["<C-r>"]          = tree_cb("full_rename"),
  ["x"]              = tree_cb("cut"),
  ["c"]              = tree_cb("copy"),
  ["p"]              = tree_cb("paste"),
  ["y"]              = tree_cb("copy_name"),
  ["Y"]              = tree_cb("copy_path"),
  ["gy"]             = tree_cb("copy_absolute_path"),
  ["[c"]             = tree_cb("prev_git_item"),
  ["]c"]             = tree_cb("next_git_item"),
  ["-"]              = tree_cb("dir_up"),
  ["q"]              = tree_cb("close"),
}