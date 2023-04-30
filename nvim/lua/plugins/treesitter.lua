return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old and doesn't work on Windows
  ft = {"c", "cpp", "lua", "python"},
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    context_commentstring = { enable = true, enable_autocmd = false },
    ensure_installed = {"c", "cpp", "python", "lua"},
  },
  config = function(_, opts)
      require("nvim-treesitter.configs").setup(opts)
    end,
}