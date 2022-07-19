return function()
  local fn, o, api = vim.fn, vim.o, vim.api

  if fn.executable('rg') == 1 then
    -- Override the default grep implementation in vim
    o.grepprg = 'rg --vimgrep --smart-case --follow'

    if fn.has('nvim-0.7') == 1 then
      -- Only search file contents, not file name
      -- We can use the stock :Files for that
      local rg_func = function(opts)
        return fn['fzf#vim#grep'](
          "rg --column --line-number --no-heading --color=always --smart-case " .. fn.shellescape(opts.args),
          true,
          fn['fzf#vim#with_preview']({options = '--delimiter : --nth 4..'}),
          opts.bang
        )
      end
      api.nvim_create_user_command('Rg', rg_func, { nargs = '*', bang = true })

      -- If the user hasn't set a default FZF command, and has ripgrep installed,
      -- use it over find, otherwise defer to the user's preferred command
      if fn.empty(os.getenv('FZF_DEFAULT_COMMAND')) == 1 then
        local files_func = function(opts)
          return fn['fzf#vim#files'](
            opts.args,
            fn['fzf#vim#with_preview']({source = 'rg --files --hidden --glob "!**/.git/**" '}),
            opts.bang
          )
        end
        api.nvim_create_user_command('Files', files_func, { nargs = '?', bang = true, complete = 'dir' })
      end
    end
  end
end
