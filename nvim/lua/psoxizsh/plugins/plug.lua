
local plugins = {
  -- Allow packer to manage itself
  { 'wbthomason/packer.nvim',
      opt = true,
      cmd = 'Packer*',
      module_pattern = { 'packer', 'packer%..*' }
  },

  -- Utils for wrapping vimscript in lua easier
  { 'svermeulen/vimpeccable',
      as = 'vimp'
  },

  -- Used for autocmds if we're not using a late enough version of neovim
  { 'jakelinnzy/autocmd-lua',
      disable = vim.fn.has('nvim-0.7') == 1
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
