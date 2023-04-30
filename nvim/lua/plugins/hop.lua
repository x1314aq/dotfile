return {
  "phaazon/hop.nvim",
  keys = {
    {
      "gw",
      function() require("hop").hint_words() end,
      {silent = true, nowait = true, noremap = true},
    },
  },
  config = true,
}