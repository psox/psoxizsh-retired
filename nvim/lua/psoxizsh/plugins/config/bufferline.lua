return function()
  local bl, key, util = require 'bufferline', require 'psoxizsh.key.map', require 'psoxizsh.util'

  local defaults = {
    always_show_bufferline = true,
    numbers = "none",
    diagnostics = 'coc',
    offsets = {{
      filetype = 'neo-tree',
      text = 'File Explorer',
      text_align = 'center'
    }},
    show_buffer_close_icons = false,
    separator_style = { '\u{E0B0}', '\u{E0B1}' },
    sort_by = 'relative_directory',
  }

  bl.setup(util.mconfig('config.bufferline', { options = defaults }))
end
