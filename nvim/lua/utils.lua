local M = {}

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

function M.opt(scope, key, value)
    scopes[scope][key] = value
    if scope ~= 'o' then scopes['o'][key] = value end
end

function M.map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

function M.toggle_tab()
    if scopes['b']['expandtab'] then
        print('Toggle TAB')
        M.opt('b', 'expandtab', false)
        M.opt('o', 'softtabstop', 0)
        M.opt('o', 'shiftwidth', 8)
        M.opt('o', 'tabstop', 8)
    else
        print('Toggle SAPCE')
        M.opt('b', 'expandtab', true)
        M.opt('o', 'softtabstop', 4)
        M.opt('o', 'shiftwidth', 4)
        M.opt('o', 'tabstop', 4)
    end
end

return M