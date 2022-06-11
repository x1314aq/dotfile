local g = vim.g
local cmd = vim.cmd
local o, wo, bo = vim.o, vim.wo, vim.bo

g.do_filetype_lua = 1
g.did_load_filetypes = 0

local status, impatient = pcall(require, "impatient")
if status then
  impatient.enable_profile()
end

-- map <Space> to leader key
g.mapleader = ' '
g.maplocalleader = ','

-- disable perl/ruby/node support
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0
if jit.os == "Windows" then
    g.python3_host_prog = "python3.exe"
else
    g.python3_host_prog = "python3"
end

-- disable built-in plugins
g.loaded_gzip = 1
g.loaded_zip = 1
g.loaded_zipPlugin = 1
g.loaded_tar = 1
g.loaded_tarPlugin = 1
g.loaded_getscript = 1
g.loaded_getscriptPlugin = 1
g.loaded_vimball = 1
g.loaded_vimballPlugin = 1
g.loaded_2html_plugin = 1
g.loaded_matchit = 1
g.loaded_matchparen = 1
g.loaded_logiPat = 1
g.loaded_rrhelper = 1
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
g.loaded_netrwSettings = 1

-- basic settings
wo.wrap = false
wo.number = true
bo.expandtab = true
bo.softtabstop = 4
bo.shiftwidth = 4
bo.tabstop = 4

bo.smartindent = true
o.shiftround = true

o.showmatch = true
o.matchtime = 1
o.showmode = false
o.scrolloff = 3

o.smartcase = true

o.splitbelow = true
o.splitright = true

o.wildmode = "list:longest"
o.clipboard = "unnamed,unnamedplus"

o.updatetime = 300
wo.signcolumn = "number"
o.shortmess = "filnxtToOFc"

o.termguicolors = true

wo.breakindent = true
o.completeopt = "menuone,noselect"

wo.foldmethod = "expr"
wo.foldexpr = "nvim_treesitter#foldexpr()"
wo.foldenable = false

wo.list = true
wo.listchars = "space:⋅,tab:>-"
o.lazyredraw = true

-- Highlight on yank
cmd [[au TextYankPost * lua vim.highlight.on_yank {on_visual = false}]]

-- set filetype of .h to c instead of cpp
cmd [[au BufNewFile,BufRead *.h set filetype=c]]

-- packer.nvim commands
cmd [[command! PackerInstall lua require("plugins").install()]]
cmd [[command! PackerUpdate lua require("plugins").update()]]
cmd [[command! PackerSync lua require("plugins").sync()]]
cmd [[command! PackerClean lua require("plugins").clean()]]
cmd [[command! PackerCompile lua require("plugins").compile()]]

-- key mappings
require('keymaps')

-- expand tab of not
local function toggle_tab()
  if bo.expandtab then
    print('Toggle TAB')
    bo.expandtab = false
    bo.softtabstop = 0
    bo.shiftwidth = 8
    bo.tabstop = 8
  else
    print('Toggle SAPCE')
    bo.expandtab = true
    bo.softtabstop = 4
    bo.shiftwidth = 4
    bo.tabstop = 4
  end
end

vim.keymap.set('n', '<M-t>', toggle_tab)

-- colorscheme
cmd [[colorscheme onedark]]

-- lsp, completion and tree-sitter
require('lsp')

-- snippets
require('snippets')
