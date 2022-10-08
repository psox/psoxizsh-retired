local au, keys = require 'psoxizsh.autocmd', require 'psoxizsh.key.map'
local D = vim.diagnostic

local M = setmetatable({}, { __call = function(self, args) self.setup(args) end })

local sign = function(o)
  vim.fn.sign_define(o.name, {
    texthl = o.name,
    text = o.text,
    numhl = ''
  })
end

local DiagnosticFloat = function()
  -- current, last diagnostic cursor position
  local current = vim.api.nvim_win_get_cursor(0)
  local last = vim.w.diagnostics_last_cursor or { nil, nil }

  -- Show the popup diagnostics window,
  -- but only once for the current cursor location (unless moved afterwards).
  if not (current[1] == last[1] and current[2] == last[2]) then
    vim.w.diagnostics_last_cursor = current
    D.open_float({ focusable = false, scope = 'cursor' })
  end
end

function M.config()
  -- Setup signs
  sign({ name = 'DiagnosticSignError', text = '' })
  sign({ name = 'DiagnosticSignWarn',  text = '' })
  sign({ name = 'DiagnosticSignHint',  text = '' })
  sign({ name = 'DiagnosticSignInfo',  text = '' })

  -- Define base diagnostic configuration
  D.config({
    virtual_text      = false,
    signs             = true,
    update_in_insert  = true,
    underline         = true,
    severity_sort     = true,

    float = {
        border = 'rounded',
        source = 'if_many',
        header = '',
        prefix = '',
    },
  })
end


-- Key maps
function M.keymaps()
  keys.Global.N.DiagnosticPrev { action = D.goto_prev }
  keys.Global.N.DiagnosticNext { action = D.goto_next }
end

function M.autocmds()
  au.PsoxDiagnosticHover {
    { 'CursorHold', '*', DiagnosticFloat }
  }
end

function M.setup(_)
  M.config()
  M.keymaps()
  M.autocmds()
end

return M
