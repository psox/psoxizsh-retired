return function()
  local nlsp, util = require 'nlspsettings', require 'psoxizsh.util'

  local defaults = {
    loader = 'json',
    config_home = vim.fn.stdpath('config') .. '/lsp',
    local_settings_dir = '.vim',
    nvim_notify = { enabled = true, timeout = 2000, },
    append_default_schemas = true,
  }

  nlsp.setup(util.mconfig('config.nlspsettings', defaults))

  -- Remember to move this if you ever delete or add a lspconfig
  -- plugin that is loaded after this one
  _G.PsoxizshLoadLSPServers()
end
