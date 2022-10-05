local util, Server = require 'psoxizsh.lsp.util', require 'psoxizsh.lsp.preset'

-- List of language servers that are enabled by default
local defaults = {
  Server.Json,
  Server.Yaml,
  Server.Vim,
  Server.Lua
}

return util.Servers.new(defaults)
