
local Util = {}

-- Reload a given module, returning the result of loading it.
function Util.mreload(module)
  if package.loaded[module] then
    package.loaded[module] = nil
  end

  return require(module)
end

-- Try reloading the given module, returning ok, module
function Util.try_mreload(module)
  return pcall(Util.mreload, module)
end

-- Try reloading the given config module, returning either
-- its table or an empty one, if the module couldn't be loaded
--
-- The arguments can be:
-- 1. module string --> table
-- 2. module string --> fn() -> table
-- 3. table
-- 4. fn() --> table
--
-- It the latter cases, *configuration will not be reloaded*, this is
-- primaraily meant for inline, static configuration
function Util.try_mconfig(module)
  if type(module) ~= "string" then
    module = type(module) == "function" and module() or module
    module = type(module) == "table" and module or {}

    return module
  end

  local ok, config = Util.try_mreload(module)
  config = type(config) == "function" and config() or config

  return (ok and type(config) == "table") and config or {}
end

-- Retrieve the config table stored in the provided module,
-- merged with default the config module, if one is provided
--
-- The arguments can be:
-- 1. module string --> table
-- 2. module string --> fn() -> table
-- 3. table
-- 4. fn() --> table
--
-- It the latter cases, *configuration will not be reloaded*, this is
-- primaraily meant for inline, static configuration
--
-- Note: the config returned from the given module may optionally
-- set 'no_defaults = true' to opt out of the merging
function Util.mconfig(module, defaults)
  module = Util.try_mconfig(module)
  defaults = Util.try_mconfig(defaults)

  if module.no_defaults then
    return module
  else
    return vim.tbl_deep_extend('keep', module, defaults)
  end
end

return Util
