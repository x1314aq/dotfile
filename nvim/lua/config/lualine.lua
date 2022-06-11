-- config status line using lualine
-- TODO: lpeg based function signature parsing

--local function ts_indicator()
--  local transform_fn = function(str)
--    local name = nil
--    local ft = vim.bo.filetype
--    if ft == 'c' or ft == 'cpp' then
--      name = string.match(str, "([a-zA-Z0-9_]+)%s*%(")
--    end
--    return name or str
--  end
--  local opts = {
--    indicator_size = 30,
--    transform_fn = transform_fn,
--  }
--  return require('nvim-treesitter').statusline(opts)
--end

require("lualine").setup {
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
  }
}