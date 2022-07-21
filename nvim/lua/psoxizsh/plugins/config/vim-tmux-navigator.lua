return function()
 local g, vimp = vim.g, require 'vimp'

 g['tmux_navigator_no_mappings'] = 1
 g['tmux_navigator_disable_when_zoomed'] = 1

 vimp.nnoremap({'override', 'silent'}, '<C-h>', ':TmuxNavigateLeft<CR>')
 vimp.nnoremap({'override', 'silent'}, '<C-j>', ':TmuxNavigateDown<CR>')
 vimp.nnoremap({'override', 'silent'}, '<C-k>', ':TmuxNavigateUp<CR>')
 vimp.nnoremap({'override', 'silent'}, '<C-l>', ':TmuxNavigateRight<CR>')
end
