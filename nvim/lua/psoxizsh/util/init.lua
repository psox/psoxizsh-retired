
local Util = { mt = {} }
local Lazy = { mt = {} }

local Submodules = {
  mload = 'psoxizsh.util.mload',
}

function Util.new()
  local this = { _submodules = Util.submodules() }
  setmetatable(this, Util.mt)

  return this
end

function Util.submodules()
  local modules = {}

  for key, mod in pairs(Submodules) do
    modules[key] = Lazy.new(mod)
  end

  return modules
end

function Util.mt.__index(self, key)
  for _, submod in pairs(self._submodules) do
    if submod[key] then return submod[key] end
  end

  return nil
end

function Lazy.new(mod_name)
  local this = { _module = false, _mod_name = mod_name }
  setmetatable(this, Lazy.mt)

  return this
end

function Lazy.mt.__index(self, key)
  if not self._module then
    self._module = require(self._mod_name)
  end

  return self._module[key]
end

return Util.new()
