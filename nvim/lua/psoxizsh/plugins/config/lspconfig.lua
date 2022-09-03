return function()
  local lspconfig, util = require 'lspconfig', require 'psoxizsh.util'
  local keys, servers = require 'psoxizsh.key', require 'psoxizsh.lsp.servers'

  local defaults = {}

  -- This is the default key mappings that are applied on attaching to a LSP.
  defaults.on_attach = function(_, bnum)
    keys.Buffer.Lsp:register({ buffer = bnum })
  end

  -- Ideally, this would be registered on some Psoxizsh.Plug.Post autocmd
  -- but I don't feel like refactoring psoxizsh.plugin now.
  --
  -- This is needed because many other lsp plugins expect:
  --
  -- 1. To be able to call "require 'lspconfig'" and not blow up (after lspconfig is loaded)
  -- 2. To be able to configure lspconfig's defaults before servers are setup (before lspconfig is loaded)
  --
  -- Therefore, we must defer actually loading servers themselves until
  -- after all other relevant plugins have had their say... but before
  -- packer_compiled is finished as otherwise we risk starting too late
  -- and skipping the first buffer neovim opens because we haven't
  -- configured our servers yet. Fun.
  --
  -- Currently this is called during nlsp-settings's config, but we might
  -- need to move this around
  _G.PsoxizshLoadLSPServers = function()
    -- Ensure we exit any active language servers in case of reloads
    vim.cmd 'LspStop'

    local user = util.try_mconfig('config.lsp.servers')

    for server, spec in pairs(servers:extend(user):get()) do
      spec(lspconfig[server], defaults)
    end
  end
end
