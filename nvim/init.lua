local vfn = vim.fn
local cmd = vim.cmd

local Plug = require('pmanager').plug

Plug {'nvim-lua/plenary.nvim', dest='start'}
Plug {'neovim/nvim-lspconfig', dest='start'}
Plug {'nvim-treesitter/nvim-treesitter', dest='start'}
Plug {'nvim-treesitter/nvim-treesitter-textobjects', dest='start'}
Plug {'nvim-telescope/telescope.nvim', dest='start'}
Plug {'navarasu/onedark.nvim', dest='start'}
Plug {'nvim-lualine/lualine.nvim', dest='start'}
Plug {'phaazon/hop.nvim', dest='start'}  -- easy motion plugin
Plug {'nvim-telescope/telescope-fzy-native.nvim', dest='start'}
Plug {'hrsh7th/cmp-nvim-lsp', dest='start', branch='main'}
Plug {'hrsh7th/cmp-buffer', dest='start', branch='main'}
Plug {'hrsh7th/nvim-cmp', dest='start', branch='main'}
Plug {'L3MON4D3/LuaSnip', dest='start'}
Plug {'saadparwaiz1/cmp_luasnip', dest='start'}
Plug {'lukas-reineke/indent-blankline.nvim', dest='start'}
Plug {'windwp/nvim-autopairs', dest='start'}

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

-- snippets
require('snippets')