return function()
  local mason, util = require 'mason', require 'psoxizsh.util'

  local defaults = {}

  return mason.setup(util.mconfig('config.mason', defaults))
end
