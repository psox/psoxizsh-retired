
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

  -- Color themes
  { 'olimorris/onedarkpro.nvim',
      config = require 'psoxizsh.plugins.config.onedark'
  },

  -- Pretty vim.notify
  { 'rcarriga/nvim-notify',
      tag = 'v3.*',
      config = require 'psoxizsh.plugins.config.notify'
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
      config = require 'psoxizsh.plugins.config.bufferline'
  },
  { 'lewis6991/gitsigns.nvim',
      tag = 'release',
      requires = { 'nvim-lua/plenary.nvim' },
      config = require 'psoxizsh.plugins.config.gitsigns'
  },
  -- LSP / Neovim '$/progress' handler
  { 'j-hui/fidget.nvim',
      config = require 'psoxizsh.plugins.config.fidget'
  },

  -- Buffer management
  { 'qpkorr/vim-bufkill' },
  { 'romainl/vim-qf',
      config = require 'psoxizsh.plugins.config.vim-qf'
  },

  -- IDE stuff + language highlighting
  { 'williamboman/mason.nvim',
      as = 'mason',
      branch = 'main',
      config = require 'psoxizsh.plugins.config.mason'
  },
  { 'williamboman/mason-lspconfig.nvim',
      as = 'mason-lspconfig',
      branch = 'main',
      after = 'mason',
      config = require 'psoxizsh.plugins.config.mason-lsp'
  },
  { 'neovim/nvim-lspconfig',
      as = 'lspconfig',
      after = { 'mason-lspconfig', 'cmp-nvim-lsp' },
      config = require 'psoxizsh.plugins.config.lspconfig'
  },
  { 'tamago324/nlsp-settings.nvim',
      branch = 'main',
      after = 'lspconfig',
      config = require 'psoxizsh.plugins.config.nlsp-settings'
  },
  { 'simrat39/rust-tools.nvim' },
  { 'folke/lua-dev.nvim',
      as = 'lua-dev',
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

  -- Autocompletion + snippets + vim.diagnostic sources
  -- Completion framework
  { 'hrsh7th/nvim-cmp',
      requires = { 'onsails/lspkind.nvim' },
      config = require 'psoxizsh.plugins.config.nvim-cmp'
  },

  -- Snippets
  { 'hrsh7th/vim-vsnip' },

  -- LSP sources
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help' },

  -- Other sources:
  { 'hrsh7th/cmp-vsnip' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-buffer' },
  { 'f3fora/cmp-spell',
      after = { 'lspconfig' },
      config = require 'psoxizsh.plugins.config.cmp-spell'
  },

  -- Tree sitter
  { 'nvim-treesitter/nvim-treesitter',
      requires = { 'p00f/nvim-ts-rainbow' },
      run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
      config = require 'psoxizsh.plugins.config.nvim-treesitter'
  },

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
