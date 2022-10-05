return function()
  local mason_lsp, util = require 'mason-lspconfig', require 'psoxizsh.util'

  -- https://github.com/williamboman/mason-lspconfig.nvim#default-configuration
  local defaults = {
    -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
    ensure_installed = {},

    automatic_installation = true,
  }

  mason_lsp.setup(util.mconfig('config.mason-lsp', defaults))
end
