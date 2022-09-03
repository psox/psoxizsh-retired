return function()
  local ts, util = require 'nvim-treesitter.configs', require 'psoxizsh.util'

  local defaults = {
    -- Trigger prompt to install plugin on loading relevant filetype
    auto_install = true,

    -- Always install these
    ensure_installed = { 'vim', 'lua', 'json', 'yaml' },

    -- Enable highlighting module
    highlight = {
      enable = true,
    },

    -- Added via p00f/nvim-ts-rainbow
    rainbow = {
      enable = true,
      extended_mode = true,
    }
  }

  ts.setup(util.mconfig('config.nvim-treesitter', defaults))
end
