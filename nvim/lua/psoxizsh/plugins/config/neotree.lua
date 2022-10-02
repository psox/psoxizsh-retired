return function()
  local g = vim.g
  local neotree, util = require 'neo-tree', require 'psoxizsh.util'
  local keys = require 'psoxizsh.key.map'
  local Super = keys.Global.N.Super.FileBrowser

  local defaults = {
    close_if_last_window = true,
    enable_git_status = true,
    default_component_configs = {
      container = {
        enable_character_fade = true
      },
      indent = {
        indent_size = 2,
        padding = 1, -- extra padding on left hand side
        -- indent guides
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",
        -- expander config, needed for nesting files
        with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "ﰊ",
        -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
        -- then these will never be used.
        default = "*",
        highlight = "NeoTreeFileIcon"
      },
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          -- Change type
          added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
          modified  = "~", -- or "", but this is redundant info if you use git_status_colors on the name
          deleted   = "✖",-- this can only be used in the git_status source
          renamed   = "",-- this can only be used in the git_status source
          -- Status type
          untracked = "",
          ignored   = "",
          unstaged  = "",
          staged    = "",
          conflict  = "",
        },
      },
    },
    window = {
      position = "left",
      width = 40,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["?"]       = "show_help",
        ["q"]       = "close_window",
        [Super.key] = "close_window",
        ["R"]       = "refresh",
        ["<space>"] = {  "toggle_node", nowait = false },
        ["<cr>"]    = "open",
        ["S"]       = "open_split",
        ["s"]       = "open_vsplit",
        ["C"]       = "close_node",
        ["z"]       = "close_all_nodes",
        ["Z"]       = "expand_all_nodes",
        ["X"]       = "delete",
        ["r"]       = "rename",
        ["a"]       = { "add", config = { show_path = "relative" } },
        ["A"]       = { "add_directory", config = { show_path = "relative" } },
        ["c"]       = { "copy", config = { show_path = "relative" } },
        ["m"]       = { "move", config = { show_path = "relative" } },
        ["y"]       = "copy_to_clipboard",
        ["p"]       = "paste_from_clipboard",
      },
    },
    filesystem = {
      filtered_items = {
        visible = false, -- when true, they will just be displayed differently than normal items
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- only works on Windows for hidden files/directories
        hide_by_name = { --[[ Example: 'node_modules' ]] },
        hide_by_pattern = { --[[ Example '*.meta' ]] },
        never_show = { --[[ remains hidden even if visible is toggled to true ]] },
      },
      follow_current_file = true, -- This will find and focus the file in the active buffer every
                                   -- time the current file is changed while the tree is open.
      group_empty_dirs = false, -- when true, empty folders will be grouped together
      hijack_netrw_behavior = "open_default",  -- netrw disabled, opening a directory opens neo-tree
                                               -- in whatever position is specified in window.position
                            -- "open_current", -- netrw disabled, opening a directory opens within the
                                               -- window like netrw would, regardless of window.position
                            -- "disabled",     -- netrw left alone, neo-tree does not handle opening dirs
      use_libuv_file_watcher = true,  -- This will use the OS level file watchers to detect changes
                                      -- instead of relying on nvim autocmd events.
      window = {
        mappings = {
          ["<bs>"]  = "navigate_up",
          ["."]     = "set_root",
          ["H"]     = "toggle_hidden",
          ["/"]     = "fuzzy_finder",
          ["D"]     = "fuzzy_finder_directory",
          ["f"]     = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"]    = "prev_git_modified",
          ["]g"]    = "next_git_modified",
        },
      },
    },
    buffers = {
      follow_current_file = true, -- This will find and focus the file in the active buffer every
                                  -- time the current file is changed while the tree is open.
      group_empty_dirs = true,    -- when true, empty folders will be grouped together
      show_unloaded = true,
      window = {
        mappings = {
          ["X"]     = "buffer_delete",
          ["<bs>"]  = "navigate_up",
          ["."]     = "set_root",
        },
      },
    },
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },
  }

  g['neo_tree_remove_legacy_commands'] = 1

  neotree.setup(util.mconfig('config.neotree', defaults))
end
