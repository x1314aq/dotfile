return {
  "nvim-telescope/telescope.nvim",
  version = false,
  dependencies = {
    {"nvim-lua/plenary.nvim"},
    {"nvim-telescope/telescope-fzf-native.nvim"},
  },
  keys = function()
      local keymap_opts = {silent = true, nowait = true, noremap = true}
      local builtin = require("telescope.builtin")

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

      local function grep_current_word()
        local opts = {
          sort_only_text = true,
          use_regex = false,
          additional_args = '-Fs',
          word_match = '-w',
          search = vim.fn.expand("<cword>"),
        }
      
        if opts.search == '' then
          print("Cancelled with empty pattern!")
          return
        end
        builtin.grep_string(opts)
      end

      local function grep_string()
        local opts = {
          sort_only_text = true,
          use_regex = true,
        }
      
        vim.ui.input({
            prompt = "Pattern",
          },
          function(input)
            if input == nil or input == "" then
              print("Cancelled with empty pattern!")
              return
            end
            opts.search = input
            builtin.grep_string(opts)
          end)
      end

      local function lsp_references()
        local opts = {
          timeout = 1000,
          include_declaration = false,
        }
        builtin.lsp_references(opts)
      end

      local function diagnostics()
        local opts = {
          timeout = 1000,
          buf_nr = 0,
        }
        builtin.diagnostics(opts)
      end

      local function lsp_symbols(doc)
        local opts = {
          timeout = 1000,
        }
        if doc then
          builtin.lsp_document_symbols(opts)
        else
          vim.ui.input({
            prompt = "Query",
          },
          function(input)
            if input == nil or input == "" then
              print("Cancelled with empty query!")
              return
            end
            opts.query = input
            builtin.lsp_workspace_symbols(opts)
          end)
        end
      end

      local function global_symbols()
        local clients = vim.lsp.get_active_clients({bufnr = 0})
        if next(clients) == nil then
          builtin.tags()
        else
          lsp_symbols(false)
        end
      end

      local function local_symbols()
        local clients = vim.lsp.get_active_clients({bufnr = 0})
        if next(clients) == nil then
          builtin.current_buffer_tags()
        else
          lsp_symbols(true)
        end
      end

      local function lsp_incoming_calls()
        local opts = {
          timeout = 1000,
        }
        builtin.lsp_incoming_calls(opts)
      end

      local function lsp_outgoing_calls()
        local opts = {
          timeout = 1000,
        }
        builtin.lsp_outgoing_calls(opts)
      end

      return {
        {"<M-o>", function() builtin.resume() end, keymap_opts},
        {"<leader>f", find_files, keymap_opts},
        {"<leader>b", buffers, keymap_opts},
        {"<leader>S", grep_current_word, keymap_opts},
        {"<leader>s", grep_string, keymap_opts},
        {"gr", lsp_references, keymap_opts},
        {"<leader>d", diagnostics, keymap_opts},
        {"<leader>t", global_symbols, keymap_opts},
        {"gc", lsp_incoming_calls, keymap_opts},
        {"gC", lsp_outgoing_calls, keymap_opts},
      }
    end,
  opts = function()
      if jit.os == 'Windows' then
        PATH_SEPERATOR = '\\'
      else
        PATH_SEPERATOR = '/'
      end
      local actions = require("telescope.actions")
      return {
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
    end,
  config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("fzf")
    end,
}