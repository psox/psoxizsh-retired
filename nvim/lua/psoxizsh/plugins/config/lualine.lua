return function()
  local ll, util, nwd = require 'lualine', require 'psoxizsh.util', require("nvim-web-devicons")

  local file_color = function()
    local _, color = nwd.get_icon_colors_by_filetype(vim.bo.filetype)

    return { fg = color }
  end
  local diff_source = function()
    -- May be nil if gitsigns hasn't populated yet
    local gs = vim.b.gitsigns_status_dict or {}

    return {
      added = gs.added,
      modified = gs.changed,
      removed = gs.removed,
    }
  end

  local filename = {
    'filename',
    icon = 'ƒ',
    symbols = { modified = '|', readonly = '|', unnamed = '〜' },
    color = file_color,
  }
  local branch = { 'b:gitsigns_head', icon = '', color = { gui = 'bold' } }
  local diagnostics = { 'diagnostics', sources = { 'coc' }, update_in_insert = true }
  local diff = { 'diff', source = diff_source }

  local defaults = {
    options = {
      theme = 'auto',
      icons_enabled = true,
      component_separators = { left = '', right = ''},
      section_separators = { left = '', right = ''},
      disabled_filetypes = {},
      always_divide_middle = true,
      globalstatus = true,
      refresh = {
        statusline = 1000,
        tabline = 1000,
        winbar = 1000,
      }
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { branch, diff, diagnostics },
      lualine_c = { filename },
      lualine_x = {'filetype', 'encoding', 'fileformat'},
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { filename },
      lualine_x = { 'location' },
      lualine_y = {},
      lualine_z = {}
    },
    extensions = { 'fugitive', 'quickfix', 'man', 'fzf', 'neo-tree', 'toggleterm' }
  }

  ll.setup(util.mconfig('config.lualine', defaults))
end
