return function()
  local trouble, util = require 'trouble', require 'psoxizsh.util'

  local defaults = {}

  trouble.setup(util.mconfig('config.trouble', defaults))
end
