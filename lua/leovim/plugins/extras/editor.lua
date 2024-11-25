return {

  -- File Explorer, Neovim plugin to manage the file system and other tree like
  -- structures.
  --:Neotree filesystem reveal right
  -- BUG: colorscheme has been applied before neo-tree.
  {
    "nvim-neo-tree/neo-tree.nvim",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" }, -- not strictly required, but recommended
      { "MunifTanjim/nui.nvim" },
    },
    event = { "VimEnter" },
    cmd = "Neotree",
    keys = {
      {
        "<leader>EE",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("leovim.plugins.util").get_root() })
        end,
        desc = "Files(root)",
      },
      {
        "<leader>EC",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Files(cwd)",
      },
      {
        "<leader>EB",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffers",
      },
      {
        "<leader>EG",
        function()
          -- require("neo-tree.command").execute({ position = "float", source = "git_status", toggle = true})
          require("neo-tree.command").execute({ position = "left", source = "git_status", toggle = true })
        end,
        desc = "Git_status",
      },
      {
        -- R for Reference
        "<leader>ES",
        function()
          require("neo-tree.command").execute({ position = "left", source = "document_symbols", toggle = true })
        end,
        desc = "Symbols(document))",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local path = tostring(vim.fn.argv(0))
        local stat = vim.loop.fs_stat(path)
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    -- ref: neo-tree.nvim/lua/neo-tree/defaults.lua
    opts = function()
      local icons = require("leovim.config.defaults").icons
      return {
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
          "document_symbols"
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
          }
        },
        window = {
          mappings = {
            ['F'] = function() vim.api.nvim_exec2('Neotree focus filesystem left', { output = true }) end,
            ['B'] = function() vim.api.nvim_exec2('Neotree focus buffers left', { output = true }) end,
            ['G'] = function() vim.api.nvim_exec2('Neotree focus git_status left', { output = true }) end,
            ['S'] = function() vim.api.nvim_exec2('Neotree focus document_symbols  left', { output = true }) end,
          },
        },

        filesystem = {
          --   -- TODO: filter hidden items
          filtered_items = {
            -- visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            -- hide_gitignored = true,
            -- hide_hidden = true,
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
        event_handlers = {
          {
            event = "neo_tree_window_before_open",
            handler = function(args)
              -- TODO: disable lualine winbar
              vim.notify("TODO: neo_tree_window_before_open", vim.inspect(args))
            end
          },
          {
            event = "neo_tree_window_after_close",
            handler = function(args)
              -- TODO: disable lualine winbar
              vim.notify("TODO: neo_tree_window_after_close", vim.inspect(args))
            end
          },
        }
      }
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

  --	A search and research tool, PANEL for neovim.
  -- search/replace in multiple files
  -- buf filetype: spectre
  -- Use command: :Spectre or <leader>as, <leader>ss, <leader>sw
  -- local commands:
  -- dd, <cr>, <leader>Q, <leader>l, <leader>R, <leader>rc, <leader>c, <leader>uu/uv/ui/uo/uh
  -- Warnings: Always commit your files before you replace text. nvim-spectre does not support undo directly.
  -- TODO: config nvim-spectre's panel
  {
    "nvim-pack/nvim-spectre",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
    },
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
      live_update = true,
      is_insert_mode = true,
      mapping = {
        ["send_to_qf"] = {
          map = "<leader>Q",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix",
        },
        ["show_option_menu"] = {
          map = "uo",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show options",
        },
        ["toggle_live_update"] = {
          map = "uu",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "update when vim writes to file",
        },
        ["change_view_mode"] = {
          map = "uv",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode",
        },
        ["toggle_ignore_case"] = {
          map = "ui",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "toggle ignore case",
        },
        ["toggle_ignore_hidden"] = {
          map = "uh",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "toggle search hidden",
        },
        ["change_replace_sed"] = {
          map = "us",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace",
        },
        ["change_replace_oxi"] = {
          map = "ux",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace",
        },
      },
    },
    keys = {
      {
        "<leader>RR",
        function()
          require("spectre").toggle()
        end,
        "n",
        desc = "Toggle Spectre",
      },
      {
        "<leader>RW",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        "n",
        desc = "Replace",
      },
      {
        "<leader>RW",
        function()
          require("spectre").open_visual({})
        end,
        "v",
        desc = "Replace",
      },
      {
        "<leader>RC",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        "n",
        desc = "Replace (current)",
      },
    },
  },
  {
    -- enhanced increment/decrement plugin for Neovim.
    -- Increment/decrement based on various type of rules
    -- n-ary (2 <= n <= 36) integers
    -- date and time
    -- constants (an ordered set of specific strings, such as a keyword or operator)
    -- true ⇄ false
    -- && ⇄ ||
    -- a ⇄ b ⇄ ... ⇄ z
    -- hex colors
    -- semantic version
    --
    -- TODO: <C-a> <C-x> not working appropriately
    "monaqa/dial.nvim",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local augend = require("dial.augend")
      require("dial.config").augends:register_group({
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%d/%m/%Y"],
          augend.date.alias["%Y-%m-%d"],
          augend.constant.alias.bool,
          augend.constant.alias.Alpha,
        },
        typescript = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.constant.new({ elements = { "let", "const" } }),
        },
        visual = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.alpha,
          augend.constant.alias.Alpha,
        },
      })

      vim.keymap.set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
      vim.keymap.set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })
      vim.keymap.set("v", "<C-a>", require("dial.map").inc_visual("visual"), { noremap = true })
      vim.keymap.set("v", "<C-x>", require("dial.map").dec_visual("visual"), { noremap = true })

      -- enable only for specific FileType
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("leovim_" .. "typescript", { clear = true }),
        pattern = { "javascript", "typescript" },
        callback = function()
          vim.api.nvim_buf_set_keymap(0, "n", "<C-a>", require("dial.map").inc_normal("typescript"), { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-x>", require("dial.map").dec_normal("typescript"), { noremap = true })
        end,
      })
    end,
  },
  -- fugitive.vim: A Git wrapper. (fugitive.vim vs lazygit)
  --  fugitive.vim: command-line git in vim,
  --  lazygit: a simple terminal UI for git commands running in shell or via terminal
  {
    "tpope/vim-fugitive",
    enabled = false,
    cmd = {
      "G",
      "Git",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
      "GBrowse",
      "GRemove",
      "GRename",
      "Glgrep",
      "Gedit",
    },
  },
}