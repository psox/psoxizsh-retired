return function()
  local fn, o, g = vim.fn, vim.opt, vim.g
  local vimp, au = require 'vimp', require 'psoxizsh.autocmd'

  local t = function(s)
    return vim.api.nvim_replace_termcodes(s, true, true, true)
  end

  g['coc_global_extensions'] = {
    'coc-yank',
    'coc-spell-checker',
    'coc-vimlsp',
    'coc-rust-analyzer',
    'coc-json',
    'coc-markdownlint',
    'coc-yaml'
  }

  -- Do action on current word
  vimp.nmap({'silent'}, '<leader>.', '<Plug>(coc-codeaction-selected)w')

  -- Do action on a selection
  vimp.nmap({'silent'}, '<leader>/', '<Plug>(coc-codeaction-selected)')
  vimp.xmap({'silent'}, '<leader>/', '<Plug>(coc-codeaction-selected)')

  -- Rename symbol
  vimp.nmap({'silent'}, '<leader>rn', '<Plug>(coc-rename)')
  -- Goto definition / references
  vimp.nmap({'silent'}, '<leader>gd', '<Plug>(coc-definition)')
  vimp.nmap({'silent'}, '<leader>gr', '<Plug>(coc-references)')

  -- Use tab for trigger completion with characters ahead and navigate.
  -- NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  -- other plugin before putting this into your config.
  vimp.inoremap({'silent', 'expr'}, '<TAB>', [[coc#pum#visible() ? coc#pum#next(1) : CheckBackspace() ? "\<Tab>" : coc#refresh()]])
  vimp.inoremap({'expr'}, '<S-TAB>', [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]])

  vim.cmd [[
    function! CheckBackspace() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
  ]]

  -- Make <CR> to accept selected completion item or notify coc.nvim to format
  -- <C-g>u breaks current undo, please make your own choice.
  vimp.inoremap({'silent', 'expr'}, '<C-Space>', [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"]])

  -- Use `[g` and `]g` to navigate diagnostics
  vimp.nmap({'silent'}, '[g', '<Plug>(coc-diagnostic-prev)')
  vimp.nmap({'silent'}, ']g', '<Plug>(coc-diagnostic-next)')

  if fn.has('nvim-0.4') then
    -- Remap PageUp and PageDown for scroll float windows/popups.
    vimp.nnoremap({'silent', 'nowait', 'expr'}, '<PageDown>', [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<PageDown>"]])
    vimp.nnoremap({'silent', 'nowait', 'expr'}, '<PageUp>', [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<PageUp>"]])
  end

  -- Use K to show documentation in preview window.
  local show_documentation = function()
    return fn.CocAction('hasProvider', 'hover')
      and fn.CocActionAsync('doHover')
      or fn.feedkeys('K', 'in')
  end
  vimp.nnoremap({'silent'}, 'K', show_documentation)

  -- Open yank list
  vimp.nnoremap({'silent'}, '<C-Y>', t':<C-u>CocList -A --normal yank<CR>')

  au.PsoxCocAutos {
    { 'CursorHold', '*', function() fn.CocActionAsync('highlight') end },
    { 'User', 'CocJumpPlaceholder', function() fn.CocActionAsync('showSignatureHelp') end },
  }
end
