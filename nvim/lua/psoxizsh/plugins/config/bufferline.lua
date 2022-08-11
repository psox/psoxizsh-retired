return function()
  local bl, vimp, util = require 'bufferline', require 'vimp', require 'psoxizsh.util'

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

  bl.setup (util.mconfig('config.bufferline', { options = defaults }))

  vimp.nnoremap({'silent'}, '<TAB>',          ':BufferLineCycleNext<CR>')
  vimp.nnoremap({'silent'}, '<S-TAB>',        ':BufferLineCyclePrev<CR>')
  vimp.nnoremap({'silent'}, '<leader><TAB>',  ':BufferLinePick<CR>')
end
