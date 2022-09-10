return function()
  local ts, util = require 'telescope', require 'psoxizsh.util'

  local defaults = {}

  ts.setup(util.mconfig('config.telescope', { defaults = defaults }))

  -- Requires telescope-fzf-native.nvim
  -- Speeds up search times by 5-10x
  ts.load_extension('fzf')
end
