local g = vim.g
local cmd = vim.cmd

-- map <Space> to leader key
g.mapleader = ' '
g.maplocalleader = ','

-- disable perl/ruby/node support
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0
g.loaded_node_provider = 0
g.loaded_python_provider = 0
g.loaded_python3_provider = 0

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
local function set_ft_c(arg)
  local modifiable = vim.api.nvim_buf_get_option(arg.buf, "modifiable")
  if modifiable then
    vim.api.nvim_buf_set_option(arg.buf, "filetype", "c")
  end
end

vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
  pattern = "*.h",
  callback = set_ft_c,
})

-- set file format to unix on Windows
local function set_ff_unix(arg)
  local modifiable = vim.api.nvim_buf_get_option(arg.buf, "modifiable")
  if modifiable then
    vim.api.nvim_buf_set_option(arg.buf, "fileformat", "unix")
  end
end

if jit.os == "Windows" then
  vim.api.nvim_create_autocmd({"BufNewFile", "BufRead"}, {
    pattern = "*",
    callback = set_ff_unix,
  })
end

-- key mappings
require('keymaps')

-- expand tab or not
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

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  -- bootstrap lazy.nvim
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

require("lazy").setup({
  spec = {
    {import = "plugins"},
  },
  git = {
    timeout = 30
  },
  defaults = {
    lazy = true,
    version = "*",
  },
  install = {
    missing = false,
    coloscheme = {"onedark"},
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
        "vimballPlugin",
      },
    },
  },
})

-- colorscheme
cmd [[colorscheme onedark]]

-- snippets
--require('snippets')

-- custom input UI
require('ui')
