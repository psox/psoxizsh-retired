return function()
  local g, fn = vim.g, vim.fn

  -- Don't move cursor into qf/loc on open
  g.neomake_open_list = 2
  -- Allow multiple makers to resolve
  g.neomake_serialize = 1
  g.neomake_serialize_abort_on_error = 1

  -- Let Neomake control window size
  g.qf_auto_resize = 0

  fn['neomake#configure#automake']('rw', 800)
end
