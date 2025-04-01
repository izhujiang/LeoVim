return {
  {
    -- a simple fast, lightweight file explorer
    "nvim-tree/nvim-tree.lua",
    enabled = vim.g.explorer == "nvim-tree", -- "neo-tree" or "nvim-tree"

    -- Lazy loading is not recommended. nvim-tree setup is very inexpensive,
    -- doing little more than validating and setting configuration.
    -- There's no performance benefit for lazy loading.
    -- Lazy loading can be problematic due to the somewhat nondeterministic
    -- startup order of plugins, session managers, netrw, "VimEnter" event etc.
    -- lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      {
        "<leader>ue",
        "<cmd>NvimTreeToggle<cr>",
        desc = "explorer",
      },
      {
        "<leader>uf",
        "<cmd>:NvimTreeFindFileToggle<cr>",
        desc = "explorer(%)",
      },
    },
    init = function()
      -- disable netrw at the very start of init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      -- optionally enable 24-bit colour
      vim.opt.termguicolors = true
    end,

    opts = {
      -- on_attach = "default",
      -- sync_root_with_cwd = true,
      -- respect_buf_cwd = true,
      -- update_focused_file = {
      --   enable = true,
      --   update_root = true,
      -- },
      -- sort = { sorter = "case_sensitive", },
      -- view = { width = 30, },
      -- renderer = { group_empty = true, },
      -- filters = { dotfiles = true, },
      diagnostics = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        debounce_delay = 50,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
      },
      modified = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      -- filesystem_watchers = {
      --   enable = true,
      --   ignore_dirs = {
      --     "/.ccls-cache",
      --     "/build",
      --     "/node_modules",
      --     "/target",
      --   },
      -- },
    },
  },

  {
    -- File Explorer (a feature-rich, customizable, and modern experience), manage the file system and other tree like structures.
    -- usage:
    --  :Neotree filesystem reveal right
    -- TODO: colorscheme should been applied before neo-tree setup.
    "nvim-neo-tree/neo-tree.nvim",
    enabled = vim.g.explorer == "neo-tree", -- "neo-tree" or "nvim-tree"
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
      { "MunifTanjim/nui.nvim" },
    },
    event = { "VimEnter" },
    cmd = "Neotree",
    keys = {
      {
        "<leader><leader>e",
        "<cmd>Neotree last toggle reveal<cr>",
        desc = "Explorer",
      },
      -- <leader>uf/ub/ug/ur maybe not need
      -- {
      --   "<leader><leader>f",
      --   function()
      --     require("neo-tree.command").execute({
      --       toggle = true,
      --       source = "filesystem",
      --       dir = require("leovim.utils").get_root(),
      --     })
      --   end,
      --   desc = "explorer(files)",
      -- },
      -- {
      --   "<leader><leader>b",
      --   function()
      --     require("neo-tree.command").execute({ source = "buffers", toggle = true })
      --   end,
      --   desc = "explorer(buffers)",
      -- },
      -- {
      --   "<leader><leader>g",
      --   function()
      --     -- require("neo-tree.command").execute({ position = "float", source = "git_status", toggle = true})
      --     require("neo-tree.command").execute({ position = "left", source = "git_status", toggle = true })
      --   end,
      --   desc = "explorer(git_status)",
      -- },
      -- {
      --   -- R for Reference
      --   "<leader><leader>r",
      --   function()
      --     require("neo-tree.command").execute({ position = "left", source = "document_symbols", toggle = true })
      --   end,
      --   desc = "outline",
      -- },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
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

    -- ref: neo-tree.nvim/lua/neo-tree/defaults.lua
    opts = function(_, opts)
      local icons = require("leovim.config.defaults").icons
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

    config = function(_, opts)
      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
}