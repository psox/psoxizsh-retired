-- This module provides a highlight API that can be used in lua.
--
-- Each highlight may set its fg and bg colors, and any attributes
-- it may desire (italic, bold, etc).
--
-- You may also call .clear() on any highlight object to completely
-- remove the highlight
--
-- There are two major methods for using this module:
-- 1. By directly calling the module itself
-- 2. By indexing into the highlight group
--
-- Examples:
--
-- ```
-- local hl = require 'psoxizsh.util.highlight'
--
-- hl {
--  -- Note that colors are selected from sub objects first (gui.bg), then named top level
--  -- keys (ctermfg) and lastly unamed top level keys (fg, bg)
--  { 'Comment', italic = true, gui = { bg = '#0000' }, ctermbg = '#0000' },
--  -- You may select multiple highlight groups at once
--  { { 'TmuxSelect', 'TmuxHover' }, underdash = true, fg = '#FFFF', bg = '#FFFF' }
-- }
--
-- hl.clear({ 'Comment', 'TmuxHover', 'TmuxSelect' })
-- ```
--
-- ```
-- local hl = require 'psoxizsh.util.highlight'
--
-- hl.Comment { italic = true, underdot = true }
-- hl.LspInstallDone { bold = true, gui { bg = '#1E12' } }
-- hl.TmuxTree.clear()
-- ```

local cmd = vim.cmd
local ATTR = {
  ITEMS = {
    bold = 1, underline = 1, underlineline = 1,
    undercurl = 1, underdot = 1, underdash = 1,
    strikethrough = 1, reverse = 1, inverse = 1,
    italic = 1, standout = 1, nocombine = 1,
    NONE = 1,
  },
  KEYS = {
    cterm = 1, ctermfg = 1, ctermbg = 1,
    gui = 1, guifg = 1, guibg = 1, guisp = 1,
    font = 1, blend = 1,
  }
}

local Highlight = { mt = {} }
local Hl = { mt = {} }

-- Instantiates a new Hl object assiociated with the given hl_group
function Hl.new(hl_group)
  local this = { group = hl_group, clear = Hl.clear }
  setmetatable(this, Hl.mt)

  return this
end

-- Deletes the highlight group assiociated with this Hl object
function Hl.clear(self)
  cmd(string.format('highlight clear %s', self.group))

  return true
end

-- Sets the highlight group assiociated with this Hl object
function Hl.set(self, n_opts)
  local len, hl_line = 0, 'highlight ' .. self.group

  for key, value in pairs(n_opts) do
    len = len + 1
    hl_line = hl_line .. Hl.attr2String(key, value)
  end

  if len == 0 then return nil end

  cmd(hl_line)

  return true
end

-- Normalizes the given highlight attributes into a format that can
-- be presented to ':highlight'
function Hl.normalize_attrs(_, raw)
  local gui, cterm = raw.gui or {}, raw.cterm or {}

  return {
    cterm   = Hl.attr_list('cterm', raw),
    ctermfg = cterm.fg or raw.ctermfg,
    ctermbg = cterm.bg or raw.ctermbg,
    gui     = Hl.attr_list('gui', raw),
    guifg   = gui.fg or raw.guifg or raw.fg,
    guibg   = gui.bg or raw.guibg or raw.bg,
    font    = gui.font or raw.font,
    blend   = gui.blend or raw.blend,
  }
end

-- Generates a list of non nil attribute items, merging the
-- attrset and attrset[subkey] attributes trees, with the latter
-- having prefrence
function Hl.attr_list(subkey, attrset)
  local list, sub = {}, attrset[subkey] or {}

  for option, _ in pairs(ATTR.ITEMS) do
    local resolved = sub[option] or attrset[option]

    if resolved ~= nil then table.insert(list, option) end
  end

  return #list > 0 and list or nil
end

-- Formats the given attr key,value pair into a string that can be
-- given to ':highlight'
function Hl.attr2String(name, value)
  if ATTR.KEYS[name] and #value > 0 then
    local v = value
    if type(v) == 'table' then
      v = table.concat(value, ',')
    end

    return string.format(' %s=%s', name, v)
  else
    return ''
  end
end

-- Sets the highlight group assiociated with this Hl object
function Hl.mt.__call(self, args)
  local n_opts = Hl.normalize_attrs(self, args)

  return Hl.set(self, n_opts)
end

-- Instantiates a new Highlight object
function Highlight.new()
  local this = { clear = Highlight.clear }
  setmetatable(this, Highlight.mt)

  return this
end

-- Sets the given highlight group(s)
function Highlight.set(args)
  local group = args[1] or args.group

  if type(group) == 'table' then
    local result = true
    for _, g in ipairs(group) do
      -- Failure is sticky, always record a failure if any group fails
      if not Hl.new(g):set(args) and result then result = false end
    end

    return result
  elseif type(group) == 'string' then
    return Hl.new(group):set(args)
  end
end

-- Clears the given highlight group.
--
-- Note this is closer to disabling the highlight group than it is to
-- resetting it to defaults
function Highlight.clear(group)
  if type(group) == 'table' then
    local result = true
    for _, g in ipairs(group) do
      -- Failure is sticky, always record a failure if any group fails
      if not Hl.new(g):clear() and result then result = false end
    end

    return result
  elseif type(group) == 'string' then
    return Hl.new(group):clear()
  end
end

-- Create a new Hl with the given name that can be called with a set
-- of highlight attrs to create / overwrite a highlight group
function Highlight.mt.__index(_, group)
  return Hl.new(group)
end

-- Create highlight group(s), taking either a list or single attrset
function Highlight.mt.__call(_, args)
  if args.group or type(args[1]) == 'string' then
    return Highlight.set(args)
  else
    for _, attrset in ipairs(args) do
      Highlight.set(attrset)
    end
  end
end

return Highlight.new()
