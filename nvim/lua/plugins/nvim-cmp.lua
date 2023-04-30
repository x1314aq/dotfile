return {
  "hrsh7th/nvim-cmp",
  version = false, -- last release is way too old
  -- event = "InsertEnter",
  ft = {"c", "cpp", "lua", "python"},
  dependencies = {
    "hrsh7th/cmp-buffer",
    "saadparwaiz1/cmp_luasnip",
  },
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    return {
      completion = {
        keyword_length = 2
      },
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = {
        ["<C-p>"] = cmp.mapping.select_prev_item(),
        ["<C-n>"] = cmp.mapping.select_next_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-y>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.close(),
        ["<CR>"] = cmp.mapping.confirm {
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
      sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
      }),
    }
  end,
}