-- fuzzy finder using telescope
--vim.cmd [[highlight! link TelescopePromptBorder TelescopeBorder]]
--vim.cmd [[highlight! link TelescopeResultsBorder TelescopeBorder]]

M = {}

function M.find_files()
  local opts = {
    follow = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").find_files(opts)
end

function M.buffers()
  local opts = {
    ignore_current_buffer = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").buffers(opts)
end

function M.grep_string(fixed)
  local opts = {
    preview = {
      timeout = 500,
      treesitter = false,
    },
    sort_only_text = true
  }
  if fixed then
    opts.search = vim.fn.expand("<cword>")
    opts.use_regex = false
    opts.additional_args = '-Fs'
    opts.word_match = '-w'
  else
    vim.fn.inputsave()
    opts.search = vim.fn.input("Pattern: ", "")
    vim.fn.inputrestore()
    vim.cmd("redraw!")
    opts.use_regex = true
  end
  if opts.search == '' then
    print("Cancelled with empty pattern!")
    return
  end
  require("telescope.builtin").grep_string(opts)
end

function M.lsp_references()
  local opts = {
    timeout = 1000,
    preview = {
      timeout = 500,
      treesitter = false,
    },
  }
  require("telescope.builtin").lsp_references(opts)
end

function lsp_symbols(doc)
  local opts = {
    timeout = 1000,
    preview = {
      timeout = 500,
      treesitter = false,
    },
  }
  if doc then
    require("telescope.builtin").lsp_document_symbols(opts)
  else
    vim.fn.inputsave()
    opts.query = vim.fn.input("Query: ")
    vim.fn.inputrestore()
    vim.cmd("redraw!")
    if opts.query == '' then
      print("Cancelled with empty query!")
      return
    end
    require("telescope.builtin").lsp_workspace_symbols(opts)
  end
end

function M.global_symbols()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    require("telescope.builtin").tags()
  else
    lsp_symbols(false)
  end
end

function M.local_symbols()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    require("telescope.builtin").current_buffer_tags()
  else
    lsp_symbols(true)
  end
end

return M
