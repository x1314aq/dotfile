local hop = require("hop")

hop.setup()

vim.keymap.set('n', 'gw', function() hop.hint_words() end, {silent = true, nowait = true, noremap = true})