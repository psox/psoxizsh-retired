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

    SpellWhiteList     = B { 'Whitelist <cword> to [count] spellfile'      , key = 'ss'  , action = 'zg'  , } ,
    SpellBlackList     = B { 'Blacklist <cword> to [count] spellfile'      , key = 'sw'  , action = 'zw'  , } ,
    SpellWhiteListUndo = B { 'Undo whitelist <cword> in [count] spellfile' , key = 'sus' , action = 'zug' , } ,
    SpellBlackListUndo = B { 'Undo blacklist <cword> to [count] spellfile' , key = 'suw' , action = 'zuw' , } ,

    ToggleBuffers   = B { 'Open buffer list'      , key = '<Tab>' , action = '<cmd>Neotree toggle reveal float source=buffers<CR>' , } ,
    ToggleGitStatus = B { 'Open Git status float' , key = 'gs'    , action = '<cmd>Neotree float git_status<CR>'                   , } ,

  },

  -- ############
  -- ## Supers ##
  -- ############
  --
  Super = G {

    FileBrowser = B { 'Toggle File Browser'             , key = '<C-Left>'  , action  = '<cmd>Neotree toggle reveal position=left<CR>' , } ,
    FuzzySearch = B { 'Activate Telescope fuzzy finder' , key = '<C-Right>' , action  = '<cmd>Telescope builtin<CR>'                   , } ,
    Terminal    = B { 'Open terminal in a float'        , key = '<C-Up>'    , action  = '<cmd>ToggleTerm<CR>'                          , } ,
    Diagnostics = B { 'Open workspace diagnostics'      , key = '<C-Down>'  , action  = '<cmd>TroubleToggle<CR>'                       , } ,

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
  --
  -- Diagnostics
  --
  DiagnosticNext = B { 'Next buffer diagnostic'     , key = ']g' , } ,
  DiagnosticPrev = B { 'Previous buffer diagnostic' , key = '[g' , } ,
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

  -- #####################
  -- ## Auto completion ##
  -- #####################
  --
  Completion = G {
    { skip = true },

    Confirm    = B { 'Select the active completion entry and insert it'          , key = '<C-Space>'  , } ,
    Next       = B { 'Cycle selected completion item in completion menu'         , key = '<Tab>'      , } ,
    Prev       = B { 'Reverse cycle selected completion item in completion menu' , key = '<S-Tab>'    , } ,
    ScrollUp   = B { 'Scroll up completion item documentation'                   , key = '<PageUp>'   , } ,
    ScrollDown = B { 'Scroll down completion item documentation'                 , key = '<PageDown>' , } ,

  },
}

-- ############################
-- ## VISUAL global bindings ##
-- ############################
M.Global.V {
  { mode = 'v' },

  Completion = M.Global.I.Completion:new({ mode = 'v' })
}

M.Buffer.N {
  { mode = 'n' },

  CloseNetrw = B { 'Force close netrw windows', key = '<ESC>' }
}

-- ###################################
-- ## NORMAL LSP on_attach bindings ##
-- ###################################
M.Buffer.Lsp.N {
  { mode = 'n' },

  -- #####################
  -- ## Leader Mappings ##
  -- #####################
  --
  Leader = G {
    { prefix = '<Leader>' },

    -- ##################
    -- ## LSP Mappings ##
    -- ##################
    --
    RenameSymbol   = B { 'Rename <cword> symbol'                             , key = 'rn' , action = vim.lsp.buf.rename         , } ,
    FormatDocument = B { 'Format current document'                           , key = 'F'  , action = vim.lsp.buf.formatting     , } ,
    ShowSignature  = B { 'Display function signature help of <cword> symbol' , key = 'K'  , action = vim.lsp.buf.signature_help , } ,

  },

  -- ##################
  -- ## LSP Mappings ##
  -- ##################
  --
  GotoDefinition    = B { 'Jump to definition of <cword> symbol'              , key = 'gd'    , action = vim.lsp.buf.definition     , } ,
  ShowDocumentation = B { 'Display documentation of <cword> symbol'           , key = 'K'     , action = vim.lsp.buf.hover          , } ,
}

return M
