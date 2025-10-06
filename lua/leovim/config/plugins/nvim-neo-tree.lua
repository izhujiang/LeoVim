return {
  keys = {
    {
      "<A-e>",
      "<cmd>Neotree last toggle<cr>",
      -- "<cmd>Neotree last toggle reveal<cr>",
      desc = "Explorer",
    },
  },
  -- ref: neo-tree.nvim/lua/neo-tree/defaults.lua
  opts = function(_, opts)
    local icons = require("leovim.config.icons")
    opts = vim.tbl_deep_extend("force", opts or {}, {
      -- add_blank_line_at_top = true,
      close_if_last_window = true,
      popup_border_style = "rounded",
      -- enable_git_status = false,
      enable_diagnostics = false,
      log_level = "error",
      sources = {
        "filesystem",
        "buffers",
        "git_status",
        "document_symbols",
      },
      default_component_configs = {
        diagnostics = {
          symbols = {
            hint = icons.diagnostics.Hint,
            info = icons.diagnostics.Info,
            warn = icons.diagnostics.Warn,
            error = icons.diagnostics.Error,
          },
          highlights = {
            hint = "DiagnosticSignHint",
            info = "DiagnosticSignInfo",
            warn = "DiagnosticSignWarn",
            error = "DiagnosticSignError",
          },
        },
        -- only valid in default_component_configs part
        git_status = {
          symbols = {
            -- Change type
            added = icons.git.LineAdded,
            modified = icons.git.LineModified,
            deleted = icons.git.LineRemoved,
            renamed = icons.git.FileRenamed,
            -- Status type
            untracked = icons.git.FileUntracked,
            ignored = icons.git.FileIgnored,
            unstaged = icons.git.FileUnstaged,
            staged = icons.git.FileStaged,
            conflict = icons.git.Conflict,
          },
        },
      },
      window = {
        mappings = {
          ["f"] = function()
            vim.api.nvim_exec2("Neotree focus filesystem left", { output = true })
          end,
          ["b"] = function()
            vim.api.nvim_exec2("Neotree focus buffers left", { output = true })
          end,
          ["g"] = function()
            vim.api.nvim_exec2("Neotree focus git_status left", { output = true })
          end,
          ["s"] = function()
            vim.api.nvim_exec2("Neotree focus document_symbols  left", { output = true })
          end,
        },
      },

      filesystem = {
        filtered_items = {
          visible = true, -- when true, they will just be displayed differently than normal items
          hide_dotfiles = false,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = {
            "node_modules",
          },
          --     hide_by_pattern = { -- uses glob style patterns
          --       --"*.meta",
          --       --"*/src/*/tsconfig.json",
          --     },
          --     always_show = { -- remains visible even if other settings would normally hide it
          --       ".gitignored",
          --     },
          never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
            ".DS_Store",
            "thumbs.db",
            ".git",
          },
          --     never_show_by_pattern = { -- uses glob style patterns
          --       --".null-ls_*",
          --     },
        },
        window = {
          fuzzy_finder_mappings = {
            --     window in fuzzy_finder_mode
            ["<C-j>"] = "move_cursor_down",
            ["<C-k>"] = "move_cursor_up",
          },
        },
      }, -- end of filesystem

      buffers = {
        show_unloaded = true,
      },

      git_status = {
        window = {
          mappings = {
            ["gg"] = "none",
            ["gP"] = "git_commit_and_push",
          },
        },
      }, -- end of git_status

      -- document_symbols = {
      --   kinds = {
      --     File = { icon = icons.kinds.File, hl = "Tag" },
      --     Namespace = { icon = icons.kinds.Namespace, hl = "Include" },
      --     Package = { icon = icons.kinds.Package, hl = "Label" },
      --     Class = { icon = icons.kinds.Class, hl = "Include" },
      --     Property = { icon = icons.kinds.Property, hl = "@property" },
      --     Enum = { icon = icons.kinds.Enum, hl = "@number" },
      --     Function = { icon = icons.kinds.Function, hl = "Function" },
      --     String = { icon = icons.kinds.String, hl = "String" },
      --     Number = { icon = icons.kinds.Number, hl = "Number" },
      --     -- Array = { icon = "󰅪", hl = "Array" },
      --     Array = { icon = icons.kinds.Array, hl = "Array" },
      --     Object = { icon = icons.kinds.Object, hl = "Type" },
      --     Key = { icon = icons.kinds.Key, hl = "" },
      --     Struct = { icon = icons.kinds.Struct, hl = "Type" },
      --     Operator = { icon = icons.kinds.Operator, hl = "Operator" },
      --     TypeParameter = { icon = icons.kinds.TypeParameter, hl = "Type" },
      --     StaticMethod = { icon = icons.kinds.StaticMethod, hl = "Function" },
      --   },
      -- },

      -- winbar used by source_selector conflict with lualine
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = "filesystem" },
          { source = "buffers" },
          { source = "document_symbols" },
          { source = "git_status" },
        },
        show_separator_on_edge = false, -- boolean
      },
      -- event_handlers = {
      --   {
      --     event = "neo_tree_window_before_open",
      --     handler = function(args)
      --       vim.notify("neo_tree_window_before_open", vim.inspect(args))
      --     end,
      --   },
      --   {
      --     event = "neo_tree_window_after_close",
      --     handler = function(args)
      --       -- disable lualine winbar
      --       vim.notify("neo_tree_window_after_close", vim.inspect(args))
      --     end,
      --   },
      -- },
    })

    return opts
  end,

  init = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    if vim.fn.argc() == 1 then
      local path = tostring(vim.fn.argv(0))
      local stat = vim.uv.fs_stat(path)
      if stat and stat.type == "directory" then
        require("neo-tree")
      end
    end
  end,
}
