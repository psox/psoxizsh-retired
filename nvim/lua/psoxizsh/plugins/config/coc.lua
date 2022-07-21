return function()
  local fn, o, g = vim.fn, vim.opt, vim.g
  local vimp, au = require 'vimp', require 'psoxizsh.autocmd'

  if fn.executable('node') == 0 then return end

  local t = function(s)
    return vim.api.nvim_replace_termcodes(s, true, true, true)
  end
  local pumvisible = function()
    return fn.pumvisible() == 1
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

  -- Basically, we're checking to see if the column behind the current
  -- either doesn't exist or is whitespace
  local ck_backspace = function()
    local col = fn.col('.') - 1

    return
      col == 0
        and true
      or fn.getline('.'):sub(col, col):match('%s')
        and true
      or false
  end

  vimp.inoremap({'silent', 'expr'}, '<TAB>', function()
    return
      pumvisible()
        and t'<C-n>'
      or ck_backspace()
        and t'<TAB>'
      or fn['coc#refresh']()
  end)
  vimp.inoremap({'expr'}, '<S-TAB>', function()
    return pumvisible() and t'<C-p>' or t'<C-h>'
  end)

  -- Use <c-space> to confirm completion, `<C-g>u` means break undo chain at current
  -- position. Coc only does snippet and additional edit on confirm.
  -- <c-space> could be remapped by other vim plugin, try `:verbose imap <CR>`.
  vimp.inoremap({'expr'}, '<C-Space>', function()
    local info =
      fn.exists('*complete_info') == 1
        and fn.complete_info().selected ~= -1
      or pumvisible()

    return info and t'<C-y>' or t'<C-g>u<CR>'
  end)

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
    if vim.tbl_contains({'vim', 'help'}, o.filetype:get()) then
      vim.cmd('help ' .. fn.expand(t'<cword>'))
    elseif vim.fn['coc#rpc#ready']() == 1 then
      vim.fn.CocActionAsync('doHover')
    else
      vim.cmd('!' .. o.keywordprg:get() .. ' ' .. fn.expand(t'<cword>'))
    end
  end
  vimp.nnoremap({'silent'}, 'K', show_documentation)

  -- Open yank list
  vimp.nnoremap({'silent'}, '<C-Y>', t':<C-u>CocList -A --normal yank<CR>')

  au.PsoxCocAutos {
    { 'CursorHold', '*', function() fn.CocActionAsync('highlight') end },
    { 'User', 'CocJumpPlaceholder', function() fn.CocActionAsync('showSignatureHelp') end },
  }
end
