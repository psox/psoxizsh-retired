local o, g, fn, cmd = vim.opt, vim.g, vim.fn, vim.cmd
local au, util = require 'psoxizsh.autocmd', require 'psoxizsh.util'

local function psoxizsh_early_config()
  -- Local early configuration
  util.try_mreload('early')

  -- Set global color scheme var
  if not g.my_color_scheme then
    g.my_color_scheme = 'one'
  end

  -- Color settings
  o.background = 'dark'
  o.termguicolors = true

  -- Hide buffers don't close them
  o.hidden = true

  -- Sane pane opening
  o.splitbelow = true
  o.splitright = true

  -- File indent opts
  o.encoding = "utf-8"

  o.shiftwidth = 2
  o.tabstop = 8
  o.softtabstop = 2
  o.expandtab = true

  o.list = true
  o.listchars:append {
    trail     = '\u{02FD}',
    extends   = '\u{22B3}',
    precedes  = '\u{22B2}',
    nbsp      = '\u{02EC}',
    conceal   = '\u{2219}',
    tab       = '\u{2559}\u{254C}\u{2556}',
  }

  o.ignorecase = true
  o.infercase = true

  cmd 'filetype plugin indent on'

  -- Set completion messages off
  o.shortmess:append { c = true }

  -- Preview window + menu for autocompletions
  o.completeopt:append {
    'preview',
    'menuone',
    'longest',
  }

  -- Lower update time (Default 4000)
  o.updatetime = 300

  -- Numbered lines
  o.number = true
  o.relativenumber = true

  o.signcolumn = 'yes:1'

  -- Disable '--INSERT--' and friends
  o.showmode = false

  -- Use existing buffers
  o.switchbuf = { "useopen", "usetab" }

  -- Set global statusline (0.7+ only)
  if fn.has('nvim-0.7') == 1 then o.laststatus = 3 end

  -- Local pre plugin configuration
  util.try_mreload('pre')
end

-- Load plugins

local function psoxizsh_post_config(plugs)
  local vimp = require 'vimp'
  -- Local post plugin configuration
  util.try_mreload('post')

  cmd('colorscheme ' .. vim.g.my_color_scheme)

  -- Setup file backups
  cmd ':silent !mkdir -p ~/.vimbackup'
  o.backupdir = fn.expand('~') .. '/.vimbackup'
  o.directory = fn.expand('~') .. '/.vimbackup'

  o.hlsearch = true

  -- ripgrep settings
  g.rg_highlight = 'true'
  g.rg_derive_root = 'true'

  -- Other
  g.rainbow_active = 1

  au.PsoxFileAutos {
    { 'FileType', 'yaml', 'setlocal indentkeys-=<:> ts=8 sts=2 sw=2 expandtab' },
    { 'FileType', 'go',   'setlocal ts=8 sts=4 sw=4 noexpandtab' },
    { 'FileType', 'quickfix,netrw', 'setlocal nobuflisted' },
    { 'FileType', 'netrw', function() require('vimp').nmap({'buffer', 'silent'}, '<ESC>', ':call CloseNetrw()<CR>') end },
  }

  cmd([[
  function! CloseNetrw() abort
    for bufn in range(1, bufnr('$'))
      if bufexists(bufn) && getbufvar(bufn, '&filetype') ==# 'netrw'
        silent! execute 'bwipeout ' . bufn
        if getline(2) =~# '^" Netrw '
          silent! bwipeout
        endif
        return
      endif
    endfor
  endfunction
  ]])

  if plugs:has('fzf') then
    if fn.executable('rg') == 1 then
      vimp.nnoremap('<A-g>', ':Rg ')
      vimp.nnoremap('<leader><A-g>', ':Rg! ')
      vimp.nnoremap({'silent'}, '<A-S-g>', ':Rg<CR>')
      vimp.nnoremap({'silent'}, '<leader><A-S-g>', ':Rg!<CR>')
    end

    vimp.nnoremap('<A-f>', ':Files ')
    vimp.nnoremap('<leader><A-f>', ':Files! ')
    vimp.nnoremap({'silent'}, '<A-S-f>', ':Files<CR>')
    vimp.nnoremap({'silent'}, '<leader><A-S-f>', ':Files!<CR>')

    vimp.nnoremap('<A-b>', ':Buffers ')
    vimp.nnoremap('<leader><A-b>', ':Buffers! ')
    vimp.nnoremap({'silent'}, '<A-S-b>', ':Buffers<CR>')
    vimp.nnoremap({'silent'}, '<leader><A-S-b>', ':Buffers!<CR>')
  end

  -- Workaround for writing readonly files
  vimp.cnoremap({'silent'}, 'w!!', 'w !sudo tee % >/dev/null')

  -- Open any known user configuration paths for editing
  vimp.nnoremap({'silent'}, '<leader>ve', function()
    local rtp = vim.fn.join(o.runtimepath:get(), ',')
    local files = {
      early = vim.fn.globpath(rtp, '/lua/early.lua', 0, 1)[1] or nil,
      pre   = vim.fn.globpath(rtp, '/lua/pre.lua', 0, 1)[1] or nil,
      post  = vim.fn.globpath(rtp, '/lua/post.lua', 0, 1)[1] or nil,
      late  = vim.fn.globpath(rtp, '/lua/late.lua', 0, 1)[1] or nil,
      my    = os.getenv("MYVIMRC") or nil,
    }

    for _, file in pairs(files) do
      if vim.fn.filereadable(file) == 1 then
        cmd('edit ' .. file)
      end
    end
  end)

  -- Toggles all gutter items
  vimp.nnoremap({'silent'}, '<leader>N', function()
    if o.number:get() then
      o.number = false
      o.relativenumber = false
      o.signcolumn = 'no'
    else
      o.number = true
      o.relativenumber = true
      o.signcolumn = 'yes:1'
    end
  end)

  -- Reload configuration
  vimp.nnoremap('<leader>vs', function() vimp.unmap_all() plugs:reload() end)

  g.one_allow_italics = 1
  cmd('highlight Comment term=italic cterm=italic gui=italic')
end

local function psoxizsh_late_config(_)
  -- Local late configuration
  util.try_mreload('late')

  -- Rest of config below is specifically not user override-able
  o.exrc = true
  o.secure = true
  o.modeline = true
  o.modelines = 7
end

local hooks = {
  early = { 'PsoxConfigEarly', psoxizsh_early_config },
  post  = { 'PsoxConfigPost',  psoxizsh_post_config },
  late  = { 'PsoxConfigLate',  psoxizsh_late_config },
}

return require('psoxizsh.plugins') { hooks = hooks }
