local utils = require('utils')

-- map <Space> to leader key
utils.map('n', '<Space>', '')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

utils.map('n', '<Up>', '')
utils.map('n', '<Down>', '')
utils.map('n', '<Left>', '')
utils.map('n', '<Right>', '')
utils.map('n', '<BS>', '')
utils.map('n', '<Del>', '')
utils.map('i', '<Up>', '')
utils.map('i', '<Down>', '')
utils.map('i', '<Left>', '')
utils.map('i', '<Right>', '')
-- utils.map('i', '<BS>', '')
-- utils.map('i', '<Del>', '')

utils.map('n', '<F2>', '<cmd>LspStart<CR>')

-- for quickfix windows and location list
utils.map('n', '<leader>cw', '<cmd>cwindow<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>cc', '<cmd>cclose<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>lw', '<cmd>lwindow<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>lc', '<cmd>lclose<CR>', {silent = true, nowait = true})
utils.map('n', ']q', '<cmd>cnext<CR>', {silent = true, nowait = true})
utils.map('n', '[q', '<cmd>cprev<CR>', {silent = true, nowait = true})
utils.map('n', '[Q', '<cmd>cfirst<CR>', {silent = true, nowait = true})
utils.map('n', ']Q', '<cmd>clast<CR>', {silent = true, nowait = true})
utils.map('n', ']l', '<cmd>lnext<CR>', {silent = true, nowait = true})
utils.map('n', '[l', '<cmd>lprev<CR>', {silent = true, nowait = true})
utils.map('n', '[L', '<cmd>lfirst<CR>', {silent = true, nowait = true})
utils.map('n', ']L', '<cmd>llast<CR>', {silent = true, nowait = true})

utils.map('n', '<M-t>', '<cmd>lua require("utils").toggle_tab()<CR>', {silent = true, nowait = true})
utils.map('n', '<M-w>', '<cmd>vs term://bash<CR>', {silent = true, nowait = true})
utils.map('t', '<Esc>', '<c-\\><c-n>', {silent = true, nowait = true})

--utils.map('n', '<leader>f', ':FzyFile<CR>', {silent = true, nowait = true})
--utils.map('n', '<leader>b', ':FzyBuffer<CR>', {silent = true, nowait = true})
--utils.map('n', '<leader>s', ':FzyGrep ', {nowait = true})
--utils.map('n', '<leader>S', ':FzyGrep! ', {nowait = true})

-- telescope maps
utils.map('n', '<leader>f', '<cmd>lua require("telescope.builtin").find_files({follow=true})<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>b', '<cmd>lua require("telescope.builtin").buffers()<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>s', '<cmd>lua require("telescope.builtin").live_grep({grep_open_files=true)<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>S', '<cmd>lua require("telescope.builtin").grep_string()<CR>', {silent = true, nowait = true})