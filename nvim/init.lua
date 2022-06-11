local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo

g.do_filetype_lua = 1
g.did_load_filetypes = 0

local status, impatient = pcall(require, 'impatient')
if status then
  impatient.enable_profile()
end

-- plugins
cmd [[command! PackerInstall lua require("plugins").install()]]
cmd [[command! PackerUpdate lua require("plugins").update()]]
cmd [[command! PackerSync lua require("plugins").sync()]]
cmd [[command! PackerClean lua require("plugins").clean()]]
cmd [[command! PackerCompile lua require("plugins").compile()]]
require('plugins')

-- Sensible defaults
require('settings')

-- key mappings
require('keymaps')

-- colorscheme
require('onedark').setup {
  style = 'darker'
}
require('onedark').load()
vim.api.nvim_del_keymap('', '<leader>ts')

-- statusline
require('statusline')

-- lsp, completion and tree-sitter
require('lsp')

-- fuzzy finder
require('fuzzy')

-- snippets
require('snippets')
