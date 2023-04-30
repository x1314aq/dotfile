return {
  "neovim/nvim-lspconfig",
  -- event = "InsertEnter",
  ft = {"c", "cpp", "lua"},
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function(_, opts)
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
          vim.lsp.util.jump_to_location(locs[1], 'utf-8', true)
        else
          vim.fn.setloclist(0, vim.lsp.util.locations_to_items(locs, 'utf-8'))
          vim.api.nvim_command('lopen')
        end
      end
      
      local function find_caller()
        list_or_jump('$ccls/call')
      end
      
      local function find_callee()
        list_or_jump('$ccls/call', {callee = true})
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {noremap = true, silent = true})
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {noremap = true, silent = true})

      local nvim_lsp = require("lspconfig")
      local on_attach = function(client, bufnr)
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
      
        local opts = {noremap = true, silent = true, buffer = bufnr}
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
      
      --  if client.name == 'ccls' then
      --    vim.keymap.set('n', 'gc', find_caller, opts)
      --    vim.keymap.set('n', 'gC', find_callee, opts)
      --  end
      end
      
      if vim.env.ccls_exe then
        nvim_lsp.ccls.setup {
          autostart = true,
          on_attach = on_attach,
          init_options = {
            cache = {directory = ".ccls-cache"}
          },
          capabilities = capabilities,
        }
      elseif vim.env.clangd_exe then
        nvim_lsp.clangd.setup {
          cmd = {
            vim.env.clangd_exe,
            "--header-insertion=never",
          },
          autostart = true,
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end,
}