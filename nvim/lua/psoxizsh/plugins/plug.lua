
local plugins = {
  -- Allow packer to manage itself
  { 'wbthomason/packer.nvim',
      opt = true,
      cmd = 'Packer*',
      module_pattern = { 'packer', 'packer%..*' }
  },
}

local function concatArray(a, b)
  local result = {unpack(a)}
  for i = 1,#b do
    result[#a+i] = b[i]
  end

  return result
end

return function(extra)
  extra = extra or {}

  return concatArray(plugins, extra)
end
