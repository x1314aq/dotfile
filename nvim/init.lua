local vfn = vim.fn
local cmd = vim.cmd

local Plug = require('pmanager').plug

Plug {'nvim-lua/plenary.nvim', dest='start'}
Plug {'nvim-lua/popup.nvim', dest='start'}
Plug {'neovim/nvim-lspconfig', dest='start'}
Plug {'hrsh7th/nvim-compe', dest='start'}
Plug {'nvim-treesitter/nvim-treesitter', dest='start'}
Plug {'nvim-treesitter/nvim-treesitter-textobjects', dest='start'}
Plug {'nvim-telescope/telescope.nvim', dest='start'}
Plug {'navarasu/onedark.nvim', dest='start'}
Plug {'hoob3rt/lualine.nvim', dest='start'}
Plug {'kyazdani42/nvim-web-devicons', dest='start'}
Plug {'kyazdani42/nvim-tree.lua', dest='start'}
Plug {'phaazon/hop.nvim', dest='start'}  -- easy motion plugin
Plug {'romgrk/fzy-lua-native', dest='start'}

-- Sensible defaults
require('settings')

-- key mappings
require('keymaps')

-- colorscheme
require('onedark').setup()

-- statusline
require('statusline')

-- lsp, completion and tree-sitter
require('lsp')

-- fuzzy finder
require('fuzzy')