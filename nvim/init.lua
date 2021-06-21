local vfn = vim.fn
local cmd = vim.cmd

local Plug = require('pmanager').plug

Plug {'nvim-lua/plenary.nvim', dest='start'}
Plug {'nvim-lua/popup.nvim', dest='start'}
Plug {'neovim/nvim-lspconfig', dest='start'}
Plug {'hrsh7th/nvim-compe', dest='start'}
Plug {'nvim-treesitter/nvim-treesitter', dest='start'}
Plug {'nvim-telescope/telescope.nvim', dest='start'}
Plug {'navarasu/onedark.nvim', dest='start'}
Plug {'hoob3rt/lualine.nvim', dest='start'}
Plug {'kyazdani42/nvim-web-devicons', dest='start'}
-- Plug {'kyazdani42/nvim-tree.lua', dest='start'}
-- Plug {'glepnir/dashboard-nvim', dest='start'}
-- Plug {'phaazon/hop.nvim', dest='start'}  -- easy motion plugin
Plug {'x1314aq/fzy-lua-native', dest='start', url='git@gitee.com:null_803_6688/fzy-lua-native.git'}
-- Sensible defaults
require('settings')

-- key mappings
require('keymaps')

-- colorscheme
require('onedark').setup()
-- statusline
require('lualine').setup {
  options = {
    theme = 'onedark',
    icons_enabled = false,
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {}
  }
}

-- lspconfig related
local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap=true, silent=true}
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
end
nvim_lsp.clangd.setup {
	autostart = false,
	on_attach = on_attach,
}
require'compe'.setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 2,
  preselect = 'disable',
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,
  documentation = false,
  source = {
    path = true,
    nvim_lsp = true,
    nvim_lua = true,
  };
}
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end
local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end
-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap('i', "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap('s', "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap('i', "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap('s', "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})