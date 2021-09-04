-- fuzzy finder using telescope
local theme = require('telescope.themes').get_dropdown({
    borderchars = {
      { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
      prompt = {"─", "│", " ", "│", '┌', '┐', "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "┘", "└"},
      preview = { '─', '│', '─', '│', '┌', '┐', '┘', '└'},
    },
    previewer = false,
  })

require('telescope').setup{
  defaults = {
    mappings = {
      i = {
        ["<C-n>"] = false,
        ["<C-p>"] = false,
        ["<C-q>"] = require('telescope.actions').smart_send_to_qflist,
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
    prompt_prefix = "> ",
    selection_caret = "> ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "horizontal",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = false,
      },
      prompt_position = "bottom",
      width = 0.75,
      preview_cutoff = 120,
    },
    file_sorter =  require'telescope.sorters'.get_fzy_sorter,
    file_ignore_patterns = {},
    generic_sorter =  require'telescope.sorters'.get_fzy_sorter,
    path_display = {"absolute"},
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = false,
    use_less = false,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
  },
  -- pickers = {
  --   buffers = {
  --     theme = "dropdown",
  --     previewer = false,
  --   },
  --   find_files = {
  --     theme = "dropdown",
  --     previewer = false,
  --   },
  -- }
}

vim.cmd [[highlight! link TelescopePromptBorder TelescopeBorder]]
vim.cmd [[highlight! link TelescopeResultsBorder TelescopeBorder]]

M = {}

function M.find_files()
  local opts = {
    follow = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").find_files(vim.tbl_deep_extend("keep", opts, theme))
end

function M.buffers()
  local opts = {
    ignore_current_buffer = true,
    layout_config = {
      width = math.floor(vim.api.nvim_get_option('columns') * 0.7),
      height = math.floor(vim.api.nvim_get_option('lines') * 0.6),
    },
  }
  require("telescope.builtin").buffers(vim.tbl_deep_extend("keep", opts, theme))
end

function M.grep_string(fixed)
  local opts = {}
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
