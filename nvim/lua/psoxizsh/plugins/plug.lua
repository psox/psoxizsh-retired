
local plugins = {
  -- Allow packer to manage itself
  { 'wbthomason/packer.nvim',
      opt = true,
      cmd = 'Packer*',
      module_pattern = { 'packer', 'packer%..*' }
  },

  -- Community patch for Vim
  { 'tpope/vim-sensible' },

  -- Used in psoxizsh.* modules
  { 'nvim-lua/plenary.nvim' },

  -- Utils for wrapping vimscript in lua easier
  { 'svermeulen/vimpeccable',
      as = 'vimp'
  },

  -- Color themes
  { 'olimorris/onedarkpro.nvim',
      config = require 'psoxizsh.plugins.config.onedark'
  },

  -- Text alignment
  { 'junegunn/vim-easy-align' },
  { 'tmsvg/pear-tree',
      config = require 'psoxizsh.plugins.config.pear-tree'
  },

  -- Git integration
  { 'tpope/vim-fugitive' },

  -- File browser
  { 'nvim-neo-tree/neo-tree.nvim',
      as = 'neo-tree',
      branch = 'v2.x',
      requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
      },
      after = 'vimp',
      cmd = { 'Neotree', 'NeoTree*' },
      keys = { '<F2>', '<leader>gs', '<leader><S-TAB>' },
      config = require 'psoxizsh.plugins.config.neotree'
  },

  -- Comment helpers
  { 'scrooloose/nerdcommenter' },

  -- Stat line integrations
  { 'nvim-lualine/lualine.nvim',
      requires = {
        'kyazdani42/nvim-web-devicons',
        'lewis6991/gitsigns.nvim'
      },
      config = require 'psoxizsh.plugins.config.lualine'
  },
  { 'akinsho/bufferline.nvim',
      as = 'bufferline',
      tag = 'v2.*',
      requires = { 'kyazdani42/nvim-web-devicons' },
      after = 'vimp',
      config = require 'psoxizsh.plugins.config.bufferline'
  },
  { 'lewis6991/gitsigns.nvim',
      tag = 'release',
      requires = { 'nvim-lua/plenary.nvim' },
      config = require 'psoxizsh.plugins.config.gitsigns'
  },

  -- Buffer management
  { 'qpkorr/vim-bufkill' },
  { 'romainl/vim-qf',
      config = require 'psoxizsh.plugins.config.vim-qf'
  },

  -- IDE stuff + language highlighting
  { 'neoclide/coc.nvim',
      disable = vim.fn.executable('node') ~= 1,
      branch = 'release',
      after = 'vimp',
      config = require 'psoxizsh.plugins.config.coc'
  },
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
  { 'romainl/vim-cool' },
  { 'adelarsq/vim-matchit' },
  { 'mox-mox/vim-localsearch' },

  -- Tmux integration for pane movement
  { 'christoomey/vim-tmux-navigator',
      keys = { '<C-h>', '<C-j>', '<C-k>', '<C-l>' },
      cmd = { 'TmuxNavigateLeft', 'TmuxNavigateDown', 'TmuxNavigateUp', 'TmuxNavigateRight', 'TmuxNavigatePrevious' },
      config = require 'psoxizsh.plugins.config.vim-tmux-navigator'
  },

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
