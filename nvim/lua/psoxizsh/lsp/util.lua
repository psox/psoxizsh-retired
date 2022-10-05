local util = require 'psoxizsh.util'

-- Utilities for interacting with *lspconfig* servers
local M = {}

-- Server
--
-- A Server is a representation of a LSP server, that can be
-- used to configure lspconfig servers.
--
-- Each server has the following properties:
--
-- {
--    name      = 'lspconfig server identifier',
--    filetypes = { 'List of filetypes supported by this Server' },
--    with      = 'Function that takes a list of config overrides for this Server'
-- }
--
-- Use `Server.new/1` to create a new Server
local Server = { mt = {} }

-- Create a new Server from the provided Spec object
--
-- Spec = {
--    name = [[ REQUIRED|STRING
--      The lspconfig server name of this Server.
--      See :h lspconfig-all for a list
--    ]]
--    ft  = { 'OPTIONAL|ARRAY|STRING',
--      'A list of filetypes to use this server with',
--      'Leave empty to use the lspconfig defaults'
--    }
--    setup = { 'OPTIONAL|MAP|FUNC',
--      [[ The setup for this Server
--
--         ## Map
--         Can be either a map of key/values that are
--         passed to lspconfig[Server].setup, after
--         being merged with the defaults; see
--         :h lspconfig-setup for some primer documentation
--         on the subject
--
--         ## Func
--         Or, a function that takes three arguments:
--
--         1. server          | lspconfig[Server]
--         2. settings        | default settings
--         3. override        | user override fn
--
--         This gives you complete control over how the server
--         is initialized, however you must also *guarantee* that
--         some version of `server.setup(settings)` is called before
--         returning from the function.
--      ]]
--    }
-- }
--
-- Note: you may pass an existing Server without harm, as a convenience
function Server.new(spec)
  if spec and spec.__is_server then
    return spec
  else
    return Server.from_spec(spec)
  end
end

-- Convert a Spec object into a Server
--
-- Callers should prefer Server.new/1
function Server.from_spec(spec)
  local spec = spec or {}
  local ft = spec.ft and (type(spec.ft) == 'table' and spec.ft or { spec.ft })
  local setup, handler = spec.setup, nil
  local t = type(setup)

  -- Defined setup function, just use it as the handler
  if      t == 'function'   then handler = setup
  -- Config map, construct handler glue around it
  elseif  t == 'table'      then handler = Server.make_handler(setup)
  -- Unknown (user error), just create default handler
                            else handler = Server.make_handler(false)
  end

  local server = {
    name          = spec.name,
    filetypes     = ft,
    _handler      = handler,
    _override     = function (defaults) return defaults end,
    __is_server   = true
  }
  server.with = Server.with(server)
  server = setmetatable(server, Server.mt)

  return server
end

-- Setup wrapper for Servers
-- @private
--
-- Responsible for merging lspconfig defaults into our
-- Server defined settings, before passing them through
-- to the Server._handler
function Server.setup(self, server, settings)
  local merged = vim.tbl_deep_extend('keep', { filetypes = self.filetypes }, settings)

  return self._handler(server, merged, self._override)
end

-- Server.with handler
-- @private
--
-- Allows consumers of existing Servers to override
-- certain settings
--
-- This is the implementation of the 'override' arg
-- in a Spec.setup
function Server.with(self)
  return function(override)
    local this = vim.deepcopy(self)

    this._override = function(defaults)
      return util.mconfig(override, defaults or {})
    end

    return this
  end
end

-- Create a new Server._handler
-- @private
--
-- Creates a handler function for the given setup *map*
-- (not function)
function Server.make_handler(setup)
  local merge = setup and true

  return merge
  and function(server, settings, override)
        return server.setup(override(vim.tbl_deep_extend('keep', setup, settings)))
      end
  or  function(server, settings, override)
        return server.setup(override(settings))
      end
end

Server.mt.__call = function(self, server, settings) return Server.setup(self, server, settings) end

-- Filter
--
-- A meta object for defining search queries on a `Servers` list
--
-- See `Servers.by` for details on usage
local Filter = { mt = {} }

-- Create a new Filter with the given `context` and `term`
--
-- When calling `Filter.filter/2` on this Filter, the `term`
-- will be used as the identifier search for the given needle
-- with
function Filter.new(cxt, term)
  return setmetatable({ _context = cxt, _term = term }, Filter.mt)
end

-- Return a list of objects that match the needle, from this
-- Filter's context.
--
-- `needle` will be matched against the context's `term`,
-- and if `needle` is a list, results that match *any* needle
-- will be returned
function Filter.filter(self, needle)
  local results = {}

  for _, entry in pairs(self._context) do
    local target, t = entry[self._term], type(entry[self._term])

    if t == 'string' and target == needle or
      vim.tbl_islist(target) and vim.tbl_contains(target, needle)
    then
      table.insert(results, entry)
    end
  end

  return Servers.new(results)
end

Filter.mt.__call = function(self, args)
  local new, t = Servers.new(), type(args)

  if t == 'string' then
    new:merge(Filter.filter(self, args))
  elseif vim.tbl_islist(args) then
    for _, needle in ipairs(args) do
      new:merge(Filter.filter(self, needle))
    end
  end

  return new
end

-- Servers
--
-- A smart list of `Server` objects, allowing callers
-- to add, extend and filter the stored `Server`s
local Servers = { by = {}, mt = {} }

-- Create a new, empty `Servers` object
--
-- If `init` is a list of `Server` or `Spec`s, add them
-- to the new `Servers`
function Servers.new(init)
  local this = setmetatable({ _servers = {} }, Servers.mt)

  return this:extend(init)
end

-- Add the provided `Server` or `Spec`s to this `Servers`
--
-- This is the variadic version of Servers.extend/1
function Servers.with(self, ...)
  return self:extend({ ... })
end

-- Add the provided `Server` or `Spec` `list` to this `Servers`
function Servers.extend(self, list)
  for _, srv in ipairs(list or {}) do
    self:insert(srv)
  end

  return self
end

-- Merge this `Servers` with another `Servers`
--
-- Note, `Server`s in `other` have precedence in case
-- of conflicts
function Servers.merge(self, other)
  for _, srv in pairs(other:get()) do
    self:insert(srv)
  end

  return self
end

-- Add the given `Server` to this `Servers`
function Servers.insert(self, server)
  local s = Server.new(server)
  self._servers[s.name] = s

  return self
end

-- Return the set of managed `Server`s
function Servers.get(self)
  return self._servers
end

setmetatable(Servers.by, {
    __index = function(self, dimension) return Filter.new(self._servers, dimension) end
})

Servers.mt.__index = function(self, key) return Servers[key] end

M.Servers = Servers
M.Server = Server

return M
