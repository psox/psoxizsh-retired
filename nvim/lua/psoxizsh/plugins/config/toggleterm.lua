return function()
  local tt, util = require 'toggleterm', require 'psoxizsh.util'

  local defaults = {
    open_mapping = '<C-Up>',
    start_in_insert = true,
    insert_mappings = false,
    terminal_mappings = true,
    direction = 'float',
    float_opts = { border = 'curved' },
  }

  tt.setup(util.mconfig('config.toggleterm', defaults))
end

