local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

M = {}

M.projects = function(opts)
  local projects = vim.fn.stdpath('data_dirs')
  pickers.new(opts, {
    prompt_title = 'Projects',
    finder = finders.new_table({
      results = projects,
      --entry_maker = opts.entry_maker,
    }),
    sorter = conf.generic_sorter(opts),
    previewer = conf.generic_sorter(opts),
  }):find()
end

return M
