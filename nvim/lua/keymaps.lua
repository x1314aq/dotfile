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

-- for quickfix windows and location list
utils.map('n', '<leader>cw', '<cmd>copen<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>cc', '<cmd>cclose<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>lw', '<cmd>lopen<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>lc', '<cmd>lclose<CR>', {silent = true, nowait = true})
utils.map('n', ']q', '<cmd>cnext<CR>', {silent = true, nowait = true})
utils.map('n', '[q', '<cmd>cprev<CR>', {silent = true, nowait = true})
utils.map('n', '[Q', '<cmd>cfirst<CR>', {silent = true, nowait = true})
utils.map('n', ']Q', '<cmd>clast<CR>', {silent = true, nowait = true})
utils.map('n', ']l', '<cmd>lnext<CR>', {silent = true, nowait = true})
utils.map('n', '[l', '<cmd>lprev<CR>', {silent = true, nowait = true})
utils.map('n', '[L', '<cmd>lfirst<CR>', {silent = true, nowait = true})
utils.map('n', ']L', '<cmd>llast<CR>', {silent = true, nowait = true})

-- projects maps
--utils.map('n', '<leader>p', '<cmd>lua require("project").projects()<CR>', {silent = true, nowait = true})

--utils.map('n', '<leader>f', ':FzyFile<CR>', {silent = true, nowait = true})
--utils.map('n', '<leader>b', ':FzyBuffer<CR>', {silent = true, nowait = true})
--utils.map('n', '<leader>s', ':FzyGrep ', {nowait = true})
--utils.map('n', '<leader>S', ':FzyGrep! ', {nowait = true})

-- hop.nvim maps
utils.map('', 'gw', '<cmd>lua require("hop").hint_words()<CR>', {silent = true, nowait = true})

-- telescope maps
utils.map('n', '<leader>f', '<cmd>lua require("fuzzy").find_files()<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>b', '<cmd>lua require("fuzzy").buffers()<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>s', '<cmd>lua require("fuzzy").grep_string(false)<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>S', '<cmd>lua require("fuzzy").grep_string(true)<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>t', '<cmd>lua require("fuzzy").global_symbols()<CR>', {silent = true, nowait = true})
utils.map('n', '<leader>a', '<cmd>lua require("fuzzy").local_symbols()<CR>', {silent = true, nowait = true})
utils.map('n', 'gr', '<cmd>lua require("fuzzy").lsp_references()<CR>', {silent = true, nowait = true})
utils.map('n', '<M-o>', '<cmd>lua require("telescope.builtin").resume()<CR>', {silent = true, nowait = true})
