local uv = vim.loop
local vfn = vim.fn
local cmd = vim.cmd
local api = vim.api

local M = {}

-- fzy lua native implementation
local native = require('fzy-lua-native')

local SEP

if jit.os == 'Windows' then
    SEP = '\\'
else
    SEP = '/'
end

local function fst(xs)
  return xs and xs[1] or nil
end

local fzy_global = {}
local fzy_cache = {}

local function popup_create(para)
    local buf = api.nvim_create_buf(false, true)
    assert(buf, "Failed to create buffer")
    api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    local opts = {
        relative = 'editor',
        style = 'minimal',
        row = para.row,
        col = para.col,
        width = para.width,
        height = para.height,
        border = 'none',
    }
    local win = api.nvim_open_win(buf, para.enter, opts)
    api.nvim_win_set_option(win, 'wrap', false)
    api.nvim_win_set_option(win, 'winhl', 'NormalFloat:FzyNormal')
    return win, buf, opts
end


local sinks = {}
M.sinks = sinks
function sinks.edit_file(selection)
  if selection and vim.trim(selection) ~= '' then
    cmd('e ' .. selection)
  end
end


function M.try(...)
  for _,fn in ipairs({...}) do
    local ok, _ = pcall(fn)
    if ok then
      return
    end
  end
end


M.actions = {}


function M.actions.buf_lines()
  local lines = api.nvim_buf_get_lines(0, 0, -1, true)
  local win = api.nvim_get_current_win()
  M.pick_one(lines, 'Lines> ', function(x) return x end, function(result, idx)
    if result then
      api.nvim_win_set_cursor(win, {idx, 0})
      cmd('normal! zvzz')
    end
  end)
end


function M.actions.buffers()
  local bufs = vim.tbl_filter(
    function(b)
      return api.nvim_buf_is_loaded(b) and api.nvim_buf_get_option(b, 'buftype') ~= 'quickfix'
    end,
    api.nvim_list_bufs()
  )
  local format_bufname = function(b)
    local fullname = api.nvim_buf_get_name(b)
    local name
    if #fullname == 0 then
      name = '[No Name] (' .. api.nvim_buf_get_option(b, 'buftype') .. ')'
    else
      name = vfn.fnamemodify(fullname, ':.')
    end
    local modified = api.nvim_buf_get_option(b, 'modified')
    return modified and name .. ' [+]' or name
  end
  M.pick_one(bufs, 'Buffers> ', format_bufname, function(b)
    if b then
      api.nvim_set_current_buf(b)
    end
  end)
end


function M.actions.lsp_tags()
  local params = vim.lsp.util.make_position_params()
  params.context = {
    includeDeclaration = true
  }
  assert(#vim.lsp.buf_get_clients() > 0, "Must have a client running to use lsp_tags")
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, _, result)
    assert(not err, vim.inspect(err))
    if not result then
      return
    end
    local items = {}
    local add_items = nil
    add_items = function(xs)
      for _, x in ipairs(xs) do
        table.insert(items, x)
        if x.children then
          add_items(x.children)
        end
      end
    end
    add_items(result)
    M.pick_one(
      items,
      'Tags> ',
      function(item) return string.format('[%s] %s', vim.lsp.protocol.SymbolKind[item.kind], item.name) end,
      function(item)
        if not item then return end
        local range = item.range or item.location.range
        api.nvim_win_set_cursor(0, {
          range.start.line + 1,
          range.start.character
        })
        cmd('normal! zvzz')
      end
    )
  end)
end

function M.actions.buf_tags()
  local bufname = api.nvim_buf_get_name(0)
  assert(vfn.filereadable(bufname), 'File to generate tags for must be readable')
  local ok, output = pcall(vfn.system, {
    'ctags',
    '-f',
    '-',
    '--sort=yes',
    '--excmd=number',
    '--language-force=' .. api.nvim_buf_get_option(0, 'filetype'),
    bufname
  })
  if not ok or api.nvim_get_vvar('shell_error') ~= 0 then
    output = vfn.system({'ctags', '-f', '-', '--sort=yes', '--excmd=number', bufname})
  end
  local lines = vim.tbl_filter(
    function(x) return x ~= '' end,
    vim.split(output, '\n')
  )
  local tags = vim.tbl_map(function(x) return vim.split(x, '\t') end, lines)
  M.pick_one(
    tags,
    'Buffer Tags> ',
    fst,
    function(tag)
      if not tag then
        return
      end
      local row = tonumber(vim.split(tag[3], ';')[1])
      api.nvim_win_set_cursor(0, {row, 0})
      cmd('normal! zvzz')
    end
  )
end


function M.actions.quickfix()
  cmd('cclose')
  local items = vfn.getqflist()
  M.pick_one(
    items,
    'Quickfix> ',
    function(item)
      local bufname = vfn.fnamemodify(api.nvim_buf_get_name(item.bufnr), ':t')
      return bufname .. ': ' .. item.text
    end,
    function(item)
      if not item then return end
      vfn.bufload(item.bufnr)
      api.nvim_win_set_buf(0, item.bufnr)
      api.nvim_win_set_cursor(0, {item.lnum, item.col - 1})
      cmd('normal! zvzz')
    end
  )
end


function M.pick_one(items, prompt, label_fn, cb)
  label_fn = label_fn or vim.inspect
  local num_digits = math.floor(math.log(math.abs(#items)) + 1)
  local digit_fmt = '%0' .. tostring(num_digits) .. 'd'
  local inputs = vfn.tempname()
  vfn.system(string.format('mkfifo "%s"', inputs))
  M.execute(
    string.format('cat "%s"', inputs),
    function(selection)
      os.remove(inputs)
      if not selection or vim.trim(selection) == '' then
        cb(nil)
      else
        local parts = vim.split(selection, ' ¦ ')
        local idx = tonumber(parts[1])
        cb(items[idx], idx)
      end
    end,
    prompt
  )
  cmd('startinsert!')
  local f = io.open(inputs, 'a')
  for i, item in ipairs(items) do
    local label = string.format(digit_fmt .. ' ¦ %s', i, label_fn(item))
    f:write(label .. '\n')
  end
  f:flush()
  f:close()
end


function M.execute(choices_cmd, on_selection, prompt)
  local tmpfile = vfn.tempname()
  local shell = api.nvim_get_option('shell')
  local shellcmdflag = api.nvim_get_option('shellcmdflag')
  local popup_win, _, popup_opts = popup_create()
  local fzy = (prompt
    and string.format('%s | fzy -l %d -p "%s" > "%s"', choices_cmd, popup_opts.height, prompt, tmpfile)
    or string.format('%s | fzy -l %d > "%s"', choices_cmd, popup_opts.height, tmpfile)
  )
  local args = {shell, shellcmdflag, fzy}
  vfn.termopen(args, {
    on_exit = function()
      api.nvim_win_close(popup_win, true)
      local file = io.open(tmpfile)
      if file then
        local contents = file:read("*all")
        file:close()
        os.remove(tmpfile)
        on_selection(contents)
      else
        on_selection(nil)
      end
    end;
  })
  cmd('startinsert!')
end


local function buffer_on_lines(str, pbuf, changedtick, first, last, newlast, bytes)
    local entry = fzy_global[pbuf]
    local rwin = entry.rwin
    local rbuf = api.nvim_win_get_buf(rwin)
    local line = api.nvim_buf_get_lines(pbuf, 0, 1, true)[1]
    local query = string.sub(line, string.len(entry.prompt) + 1)

    if query ~= '' then return end
    vim.schedule(function() api.nvim_buf_set_lines(rbuf, 0, -1, true, entry.haystack) end)
end

local function buffer_on_detach(str, buf)
    local timer = fzy_global[buf].timer
    timer:stop()
    timer:close()
    fzy_global[buf] = nil
    --print("buffer_on_detach called")
end

local function do_close_window(entry)
    api.nvim_win_close(entry.pwin, true)
    api.nvim_win_close(entry.rwin, true)
end

function M.close_windows()
    local prompt_buf = api.nvim_win_get_buf(0)
    local entry = fzy_global[prompt_buf]
    do_close_window(entry)
end

function M.open_file()
    local prompt_buf = api.nvim_win_get_buf(0)
    local entry = fzy_global[prompt_buf]
    local result_buf = api.nvim_win_get_buf(entry.rwin)
    local cursor = api.nvim_win_get_cursor(entry.rwin)
    local str = api.nvim_buf_get_lines(result_buf, cursor[1] - 1, cursor[1], false)
    do_close_window(entry)
    entry.on_selection(str[1])
end

function M.move_cursor(increment)
    local prompt_buf = api.nvim_win_get_buf(0)
    local entry = fzy_global[prompt_buf]
    local result_win = entry.rwin
    local count = api.nvim_buf_line_count(api.nvim_win_get_buf(result_win))
    local cursor = api.nvim_win_get_cursor(result_win)
    cursor[1] = cursor[1] + increment
    if cursor[1] == 0 or cursor[1] == count + 1 then
        return
    end
    api.nvim_win_set_cursor(result_win, cursor)
    cmd('redraw!')
end

local function set_mappings(buf_nr)
    local n_mappings = {
        ['<CR>'] = 'open_file()',
        ['q'] = 'close_windows()',
        ['j'] = 'move_cursor(1)',
        ['k'] = 'move_cursor(-1)'
    }
    local i_mappings = {
        ['<CR>'] = 'open_file()',
        ['<c-['] = 'close_windows()',
        ['<c-j>'] = 'move_cursor(1)',
        ['<c-k>'] = 'move_cursor(-1)'
    }
    for k, v in pairs(n_mappings) do
        api.nvim_buf_set_keymap(buf_nr, 'n', k, ':lua require("fzy").' .. v .. '<CR>', {nowait = true, silent = true, noremap = true})
    end
    for k, v in pairs(i_mappings) do
        api.nvim_buf_set_keymap(buf_nr, 'i', k, '<C-o>:lua require("fzy").' .. v .. '<CR>', {nowait = true, silent = true, noremap = true})
    end
end

function M.qwe(haystack, on_selection, on_timeout, prompt)
    local para = {}
    local columns = api.nvim_get_option('columns')
    local lines = api.nvim_get_option('lines')
    para.height = 1
    para.width = math.floor(columns * 0.8)
    para.row = math.floor(lines * 0.1)
    para.col = math.floor((columns - para.width) * 0.5)
    para.enter = true
    local prompt_win, prompt_buf, prompt_opts = popup_create(para)
    api.nvim_buf_set_option(prompt_buf, 'buftype', 'prompt')
    vfn.prompt_setprompt(prompt_buf, prompt)
    set_mappings(prompt_buf)

    para.height = math.floor(lines * 0.6)
    para.row = para.row + 1
    para.enter = false
    local result_win, result_buf, result_opts = popup_create(para)
    api.nvim_buf_set_lines(result_buf, 0, -1, true, haystack)
    api.nvim_win_set_option(result_win, 'number', true)
    api.nvim_win_set_option(result_win, 'cursorline', true)
    --api.nvim_buf_set_option(result_buf, 'readonly', true)
    --api.nvim_buf_set_option(result_buf, 'modifiable', false)

    local timer = uv.new_timer();
    timer:start(1000, 1000, vim.schedule_wrap(function() on_timeout(prompt_buf) end))

    api.nvim_buf_attach(prompt_buf, false, {
        on_lines = buffer_on_lines,
        on_detach = buffer_on_detach,
    })

    fzy_global[prompt_buf] = {
        pwin = prompt_win,
        rwin = result_win,
        on_selection = on_selection,
        prompt = prompt,
        haystack = haystack,
        timer = timer
    }
end

local function default_timeout(pbuf)
    local entry = fzy_global[pbuf]
    local rwin = entry.rwin
    local rbuf = api.nvim_win_get_buf(rwin)
    local line = api.nvim_buf_get_lines(pbuf, 0, 1, true)[1]
    local query = string.sub(line, string.len(entry.prompt) + 1)
    if query == '' or query == entry.last_query then return end

    local res = native.filter(query, entry.haystack, true)
    table.sort(res, function(a, b) return a[3] > b[3] end)
    local rwin_height = api.nvim_win_get_height(rwin)
    local num_lines = math.min(rwin_height, vim.tbl_count(res))
    local new_lines = {}
    for i = 1, num_lines do
        new_lines[i] = res[i][1]
    end

    api.nvim_buf_set_lines(rbuf, 0, -1, true, new_lines)
    entry.last_query = query
end

local function default_edit(str)
    if str and vim.trim(str) == '' then return end
    cmd('e ' .. str)
    cmd('stopinsert')
end

local function grep_edit(str)
    if str and vim.trim(str) == '' then return end
    local tmp = vim.split(str, ':', true)
    cmd('e ' .. tmp[1])
    cmd('stopinsert')
    api.nvim_win_set_cursor(0, {tonumber(tmp[2]), tonumber(tmp[3]) - 1})
end

local grep_tmp = {}

local function grep_timeout(pbuf)
    local entry = fzy_global[pbuf]
    local rwin = entry.rwin
    local rbuf = api.nvim_win_get_buf(rwin)
    local line = api.nvim_buf_get_lines(pbuf, 0, 1, true)[1]
    local query = string.sub(line, string.len(entry.prompt) + 1)
    if query == '' or query == entry.last_query then return end

    local res = native.filter(query, vim.tbl_keys(grep_tmp), true)
    table.sort(res, function(a, b) return a[3] > b[3] end)
    local rwin_height = api.nvim_win_get_height(rwin)
    local num_lines = math.min(rwin_height, vim.tbl_count(res))
    local new_lines = {}
    for i = 1, num_lines do
        new_lines[i] = grep_tmp[res[i][1]]
    end

    api.nvim_buf_set_lines(rbuf, 0, -1, true, new_lines)
    entry.last_query = query
end

function M.file(path)
    local pwd = vfn.getcwd()
    local haystack = fzy_cache[pwd]
    if haystack == nil then
        haystack = vfn.systemlist('fd -L -t f . ' .. pwd)
        fzy_cache[pwd] = haystack
    end
    for i = 1, #haystack do
        if vim.startswith(haystack[i], pwd) then
            haystack[i] = string.sub(haystack[i], #pwd + 2)
        end
    end
    --print(pwd, #pwd, vim.inspect(haystack))
    M.qwe(haystack, default_edit, default_timeout, "File> ")
    cmd('startinsert')
end

function M.grep(args, bang)
    if args == "" then return end
    local a = vim.split(args, ' ', true)
    local haystack = fzy_cache[a]
    if haystack == nil then
        local cmd = 'rg -L --vimgrep'
        if bang == '!' then cmd = cmd .. ' -F ' end
        for i = 1, #a do
            cmd = cmd .. ' -e ' .. a[i]
        end
        haystack = vfn.systemlist(cmd)
        fzy_cache[a] = haystack
    end
    vim.tbl_map(function(e) grep_tmp[vim.split(e, ':', true)[4]] = e end, haystack)
    M.qwe(haystack, grep_edit, grep_timeout, "Grep> ")
    cmd('startinsert')
end

return M