
local M = {}

---@class BindOptions
---@field noremap  boolean          Defaults to true
---@field silent   boolean          Defaults to true
---@field mode     'n'|'i'|'v'|'c'  Mode of the bind, n=Normal, i=Insert, etc
---@field prefix   string|nil       A prefix that is appended to the bind key (for example: '<Leader>')
---@field skip     boolean|nil      Should this bind be skipped silently when `Bind.register/2` is called?

--- A key bind.
---
--- Each Bind object represents a single key binding that can be registered with Neovim.
---@class Bind
---
---@field __struct  "BindKey"             Class identifier
---@field label     string|nil            Description of the keybind
---@field key       string|nil            Key that will be bound -- though this may be modified by `self.opts.prefix`
---@field action    string|function|nil   Action to bind to `self.key`. May be a string, which will be interpreted as vimscript or a lua function
---@field opts      BindOptions
---@field new       fun(self: Bind, opts: BindOptions?): Bind       Create a new key bind
---@field update    fun(self: Bind, updates: BindOptions?): Bind    Update this Bind with new options
---@field register  fun(self: Bind, ephemeral: BindOptions?): nil   Register this Bind with Neovim
---
---@operator call(BindOptions):Bind See `Bind.update/2`
local Bind = {
  opts = { noremap = true, silent = true, mode = 'n', prefix = nil },
  __struct = 'BindKey',
}
setmetatable(Bind, {
  __call = function(self, opts) return self:update(opts) end
})

--- A group of key Binds.
---
--- Groups are inherently composable, and any group may add a sub group simply
--- by indexing the parent object. Groups created in such a way will automatically
--- inherit parent options, and add them to any Binds created on that Group.
---
---@class BindGroup
---@field __struct    "BindGroup"                                           Class identifier
---@field __children  table<string, BindGroup|Bind>                         Subgroups and/or Binds that are direct children of this BindGroup
---@field __opts      BindOptions                                           Options to apply to child BindGroup/Binds
---@field new         fun(self: BindGroup, opts: BindOptions?): BindGroup   Create a new BindGroup
---@field options     fun(self: BindGroup, opts: BindOptions?): BindGroup   Update this BindGroup with the provided opts
---@field register    fun(self: BindGroup, ephemeral: BindOptions?): nil    Recursively register all child Binds
---@operator call(table<string, Bind|BindGroup|BindOptions>?): BindGroup
local Group = {
  __children = {},
  __opts = {},
  __struct = 'BindGroup',
}
setmetatable(Group, {
  ---Group.__index meta method
  ---@param self BindGroup
  ---@param name string
  ---@return BindGroup
  __index = function(self, name)
    if not self.__children[name] then
      self:child(name, self:new())
    end

    return self.__children[name]
  end,

  ---Group.__call meta method
  ---@param self BindGroup
  ---@param new table<string, Bind|BindGroup|BindOptions>
  ---@return BindGroup
  __call = function(self, new)
    local opts = new[1] and new[1] or {}
    new[1] = nil
    self.__opts = vim.tbl_extend('force', self.__opts, new[1] or {})

    for name, entry in pairs(new) do
      if entry.__struct == 'BindGroup' then
        self:child(name, entry:options(opts, 'force'))
      elseif entry.__struct == 'BindKey' then
        self:child(name, entry:update(opts, 'force'))
      else
        self:child(name, Bind:new(opts):update(entry))
      end
    end

    return self
  end,
})

--- Create a new Group, inheriting the options from `self`
---@param self BindGroup
---@param opts BindOptions?
---@return BindGroup
function Group.new(self, opts)
  local this = vim.tbl_extend('force',
    vim.deepcopy(Group), { __opts = self.__opts  }
  )

  setmetatable(this, getmetatable(Group))

  return this:options(opts)
end

--- Update this Group with the provided `opts`
---@param self BindGroup
---@param opts BindOptions?
---@param mode nil|'force'|'keep'
---@return BindGroup
function Group.options(self, opts, mode)
  self.opts = vim.tbl_extend(mode or 'keep', opts or {}, self.__opts)

  return self
end

---Register all Binds below this Group, recursively iterating through any subgroups
---
--- Note that any options passed to this function *will not be persisted to the respective
--- Binds, and will only effect this register/2 call.
---@param self BindGroup
---@param ephemeral BindOptions?
---@return nil
function Group.register(self, ephemeral)
  for _, entry in pairs(self.__children) do
    local type = entry.__struct
    if type and (type == 'BindKey' or type == 'BindGroup') then
      entry:register(ephemeral)
    end
  end
end

--- [PRIVATE] Add a child to this Group, returning the child
---@param self BindGroup
---@param name string
---@param group Bind|BindGroup
---@return Bind|BindGroup
function Group.child(self, name, group)
  self.__children[name] = group

  return self.__children[name]
end

--- Create a new Bind, merging `self` and `opts` options
---@param self Bind
---@param opts BindOptions?
---@return Bind
function Bind.new(self, opts)
  local this = vim.tbl_extend('force',
    vim.deepcopy(Bind), { opts = self.opts }
  )
  setmetatable(this, getmetatable(Bind))

  return this:update(opts)
end

--- Update this Bind with the provided updates
---
--- Note that this function modifies the given updates table, *consuming values*
---@param self Bind
---@param updates BindOptions?
---@param mode 'force'|'keep'|nil
---@return Bind
function Bind.update(self, updates, mode)
    local u = updates or {}
    if u.key then self.key = u.key u.key = nil end
    if u.label then self.label = u.label u.label = nil end
    if u.action then self.action = u.action u.action = nil end

    self.opts = vim.tbl_extend(mode or 'keep', u, self.opts)

    return self
end

--- Register this Bind with Neovim.
---
--- This function may be passed an ephemeral set of BindOptions, which are not
--- persisted but do apply to the registered bind
---
--- Calling this function may fail (though not raise) unless one of the following
--- is true:
---
--- 1. (key and action) =~ nil
--- 2. opts.skip == true
---@param self Bind
---@param ephemeral BindOptions
---@return Bind
function Bind.register(self, ephemeral)
  self:do_register(ephemeral)

  return self
end

--- [PRIVATE] Make arg map to pass to nvim api
---@param self Bind
---@param ephemeral BindOptions
---@return string|nil
---@return string|nil
---@return string|function|nil
---@return table<string, any>|nil
function Bind.make_keymap_args(self, ephemeral)
  local key = self.key
  local action, cmd = self.action, type(self.action) == 'string'
  local opts =  vim.tbl_extend('force',
    vim.deepcopy(self.opts),
    { desc = self.label },
    ephemeral or {}
  )
  local mode = opts.mode
  opts.mode = nil

  opts.skip = nil

  if cmd and action:lower():sub(1, #'<plug>') == '<plug>' then
    opts.noremap = false
  end

  if opts.prefix and #opts.prefix > 0 then
    key = opts.prefix .. key
  end
  opts.prefix = nil

  return mode, key, action, opts
end

--- [PRIVATE] Internal handler for registering key binds with Neovim
---@param self Bind
---@param ephemeral BindOptions
---@return nil
function Bind.do_register(self, ephemeral)
  if self.opts.skip then return end

  local mode, lhs, rhs, opts = self:make_keymap_args(ephemeral)

  if not (mode and lhs and rhs) then
    self:log(vim.log.levels.WARN, mode, lhs, rhs, opts.desc)
    return
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

--- [PRIVATE] Log failures
---@param self Bind
---@param level any
---@param mode any
---@param lhs any
---@param rhs any
---@param label any
---@return nil
function Bind.log(self, level, mode, lhs, rhs, label)
  local msg, fo = { 'Skipping keymap, invalid args!' }, { newline = '', indent = ' ' }

  table.insert(msg, 'mode: ' .. vim.inspect(mode, fo))
  table.insert(msg, 'label: ' .. vim.inspect(label, fo))
  table.insert(msg, 'key: ' .. vim.inspect(lhs, fo))
  table.insert(msg, 'action: ' .. vim.inspect(rhs, fo))

  vim.notify(table.concat(msg, "\n"), level, { title = self.__struct })
end

--- Convenience wrapper around `Bind.new/2`, allowing callers to use
--- array like syntax for setting `Bind.{label,key,action}` options.
---
--- Examples:
---
--- -- Say hello when pressing 'p' in normal mode
--- MkBind { 'Description of this bind', 'p', 'echo Hello, World!' }
---
--- -- Create a insert mode bind of <Leader><C-q> to save and quit
--- MkBind { 'Fast Quit', '<C-q>', 'w | quitall', prefix = '<Leader>', mode = 'i', expr = true }
---
---@param opts { [1]: BindOptions.label?, [2]: BindOptions.key?, [3]: BindOptions.action? } | BindOptions
---@return Bind
local function mkbind(opts)
  if opts[1] then opts.label = opts[1] opts[1] = nil end
  if opts[2] then opts.key = opts[2] opts[2] = nil end
  if opts[3] then opts.action = opts[3] opts[3] = nil end

  return Bind:new(opts)
end

M.Bind = Bind:new()
M.Group = Group:new()
M.MkBind = mkbind

return M
