
local plugins = {
  -- Allow packer to manage itself
  { 'wbthomason/packer.nvim',
      opt = true,
      cmd = 'Packer*',
      module_pattern = { 'packer', 'packer%..*' }
  },

  -- Community patch for Vim
  { 'tpope/vim-sensible' },

  -- Utils for wrapping vimscript in lua easier
  { 'svermeulen/vimpeccable',
      as = 'vimp'
  },

  -- Used for autocmds if we're not using a late enough version of neovim
  { 'jakelinnzy/autocmd-lua',
      disable = vim.fn.has('nvim-0.7') == 1
  },

  -- Text alignment
  { 'junegunn/vim-easy-align' },
  { 'tmsvg/pear-tree',
      config = require 'psoxizsh.plugins.config.pear-tree'
  },

  -- Git integration
  { 'tpope/vim-fugitive' },

  -- Comment helpers
  { 'scrooloose/nerdcommenter' },

  -- Stat line integrations

  -- Buffer mangement
  { 'qpkorr/vim-bufkill' },
  { 'romainl/vim-qf',
      config = require 'psoxizsh.plugins.config.vim-qf'
  },

  -- IDE stuff + language highlighting
  { 'neomake/neomake',
      config = require 'psoxizsh.plugins.config.neomake'
  },
  { 'vim-perl/vim-perl',
      ft = 'perl',
      run = 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny'
  },
  { 'rust-lang/rust.vim',
      ft = 'rust'
  },
  { 'pearofducks/ansible-vim',
      ft = {'yaml', 'yml'}
  },
  { 'kevinoid/vim-jsonc' },
  { 'luochen1990/rainbow' },
  { 'sheerun/vim-polyglot' },

  -- Fuzzy search helpers
  { 'junegunn/fzf',
      cmd = 'FZF',
      fn = { 'fzf#run', 'fzf#wrap' }
  },
  { 'junegunn/fzf.vim',
      config = require 'psoxizsh.plugins.config.fzf'
  },
  { 'adelarsq/vim-matchit' },
  { 'mox-mox/vim-localsearch' },

  -- Color themes
  { 'rakr/vim-one',
      config = function() vim.cmd(string.format('colorscheme %s', vim.g.my_color_scheme or 'one')) end
  },
  { 'romainl/vim-cool' },

  -- Other
  { 'roxma/nvim-yarp' },
  { 'roxma/vim-hug-neovim-rpc' },
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
