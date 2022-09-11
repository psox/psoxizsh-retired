return function()
  local notify, util = require 'notify', require 'psoxizsh.util'
  local loaded = _G._psoxizsh_plug_config_notify_loaded

  local defaults = {
    background_colour = "#000000",
    timeout = 2000,
    top_down = false,
  }

  notify.setup(util.mconfig('config.notify', defaults))

  -- Set notify as the default Neovim notification service
  -- However, weird stuff happens if we set this multiple times
  -- so guard against that
  if not loaded then
    vim.notify = notify
    _G._psoxizsh_plug_config_notify_loaded = true
  end

end
