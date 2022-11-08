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
    preview = {
      filesize_limit = 1,
      treesitter = true,
    },
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
local builtin = require("telescope.builtin")
local keymap_opts = {silent = true, nowait = true, noremap = true}

vim.keymap.set('n', '<M-o>', builtin.resume, keymap_opts)

local function find_files()
  local opts = {
    follow = true,
    previewer = false,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  builtin.find_files(opts)
end

vim.keymap.set('n', '<leader>f', find_files, keymap_opts)

local function buffers()
  local opts = {
    ignore_current_buffer = true,
    previewer = false,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  builtin.buffers(opts)
end

vim.keymap.set('n', '<leader>b', buffers, keymap_opts)

local function grep_string(fixed)
  local opts = {
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
  builtin.grep_string(opts)
end

vim.keymap.set('n', '<leader>s', function() grep_string(false) end, keymap_opts)
vim.keymap.set('n', '<leader>S', function() grep_string(true) end, keymap_opts)

local function lsp_references()
  local opts = {
    timeout = 1000,
    include_declaration = false,
  }
  builtin.lsp_references(opts)
end

vim.keymap.set('n', 'gr', lsp_references, keymap_opts)

local function diagnostics()
  local opts = {
    timeout = 1000,
    buf_nr = 0,
  }
  builtin.diagnostics(opts)
end

vim.keymap.set('n', '<leader>d', diagnostics, keymap_opts)

local function lsp_symbols(doc)
  local opts = {
    timeout = 1000,
  }
  if doc then
    builtin.lsp_document_symbols(opts)
  else
    vim.fn.inputsave()
    opts.query = vim.fn.input("Query: ")
    vim.fn.inputrestore()
    vim.cmd("redraw!")
    if opts.query == '' then
      print("Cancelled with empty query!")
      return
    end
    builtin.lsp_workspace_symbols(opts)
  end
end

local function global_symbols()
  local clients = vim.lsp.get_active_clients({buffer = 0})
  if next(clients) == nil then
    builtin.tags()
  else
    lsp_symbols(false)
  end
end

vim.keymap.set('n', '<leader>t', global_symbols, keymap_opts)

local function local_symbols()
  local clients = vim.lsp.get_active_clients({buffer = 0})
  if next(clients) == nil then
    builtin.current_buffer_tags()
  else
    lsp_symbols(true)
  end
end

vim.keymap.set('n', '<leader>a', local_symbols, keymap_opts)

local function lsp_incoming_calls()
  local opts = {
    timeout = 1000,
  }
  builtin.lsp_incoming_calls(opts)
end

vim.keymap.set('n', 'gc', lsp_incoming_calls, keymap_opts)

local function lsp_outgoing_calls()
  local opts = {
    timeout = 1000,
  }
  builtin.lsp_outgoing_calls(opts)
end

vim.keymap.set('n', 'gC', lsp_outgoing_calls, keymap_opts)
