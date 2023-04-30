return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    char = '|',
    buftype_exclude = {'terminal'},
    space_char_blankline = ' ',
  },
}