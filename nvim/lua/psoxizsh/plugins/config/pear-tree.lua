return function()
  local g = vim.g

  -- Balance pairs when on open, close and delete
  g.pear_tree_smart_openers = 1
  g.pear_tree_smart_closers = 1
  g.pear_tree_smart_backspace = 1
  g.pear_tree_ft_disabled = { 'TelescopePrompt' }
end
