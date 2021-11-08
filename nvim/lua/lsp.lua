-- lspconfig related
local M = {}

local function list_or_jump(action, opts)
  opts = opts or {}

  local params = vim.lsp.util.make_position_params()
  local result, err = vim.lsp.buf_request_sync(0, action, vim.tbl_extend('error', params, opts), 1000)
  if err then
    vim.api.nvim_err_writeln('Error when executing ' .. action .. ' : ' .. err)
    return
  end

  local locs = {}
  for _, res in pairs(result) do
    vim.list_extend(locs, res.result)
  end

  if #locs == 0 then
    print('empty result from LSP server')
  elseif #locs == 1 then
    vim.lsp.util.jump_to_location(locs[1])
  else
    vim.lsp.util.set_loclist(vim.lsp.util.locations_to_items(locs), 0)
    vim.cmd('lwindow')
  end
end

M.find_caller = function()
  list_or_jump('$ccls/call')
end

M.find_callee = function()
  list_or_jump('$ccls/call', {callee = true})
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local nvim_lsp = require('lspconfig')
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  local opts = {noremap=true, silent=true}
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '[c', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', ']c', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  --vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  if client.name == 'ccls' then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gc', '<cmd>lua require("lsp").find_caller()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gC', '<cmd>lua require("lsp").find_callee()<CR>', opts)
  end
end

if vim.fn.executable("ccls") == 1 then
  print("LSP server is ccls")
  nvim_lsp.ccls.setup {
    autostart = false,
    on_attach = on_attach,
    init_options = {
      cache = {directory = ".ccls-cache"}
    },
    capabilities = capabilities,
  }
elseif vim.fn.executable("clangd") == 1 then
  print("LSP server is clangd")
  nvim_lsp.clangd.setup {
    autostart = false,
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- lua-language-server config
-- need to setup ENVIRONMENT variable to find binary and root path
local sumneko_root_path = vim.env.sumneko_root_path
local sumneko_binary = vim.env.sumneko_binary

if sumneko_binary and sumneko_root_path then
  local runtime_path = vim.split(package.path, ';')
  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require('lspconfig').sumneko_lua.setup {
    autostart = true,
    on_attach = on_attach,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
          -- Setup your lua path
          path = runtime_path,
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          preloadFileSize = 1024,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
else
  print("ENVIRONMENT variable 'sumneko_binary' or 'sumneko_root_path' not set!")
end

-- nvim-cmp config
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-y>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ["<C-j>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<C-k>"] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
  },
  completion = {
    keyword_length = 2,
  },
}

-- nvim-autopairs config
require('nvim-autopairs').setup({
  map_c_w = true,
  enable_check_bracket_line = false,
})

-- treesitter config
require('nvim-treesitter.configs').setup {
  ensure_installed = {"c", "cpp", "lua"},
  highlight = {
    enable = true
  },
  indent = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",

        -- Or you can define your own textobjects like this
        ["iF"] = {
          lua = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
        },
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]f"] = "@function.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
      },
    },
  },
}

return M
