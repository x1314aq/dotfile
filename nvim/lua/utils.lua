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

local term_buf = -1

function M.toggle_terminal()
  local shell = vim.env.SHELL or 'bash'
  if vim.api.nvim_get_buf_options(0, 'buftype') == 'terminal' then
    vim.api.nvim_win_close(0)
  else
    if term_buf ~= -1 then
      vim.cmd('vertical sb ' .. tostring(term_buf))
    else
      vim.cmd('vs term://' .. shell)
      term_buf = vim.api.nvim_win_get_buf(0)
      vim.api.nvim_buf_set_keymap(term_buf, 't', '<Esc>', '<c-\\><c-n>', {silent = true, nowait = true})
    end
    vim.cmd('startinsert!')
  end
end

return M