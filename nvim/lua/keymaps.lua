local utils = require('utils')

-- map <Space> to leader key
utils.map('n', '<Space>', '')
vim.g.mapleader = ' '

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
utils.map('i', '<BS>', '')
utils.map('i', '<Del>', '')

utils.map('n', '<leader>cw', ':cwindow<CR>')
utils.map('n', '<leader>cc', ':cclose<CR>')

fzy = require('fzy')

utils.map('n', '<leader>f', ':lua fzy.execute("fd", fzy.sinks.edit_file)<CR>', {silent = true})
utils.map('n', '<leader>b', ':lua fzy.actions.buffers()<CR>', {silent = true})
