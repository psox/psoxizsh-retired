return function()
  local cmp, util = require 'cmp', require 'psoxizsh.util'
  local kmap, cfg, lspkind = cmp.mapping, cmp.config, require 'lspkind'
  local sources, w = cfg.sources, cfg.window
  local mode = { insert = kmap.preset.insert, cmd = kmap.preset.cmdline }

  local defaults = { snippet = {}, mapping = {}, sources = {} }

  local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
  end

  local fkey = function(key, md)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), md or '', true)
  end

  -- Snippet provider
  defaults.snippet.expand = function(args)
    vim.fn['vsnip#anonymous'](args.body)
  end

  -- Key maps for auto completion
  defaults.mapping = {
      ['<Tab>'] = kmap(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif vim.fn['vsnip#available'](1) == 1 then
          fkey '<Plug>(vsnip-expand-or-jump)'
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = kmap(function()
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.fn['vsnip#jumpable'](-1) == 1 then
          fkey '<Plug>(vsnip-jump-prev)'
        end
      end, { 'i', 's' }),
      ['<PageUp>']    = kmap.scroll_docs(-4),
      ['<PageDown>']  = kmap.scroll_docs(4),
      ['<C-Space>']   = kmap.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
  }
  defaults.mapping = mode.insert(defaults.mapping)
  defaults.mapping = mode.cmd(defaults.mapping)

  -- Sources of auto completion
  --
  -- Each group of completions is prioritized in ascending order;
  -- that is, 'path's will be shown before 'nvim_lsp's, etc
  defaults.sources = sources(
    {
      { name = 'path',                                            },
    },
    {
      { name = 'nvim_lsp',                    keyword_length = 2  },
      { name = 'nvim_lsp_signature_help',                         },
    },
    {
      { name = 'vsnip',                       keyword_length = 2  },
    },
    {
      { name = 'buffer',                      keyword_length = 2  },
      { name = 'spell', max_item_count = 3,   keyword_length = 3  },
    }
  )

  -- Auto completion window settings
  defaults.window = {
    completion = {
      col_offset = -3,
      side_padding = 0,
    },
    documentation = w.bordered(),
  }

  -- Auto completion item formatting
  defaults.formatting = {
    fields = { 'kind', 'abbr', 'menu' },
    format = function(entry, item)
      local kind = lspkind.cmp_format({ mode = 'symbol_text', maxwidth = 50 })(entry, item)
      local strings = vim.split(kind.kind, '%s', { trimempty = true })
      kind.kind = ' ' .. strings[1] .. ' '
      kind.menu = '    (' .. strings[2] .. ')'

      return kind
    end,
  }

  cmp.setup(util.mconfig('config.nvim-cmp', defaults))
end
