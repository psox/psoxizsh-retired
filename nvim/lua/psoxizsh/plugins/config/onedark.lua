return function()
  local odp, util = require 'onedarkpro', require 'psoxizsh.util'

  local defaults = {
    plugins = { all = true },
    styles = {
      comments = 'italic',
    },
    options = {
      bold            = true,
      italic          = true,
      underline       = true,
      undercurl       = true,
    },
  }

  if not vim.g.my_color_scheme then vim.g.my_color_scheme = 'onedarkpro' end

  odp.setup(util.mconfig('config.onedark', defaults))
end

