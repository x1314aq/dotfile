return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      theme = "onedark",
      icons_enabled = false,
      component_separators = '|',
      section_separators = '',
      --disabled_filetypes = {"NvimTree"}
    },
    sections = {
      lualine_b = {"branch"},
      --lualine_c = {ts_indicator}
    },
  }
}