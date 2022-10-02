return function()
  local fn, g = vim.fn, vim.g
  local au = require 'psoxizsh.autocmd'

  g['coc_global_extensions'] = {
    'coc-yank',
    'coc-spell-checker',
    'coc-vimlsp',
    'coc-rust-analyzer',
    'coc-json',
    'coc-markdownlint',
    'coc-yaml'
  }

  au.PsoxCocAutos {
    { 'CursorHold', '*', function() fn.CocActionAsync('highlight') end },
    { 'User', 'CocJumpPlaceholder', function() fn.CocActionAsync('showSignatureHelp') end },
  }
end
