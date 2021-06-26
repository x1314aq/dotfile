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

local function popup_create()
  local columns = vim.api.nvim_get_option('columns')
  local lines = vim.api.nvim_get_option('lines')
  local opts = {
    relative = 'editor',
    style = 'minimal',
    height = math.floor(lines * 0.8),
    width = math.floor(columns * 0.8),
    row = math.floor(lines * 0.1),
    col = math.floor(columns * 0.1),
    border = 'single',
    noautocmd = true,
  }
  local win = vim.api.nvim_open_win(term_buf, true, opts)
  vim.api.nvim_win_set_option(win,  'winhl', 'Normal:Normal')
end

function M.toggle_terminal(exited)
  local shell = vim.env.SHELL or 'bash'
  if vim.api.nvim_buf_get_option(0, 'buftype') == 'terminal' then
    vim.api.nvim_win_close(0, true)
    if exited == true then
      vim.api.nvim_buf_delete(term_buf, {force = true})
      term_buf = -1
    end
  else
    if term_buf ~= -1 then
      popup_create()
    else
      popup_create()
      vim.cmd('e term://' .. shell)
      term_buf = vim.api.nvim_win_get_buf(0)
      vim.api.nvim_buf_set_keymap(term_buf, 't', '<Esc>', '<c-\\><c-n>', {silent = true, nowait = true})
      vim.api.nvim_buf_set_option(term_buf, 'buflisted', false)
      vim.cmd([[
        au TermClose <buffer> lua require('utils').toggle_terminal(true)
      ]])
    end
    vim.cmd('startinsert!')
  end
end

return M