return function()
  local gitsigns, util = require 'gitsigns', require 'psoxizsh.util'

  local defaults = {
    sign_priority = 100,
    current_line_blame_formatter_opts = {
      relative_time = false
    },
  }

  gitsigns.setup(util.mconfig('config.gitsigns', defaults))
end
