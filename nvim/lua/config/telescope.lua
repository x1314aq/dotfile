if jit.os == 'Windows' then
    PATH_SEPERATOR = '\\'
else
    PATH_SEPERATOR = '/'
end

local actions = require("telescope.actions")
require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-u>"] = false,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
      n = {
        ['q'] = actions.close,
      },
    },
    preview = false,
    dynamic_preview_title = true,
    file_ignore_patterns = {
      "^%..+" .. PATH_SEPERATOR,
    },
    path_display = {
      shorten = {
        len = 1,
        exclude = {1, -2, -1},
      },
    },
    color_devicons = false,
  },
  pickers = {
    find_files = {
      find_command = {"fd", "--type", "f", "--strip-cwd-prefix"}
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

require("telescope").load_extension("fzf")

-- telescope key mappings
vim.keymap.set('n', '<M-o>', function() require("telescope.builtin").resume() end, {silent = true, nowait = true, noremap = true})

local function find_files()
  local opts = {
    follow = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").find_files(opts)
end

vim.keymap.set('n', '<leader>f', find_files, {silent = true, nowait = true, noremap = true})

local function buffers()
  local opts = {
    ignore_current_buffer = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").buffers(opts)
end

vim.keymap.set('n', '<leader>b', buffers, {silent = true, nowait = true, noremap = true})

local function grep_string(fixed)
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

vim.keymap.set('n', '<leader>s', function() grep_string(false) end, {silent = true, nowait = true, noremap = true})
vim.keymap.set('n', '<leader>S', function() grep_string(true) end, {silent = true, nowait = true, noremap = true})

local function lsp_references()
  local opts = {
    timeout = 1000,
    preview = {
      timeout = 500,
      treesitter = false,
    },
  }
  require("telescope.builtin").lsp_references(opts)
end

vim.keymap.set('n', 'gr', lsp_references, {silent = true, nowait = true, noremap = true})

local function lsp_symbols(doc)
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

local function global_symbols()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    require("telescope.builtin").tags()
  else
    lsp_symbols(false)
  end
end

vim.keymap.set('n', '<leader>t', global_symbols, {silent = true, nowait = true, noremap = true})

local function local_symbols()
  local clients = vim.lsp.buf_get_clients()
  if next(clients) == nil then
    require("telescope.builtin").current_buffer_tags()
  else
    lsp_symbols(true)
  end
end

vim.keymap.set('n', '<leader>a', local_symbols, {silent = true, nowait = true, noremap = true})--