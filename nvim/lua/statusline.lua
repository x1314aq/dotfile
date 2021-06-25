-- config status line using lualine
require('lualine').setup {
  options = {
    theme = 'onedark',
    icons_enabled = false,
    component_separators = "|",
    section_separators = "",
    disabled_filetypes = {"NvimTree"}
  }
}