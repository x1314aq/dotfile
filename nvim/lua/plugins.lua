local packer = nil
local function init()
  if packer == nil then
    packer = require("packer")
    packer.init {
      git = {
        clone_timeout = 5,
      },
    }
  end

  local use = packer.use
  packer.reset()

  use {"wbthomason/packer.nvim"}
  use {"neovim/nvim-lspconfig"}
  use {"nvim-treesitter/nvim-treesitter"}
  use {"nvim-telescope/telescope.nvim",
       requires={{"nvim-lua/plenary.nvim"}},
       config = function() require("config.telescope") end,
      }
  use {"navarasu/onedark.nvim",
       config = function() require("onedark").setup {
         style = "darker",
         toggle_style_key = "<localleader>cs",
       } end,
      }
  use {"nvim-lualine/lualine.nvim",
       config = function() require("config.lualine") end,
      }
  use {"phaazon/hop.nvim",
       config = function() require("config.hop") end,
      }
  use {"nvim-telescope/telescope-fzf-native.nvim",
       run = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
      }
  use {"hrsh7th/cmp-nvim-lsp", branch="main"}
  use {"hrsh7th/cmp-buffer", branch="main"}
  use {"hrsh7th/nvim-cmp", branch="main"}
  use {"L3MON4D3/LuaSnip"}
  use {"saadparwaiz1/cmp_luasnip"}
  use {"lukas-reineke/indent-blankline.nvim",
       config = function() require("indent_blankline").setup {
         char = '|',
         buftype_exclude = {'terminal'},
         space_char_blankline = ' ',
       } end,
      }
  use {"windwp/nvim-autopairs",
       config = function() require("nvim-autopairs").setup {
         map_c_w = true,
         enable_check_bracket_line = false,
       } end,
      }
  use {"lewis6991/impatient.nvim"}
end

local plugins = setmetatable({}, {
  __index = function(_, key)
    init()
    return packer[key]
  end,
})

return plugins
