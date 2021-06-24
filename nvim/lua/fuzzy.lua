-- fuzzy finder using telescope

local no_preview = function()
  return require('telescope.themes').get_dropdown({
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    },
    width = 0.8,
    previewer = false,
    prompt_title = true
  })
end

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-j>"] = require('telescope.actions').move_selection_next,
        ["<C-k>"] = require('telescope.actions').move_selection_previous,
      },
      n = {
        ["q"] = require('telescope.actions').close,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--line-number',
      '--column',
    },
    prompt_position = "bottom",
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_defaults = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
    },
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
    shorten_path = true,
    winblend = 0,
    width = 0.75,
    preview_cutoff = 120,
    results_height = 1,
    results_width = 0.8,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = false,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  pickers = {
    buffers = {
      theme = "dropdown",
      previewer = false,
    },
    find_files = {
      theme = "dropdown",
      previewer = false,
    }
  }
}

M = {}

function M.find_files()
  local opts = {
    previewer = false,
    follow = true,
  }
  require("telescope.builtin").find_files(opts)
end

function M.buffers()
  local opts = {
    previewer = false,
    ignore_current_buffer = true,
  }
  require("telescope.builtin").buffers(opts)
end

function M.grep_string(fixed)
  local opts = {
    previewer = false,
  }
  if fixed then
    opts.search = vim.fn.expand("<cword>")
    opts.use_regex = false
    opts.word_match = '-Fs'
  else
    opts.search = vim.fn.input("Pattern: ", "")
    opts.use_regex = true
    opts.word_match = '-Se'
  end
  if opts.search == '' then
    print("Cancelled with empty pattern!")
    return
  end
  require("telescope.builtin").grep_string(opts)
end

function M.lsp_symbols(doc)
  local opts = {
    timeout = 1000,
  }
  if doc then
    require("telescope.builtin").lsp_document_symbols(opts)
  else
    opts.query = vim.fn.input("Query: ")
    if opts.query == '' then
      print("Cancelled with empty query!")
      return
    end
    require("telescope.builtin").lsp_workspace_symbols(opts)
  end
end

function M.lsp_references()
  local opts = {
    timeout = 1000,
  }
  require("telescope.builtin").lsp_references(opts)
end

return M