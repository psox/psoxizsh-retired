return function()
  local ts, util = require 'telescope', require 'psoxizsh.util'
  local keys = require 'psoxizsh.key.map'
  local FuzzySearch = keys.Global.N.Super.FuzzySearch

  local defaults = {
    mappings = { i = {
      [FuzzySearch.key] = 'close',
    }}
  }

  ts.setup(util.mconfig('config.telescope', { defaults = defaults }))

  -- Requires telescope-fzf-native.nvim
  -- Speeds up search times by 5-10x
  ts.load_extension('fzf')
end
