local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/opt/packer.nvim'
local repo_url = 'https://github.com/wbthomason/packer.nvim'
local strapped = nil

-- Bootstraps our package manager, ensuring it is present on the local system
local function bootstrap()
  local should_install = fn.empty(fn.glob(install_path)) > 0

  if should_install then
    fn.system({'git', 'clone', '--depth', '1', repo_url, install_path})
  end

  return should_install
end

if not strapped then
  strapped = bootstrap()
end

return function()
  return strapped
end

