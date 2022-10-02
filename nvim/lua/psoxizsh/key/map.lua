local bind = require 'psoxizsh.key.bind'

local G, B = bind.Group, bind.MkBind

local M = G:new()

-- ############################
-- ## NORMAL global bindings ##
-- ############################
M.Global.N {
  { mode = 'n' },
  -- #####################
  -- ## Leader Mappings ##
  -- #####################
  --
  Leader = G {
    { prefix = '<Leader>' },

    OpenConfig   = B { 'Open user Neovim configuration files' , key = 've' , } ,
    ReloadConfig = B { 'Reload Neovim configuration'          , key = 'vs' , } ,
    ToggleGutter = B { 'Toggle Neovim gutter'                 , key = 'N'  , } ,

    ToggleBuffers   = B { 'Open buffer list'      , key = '<Tab>' , action = '<cmd>Neotree toggle reveal float source=buffers<CR>' , } ,
    ToggleGitStatus = B { 'Open Git status float' , key = 'gs'    , action = '<cmd>Neotree float git_status<CR>'                   , } ,

  },

  -- ################
  -- ## Navigation ##
  -- ################
  --
  -- Tmux interplay
  --
  NavigateLeft  = B { 'Navigate left one window'  , key = '<C-h>', action = '<cmd>TmuxNavigateLeft<CR>'  , } ,
  NavigateDown  = B { 'Navigate down one window'  , key = '<C-j>', action = '<cmd>TmuxNavigateDown<CR>'  , } ,
  NavigateUp    = B { 'Navigate up one window'    , key = '<C-k>', action = '<cmd>TmuxNavigateUp<CR>'    , } ,
  NavigateRight = B { 'Navigate right one window' , key = '<C-l>', action = '<cmd>TmuxNavigateRight<CR>' , } ,
  --
  -- Buffer movement
  --
  BufferNext = B { 'Next buffer or tab'     , key = '<Tab>'   , action = '<cmd>BufferLineCycleNext<CR>' , } ,
  BufferPrev = B { 'Previous buffer or tab' , key = '<S-Tab>' , action = '<cmd>BufferLineCyclePrev<CR>' , } ,
}

-- #############################
-- ## COMMAND global bindings ##
-- #############################
M.Global.C {
  {  mode = 'c' },
  -- ####################
  -- ## File utilities ##
  -- ####################
  --
  SudoWrite = B { 'Sudo write the current file' , key = 'w!!', action = 'w !sudo tee % >/dev/null', } ,
}

-- ############################
-- ## INSERT global bindings ##
-- ############################
M.Global.I {
  { mode = 'i' },
}

-- ############################
-- ## VISUAL global bindings ##
-- ############################
M.Global.V {
  { mode = 'v' },
}

M.Buffer.N {
  { mode = 'n' },

  CloseNetrw = B { 'Force close netrw windows', key = '<ESC>' }
}

return M
