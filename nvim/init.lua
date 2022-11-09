local g = vim.g
local cmd = vim.cmd

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
local scopes = {o = vim.o, bo = vim.bo, wo = vim.wo}

local function setopt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then
    scopes['o'][key] = value
  end
end

setopt("wo", "wrap", false)
setopt("wo", "number", true)
setopt("bo", "expandtab", true)
setopt("bo", "softtabstop", 4)
setopt("bo", "shiftwidth", 4)
setopt("bo", "tabstop", 4)
setopt("bo", "smartindent", true)
setopt("o", "shiftround", true)
setopt("o", "showmatch", true)
setopt("o", "matchtime", 1)
setopt("o", "showmode", false)
setopt("o", "scrolloff", 3)
setopt("o", "smartcase", true)
setopt("o", "splitbelow", true)
setopt("o", "splitright", true)
setopt("o", "wildmode", "list:longest")
setopt("o", "clipboard", "unnamed,unnamedplus")
setopt("o", "updatetime", 300)
setopt("wo", "signcolumn", "number")
setopt("o", "shortmess", "filnxtToOFc")
setopt("o", "termguicolors", true)
setopt("wo", "breakindent", true)
setopt("o", "completeopt", "menuone,noselect")
setopt("wo", "foldmethod", "expr")
setopt("wo", "foldexpr", "nvim_treesitter#foldexpr()")
setopt("wo", "foldenable", false)
setopt("wo", "list", true)
setopt("wo", "listchars", "space:⋅,tab:>-")
setopt("o", "lazyredraw", true)
setopt("o", "mouse", nil)

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function() vim.highlight.on_yank {on_visual = false} end,
})

-- set filetype of .h to c instead of cpp
vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.h",
  command = "set filetype=c",
})

-- set file format to unix on Windows
if jit.os == "Windows" then
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*",
    command = "set ff=unix",
  })
end

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
  if vim.bo.expandtab then
    print('Toggle TAB')
    setopt("bo", "expandtab", false)
    setopt("bo", "softtabstop", 8)
    setopt("bo", "shiftwidth", 8)
    setopt("bo", "tabstop", 8)
  else
    print('Toggle SAPCE')
    setopt("bo", "expandtab", true)
    setopt("bo", "softtabstop", 4)
    setopt("bo", "shiftwidth", 4)
    setopt("bo", "tabstop", 4)
  end
end

vim.keymap.set('n', '<M-t>', toggle_tab)

-- colorscheme
cmd [[colorscheme onedark]]

-- lsp, completion and tree-sitter
require('lsp')

-- snippets
require('snippets')

-- custom input UI
require('ui')
