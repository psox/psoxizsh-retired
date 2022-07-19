
return function()
  local g = vim.g

  -- Don't force qf/loc windows to bottom
  g.qf_window_bottom = 0
  g.qf_loclist_window_bottom = 0

  -- Let Neomake control window size
  g.qf_auto_resize = 0
end
