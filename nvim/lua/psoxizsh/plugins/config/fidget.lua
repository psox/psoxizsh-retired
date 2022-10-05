return function()
  local fidget, util = require 'fidget', require 'psoxizsh.util'

  local defaults = {
    text = { spinner = 'dots_snake' },
    timer = { fidget_decay = 1500 },
    fmt = { stack_upwards = true },
  }

  fidget.setup(util.mconfig('config.fidget', defaults))
end
