local fn = vim.fn
local cmd = vim.cmd

vim.g.python3_host_prog = 'C:/Users/sapphire/AppData/Local/Programs/Python/Launcher/py.exe'

-- Sensible defaults
require('settings')

-- key mappings
require('keymaps')

-- statusline
--require('statusline')

local Plug = require('pmanager').plug

Plug 'neovim/nvim-lspconfig'
Plug 'nvim-lua/completion-nvim'
Plug 'nvim-treesitter/nvim-treesitter'