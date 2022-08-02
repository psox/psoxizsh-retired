local cmd, bootstrap, util = vim.cmd, require 'psoxizsh.plugins.bootstrap', require 'psoxizsh.util'
local cb_table = {}
local packer = nil

-- Plugins provides a hook based wrapper around packer.nvim, allowing
-- callers to register hooks at specific lifecycle events such as pre
-- and post plugin load.
--
-- A new, uninitialized one is provided upon requiring this module,
-- See :setup/1 and :init/0 for more on configuring and initializing
-- this object
local Plugins = { mt = {} }

-- Creates a new, uninitialized Plugins
--
-- You must call :init/0 (and likely :setup/1) before using this
-- object, though you can directly invoke the Plugins object as
-- you would :setup/1 as a convenience
function Plugins.new()
  local m = {
    _list = {},
    _hooks = {},
  }
  setmetatable(m, Plugins.mt)

  return m
end

-- Configures this Plugins, with the provided opts
--
-- You can provide a tables of hooks by name or { name, callback }
-- tuples.
--
-- In the former case, Plugins will create User <name> autocmds
-- when the lifecycle stage is hit, which you can register arbitrary
-- code to be invoked on.
--
-- In the latter, the provided callback fn will be invoked at the
-- lifecycle stage, with 'post' and 'late' hooks being provided the
-- current Plugins object as the first argument
--
-- @opts = {
--   hooks = {
--     early = name | { name, callback/0 }
--     pre   = name | { name, callback/0 }
--     post  = name | { name, callback/1 }
--     late  = name | { name, callback/1 }
--   }
-- }
function Plugins.setup(self, opts)
  opts = opts or {}
  local hooks = opts.hooks or {}

  self._hooks = vim.tbl_map(function(hk)
    local t = type(hk)
    if t == 'string' then return hk end
    if t == 'table' then return hk[1] end
  end, hooks)

  local callbacks = vim.tbl_map(function(hk)
    local t = type(hk[2])
    if t == 'function' then return hk[2] end
  end, hooks)

  self:list_regen()
  self:register_callbacks(callbacks)

  return self
end

-- Invokes the plugin manager, and hooks any provided hooks as they become ready
--
-- Note, you shouldn't rerun this function, use :reload/0 instead if you want to
-- reload an existing Plugins
function Plugins.init(self)
  self:do_hook 'early'

  if packer == nil then
    cmd [[packadd packer.nvim]]

    packer = require 'packer'
    packer.init {
      max_jobs = 32
    }
  end

  packer.reset()

  self:do_hook 'pre'

  for _, spec in ipairs(self:list()) do
    packer.use(spec)
  end

  self:do_hook 'post'
  self:do_hook 'late'

  return self
end

-- Regenerate the plugin spec list, reloading the config if it has changed.
--
-- Note that this method *only* reloads the spec list, it does not reload
-- plugins, see :reload/0 for that
function Plugins.list_regen(self)
  local plugs = util.mreload('psoxizsh.plugins.plug')
  self._list = plugs(util.try_mconfig('plug'))

  return self:list()
end

-- Return the current plugin list
function Plugins.list(self)
  return self._list
end

-- Get the plugin spec for the provided @id.
--
-- The plugin id will be either the last component of the name, or if redefined by 'as',
-- whatever 'as' is.
--
-- Returns the spec if it exists, nil otherwise
function Plugins.get(self, id)
  local needle = function(p)
    local plugid = p.as and p.as or p[1] and p[1]:match("^.+/(.+)$")

    return plugid == id
  end

  return vim.tbl_filter(needle, self:list())[1]
end

-- Check if the plugin @id exists in the current spec table
--
-- Returns true if it does, nil otherwise
function Plugins.has(self, id)
  return self:get(id) and true or nil
end

-- Reload plugins, and rerun any registered hooks
function Plugins.reload(self)
  self:list_regen()
  self:init()
  packer.compile()
end

-- Request the active Plugins to run the provided lifecycle's hook
--
-- Note that this may not run immediately, depending on current lifecycle
-- of underlying plugin manager
--
-- @name { 'early' | 'pre' | 'post' | 'late' }
function Plugins.do_hook(self, name)
  if name and name == 'post' or 'late' then
    self:_post_hook(self._hooks[name])
  else
    self:_pre_hook(self._hooks[name])
  end
end

-- Manually (re)register callbacks for any configured lifecycle hooks
--
-- Note that any hooks that were not registered in :setup/1 will be
-- silently ignored.
--
-- You may consider re-initializing the active Plugins via :setup/1:init/0
function Plugins.register_callbacks(self, callbacks)
    _G._psoxizsh_plugins_cb = function(id) cb_table[id](self) end
    cb_table = {}

    cmd [[augroup PsoxConfigCallbacks]]
    cmd [[autocmd!]]
    for n, fn in pairs(callbacks) do
      local id = self._hooks[n]
      cb_table[id] = fn
      cmd(string.format('autocmd User %s call v:lua._psoxizsh_plugins_cb("%s")', id, id))
    end
    cmd [[augroup END]]
end

function Plugins._pre_hook(self, hook)
  self:_dispatch_autocmd(hook)
end

function Plugins._post_hook(self, hook)
  if bootstrap() and hook then
    cmd [[augroup PsoxConfigBootstrap]]
    cmd [[autocmd!]]
    cmd [[autocmd VimEnter * ++once PackerSync]]
    cmd [[augroup END]]

    cmd ('augroup PsoxConfigDeferHook_' .. hook)
    cmd ('autocmd!')
    cmd ('autocmd User PackerCompileDone doautocmd User ' .. hook)
    cmd ('augroup END')
  else
    self:_dispatch_autocmd(hook)
  end
end

function Plugins._dispatch_autocmd(_, hook)
  if hook then cmd('doautocmd User ' .. hook) end
end

-- Setup a convenience method for setting up + initializing a Plugins object
-- via directly calling the object with the opts that would normally be
-- provided to :setup/1
function Plugins.mt.__call(self, opts)
    self:setup(opts):init()
end

-- Allow callers to access the underlying packer object
function Plugins.mt.__index(_, key)
  return Plugins[key] or packer[key]
end

return Plugins.new()
