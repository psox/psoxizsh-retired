return function()
  local util, au = require 'psoxizsh.util', require 'psoxizsh.autocmd'
  local o, l, fn = vim.opt, vim.opt_local, vim.fn
  -- Yes, this is a bad idea, but I don't really feel like
  -- writing my own recursive ascent parser for file paths right now
  --
  -- *whips self* Don't randomly require unrelated modules!
  local ulsp = require 'lspconfig.util'

  local defaults = {
    -- Languages to recognize, only languages[1] is used for user dictionaries
    -- leave this alone unless you've read the entirety of ':h spell' and
    -- understand what you're doing
    languages     = { 'en_us', 'cjk' },
    -- Spell options (leave this alone)
    options       = { 'camel' },
    -- File names that indicate the root repo directory
    root_patterns = { '.vim', '.git', '.hg', 'Cargo.toml', 'package.json' },
    -- File glob to activate spell checking on, e.g '*.md'
    file_pattern  = '*',
  }

  local merged = util.mconfig('config.cmp-spell', defaults)
  local cfg = {
    spell_fname = string.format('%s.%s.add', 'words', o.encoding:get()),
    searcher = ulsp.root_pattern(unpack(merged.root_patterns)),
  }

  _G._psoxizsh_config_cmp_spell_on_enter = function()
    local checked, repo_root = {}, cfg.searcher(fn.getcwd())

    -- We look in these places for spell files
    -- 1. <workspace root>/.vim/
    -- 2. ~/.config/nvim
    -- 3. $PSOXIZSH/nvim/spellfile
    if repo_root then table.insert(checked, repo_root .. '/.vim') end
    vim.list_extend(checked, { '~/.config/nvim', vim.env.PSOXIZSH .. '/nvim/spellfile' })

    for i, path in ipairs(checked) do
      if path and fn.exists(fn.expand(path)) then
        checked[i] = path .. '/' .. cfg.spell_fname
      end
    end

    l.spell         = true
    l.spelllang     = merged.languages
    l.spelloptions  = merged.options
    l.spellfile     = checked
  end

  au.PsoxSpellSettings {{ 'BufEnter', merged.file_pattern, 'call v:lua._psoxizsh_config_cmp_spell_on_enter()' }}
end
