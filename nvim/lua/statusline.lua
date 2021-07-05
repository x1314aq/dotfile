-- config status line using lualine
require('lualine').setup {
  options = {
    theme = 'onedark',
    icons_enabled = false,
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {"NvimTree"}
  },
  sections = {
    lualine_c = {'filename', function() return vim.fn['nvim_treesitter#statusline'](30) end},
  }
}
