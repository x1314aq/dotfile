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
