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
    { 'CursorHold', '*', function() D.open_float({ focusable = false, scope = 'cursor' }) end }
  }
end

function M.setup(_)
  M.config()
  M.keymaps()
  M.autocmds()
end

return M
