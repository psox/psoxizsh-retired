
local M = { mt = {} }
local Groups = {}
local Group = { mt = {} }
local AutoCmd = { mt = {} }

local __builtin_support = vim.fn.has('nvim-0.7') == 1

-- Use the recent builtin APIs provided by neovim itself
local function builtin(group, autos)
  vim.api.nvim_create_augroup(group, {})

  for _, auto in ipairs(autos) do
    local opts = auto.opts or {}
    opts.group = group
    opts.pattern = auto.pattern

    if type(auto.command) == "string" then
      opts.command = auto.command
    elseif type(auto.command) == "function" then
      opts.callback = auto.command
    end

    vim.api.nvim_create_autocmd(auto.event, opts)
  end
end

-- Use an old library to make the autos
-- Note that relies on the local package manager to ensure this plugin is available
local function polyfill(group, autos)
  local poly = require 'autocmd-lua'
  local autocmds = {}

  for _, auto in ipairs(autos) do
    local events = auto.event

    if type(auto.event) == "string" then
      events = { auto.event }
    end

    for _, e in ipairs(events) do
      table.insert(autocmds, { event = e, pattern = auto.pattern, cmd = auto.command })
    end
  end

  poly.augroup {
    group = group,
    autocmds = autocmds,
  }
end

local autocmd = __builtin_support and builtin or polyfill

function M.new()
  local m = {}
  setmetatable(m, M.mt)

  return m
end

function M.mt.__index(_, group)
  if Groups[group] ~= nil then
    return Groups[group]
  else
    -- Create a group object that uses the autocmd function on being called.
    -- This object should take the list of objects provided to it, insert
    -- them into it's local storage and then execute autocmd on them
    return Group.new(group)
  end
end

-- Spawn a new Group with the given name
function Group.new(name)
  local g = { __name = name, __autos = {} }
  setmetatable(g, Group.mt)
  Groups[name] = g

  return g
end

-- Insert a new auto command object spec into the provided Group's list
function Group.insert(self, cmd)
  if not cmd.disable then
    table.insert(self.__autos, {
      command = table.remove(cmd, 3),
      pattern = table.remove(cmd, 2),
      event = table.remove(cmd, 1),
      opts = cmd
    })
  end
end

-- Spawn a new AutoCmd with the given event name, currying the parent group's name
function Group.mt.__index(self, event)
  return AutoCmd.new(self, event)
end

-- Allows module users to pass a Group a list of auto command parameters
function Group.mt.__call(self, command_like)
  if type(command_like) == "function" then
    command_like(self)
  elseif type(command_like) == "table" then
    for _, auto in ipairs(command_like) do
      Group.insert(self, auto)
    end
  end

  autocmd(self.__name, self.__autos)
end

-- Create a new dummy object that stores its group and event
-- Used to allow for currying of autocmd parameters
function AutoCmd.new(group, event)
  local a = { __group = group, __event = event }
  setmetatable(a, AutoCmd.mt)

  return a
end

-- Add the given partial arg list passed to this AutoCmd to the correct group
function AutoCmd.mt.__call(self, args)
  table.insert(args, 1, self.__event)
  Group.insert(self.__group, args)
end

return M.new()
