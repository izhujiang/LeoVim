local Util = require("leovim.util")

return {

  -- file explorer, Neovim plugin to manage the file system and other tree like structures.
  --:Neotree filesystem reveal right
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      {
        "<leader>ee",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("leovim.util").get_root() })
        end,
        desc = "Files(root)",
      },
      {
        "<leader>ec",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Files(cwd)",
      },
      {
        "<leader>eb",
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        desc = "Buffers",
      },
      {
        "<leader>eg",
        function()
          -- require("neo-tree.command").execute({ position = "float", source = "git_status", toggle = true})
          require("neo-tree.command").execute({ position = "left", source = "git_status", toggle = true })
        end,
        desc = "Git_status",
      },
      {
        -- R for Reference
        "<leader>es",
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
        -- local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    -- TODO: config icons from leovim.config
    opts = function()
      local icons = require("leovim.config").icons
      return {

        close_if_last_window = false,
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        -- add_blank_line_at_top = true,
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },

        default_component_configs = {
          container = {
            enable_character_fade = true,
          },
          indent = {
            with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = icons.folder.Closed,
            folder_open = icons.folder.Open,
            folder_empty = icons.folder.Empty,

            -- The next two settings are only a fallback,
            -- TODO: find out other icon more meaningful
            default = " ", -- for unknown filetype
            highlight = "NeoTreeFileIcon",
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          -- name = {
          -- 	trailing_slash = false,
          -- 	use_git_status_colors = true,
          -- 	highlight = "NeoTreeFileName",
          -- },
          buffers = {
            follow_current_file = {
              enabled = true,
            }, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
            group_empty_dirs = false,
            show_unloaded = true,
            window = {
              mappings = {
                ["bd"] = "buffer_delete",
                ["<bs>"] = "navigate_up",
                ["."] = "set_root",
              },
            },
          },
          git_status = {
            symbols = {
              -- Change type
              added = icons.git.LineAdded, -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified = icons.git.LineModified, -- or "", but this is redundant info if you use git_status_colors on the name
              deleted = icons.git.LineRemoved, -- this can only be used in the git_status source
              renamed = icons.git.FileRenamed, -- this can only be used in the git_status source
              -- Status type
              untracked = icons.git.FileUntracked,
              ignored = icons.git.FileIgnored,
              unstaged = icons.git.FileUnstaged,
              staged = icons.git.FileStaged,
              conflict = icons.git.Conflict,
            },
          },
        }, -- end of default_component_configs

        filesystem = {
          bind_to_cwd = true,
          follow_current_file = {
            enabled = true,
          }, -- find and focus the file in the active buffer every time the current file is changed while the tree is open.
          use_libuv_file_watcher = true, -- use_the_OS_level_file_watchers_to_detect_changes
          group_empty_dirs = false,

          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
          -- TODO: filter hidden items
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              "node_modules",
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta",
              --"*/src/*/tsconfig.json",
            },
            always_show = { -- remains visible even if other settings would normally hide it
              ".gitignored",
            },
            never_show = { -- remains hidden even if visible is toggled to true, this overrides always_show
              ".DS_Store",
              "thumbs.db",
              ".git",
            },
            never_show_by_pattern = { -- uses glob style patterns
              --".null-ls_*",
            },
          },
          window = {
            mappings = {
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["#"] = "fuzzy_sorter", -- fuzzy sorting using the fzy algorithm
              -- ["D"] = "fuzzy_sorter_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
            },
            fuzzy_finder_mappings = { -- define keymaps for filter popup window in fuzzy_finder_mode
              ["<C-j>"] = "move_cursor_down",
              ["<C-k>"] = "move_cursor_up",
            },
          },
        }, -- end of filesystem

        buffers = {
          follow_current_file = {
            enabled = true, -- This will find and focus the file in the active buffer every
          },
          show_unloaded = false,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            },
          },
        }, -- end of buffers
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"] = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            },
          },
        },
        document_symbols = {
          kinds = {
            File = { icon = icons.kinds.File, hl = "Tag" },
            Namespace = { icon = icons.kinds.Namespace, hl = "Include" },
            Package = { icon = icons.kinds.Package, hl = "Label" },
            Class = { icon = icons.kinds.Class, hl = "Include" },
            Property = { icon = icons.kinds.Property, hl = "@property" },
            Enum = { icon = icons.kinds.Enum, hl = "@number" },
            Function = { icon = icons.kinds.Function, hl = "Function" },
            String = { icon = icons.kinds.String, hl = "String" },
            Number = { icon = icons.kinds.Number, hl = "Number" },
            -- Array = { icon = "󰅪", hl = "Array" },
            Array = { icon = icons.kinds.Array, hl = "Array" },
            Object = { icon = icons.kinds.Object, hl = "Type" },
            Key = { icon = icons.kinds.Key, hl = "" },
            Struct = { icon = icons.kinds.Struct, hl = "Type" },
            Operator = { icon = icons.kinds.Operator, hl = "Operator" },
            TypeParameter = { icon = icons.kinds.TypeParameter, hl = "Type" },
            StaticMethod = { icon = icons.kinds.StaticMethod, hl = "Function" },
          },
        },
        source_selector = {
          winbar = true,
          statusline = false,
          sources = {
            { source = "filesystem", display_name = " " .. icons.kinds.Files .. "Files " },
            -- { source = "buffers", display_name = "󰌗 Buffers" },
            { source = "document_symbols", display_name = " " .. icons.kinds.Symbols .. "Symbols " },
            { source = "git_status", display_name = " " .. icons.kinds.Git .. "Git " },
          },
        },
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

  -- fuzzy finder: telescope.nvim, a highly extendable fuzzy finder over lists.
  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy", -- triggered after LazyDone and processing VimEnter auto commands.
    -- make sure that extensions are loaded in config function before Telescope commands are invoked via shortcuts
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
      { "rcarriga/nvim-notify" },
      -- { "folke/trouble.nvim" },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "ahmedkhalf/project.nvim",
      },
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      return {
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,

              ["<c-t>"] = function(...)
                local trouble = require("trouble.providers.telescope")
                return trouble.open_with_trouble(...)
              end,
              ["<a-t>"] = function(...)
                local trouble = require("trouble.providers.telescope")
                return trouble.open_selected_with_trouble(...)
              end,
              ["<a-i>"] = function()
                local line = action_state.get_current_line()
                Util.telescope("find_files", { no_ignore = true, default_text = line })()
              end,
              ["<a-h>"] = function()
                local line = action_state.get_current_line()
                Util.telescope("find_files", { hidden = true, default_text = line })()
              end,
              ["<C-Down>"] = function(...)
                return actions.cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                return actions.cycle_history_prev(...)
              end,
              ["<C-f>"] = function(...)
                return actions.preview_scrolling_down(...)
              end,
              ["<C-b>"] = function(...)
                return actions.preview_scrolling_up(...)
              end,
              ["<c-d>"] = actions.delete_buffer + actions.move_to_top,
              ["<esc>"] = actions.close,
            },
            n = {
              ["q"] = actions.close,
            },
          },
          sorting_strategy = "ascending", -- display results top->bottom

          layout_strategy = "horizontal",
          layout_config = {
            anchor = "N",
            height = 0.9,
            width = 0.9,
            prompt_position = "top",

            -- preview_width = 0.6,
            preview_cutoff = 80,
          },
        },
        pickers = {
          autocommands = {
            layout_config = {
              preview_width = 0.5,
            },
          },
          buffers = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          colorscheme = {
            enable_preview = true,
            layout_config = {
              preview_width = 0.6,
            },
          },
          current_buffer_fuzzy_find = {
            layout_config = {
              preview_width = 0.5,
            },
          },
          diagnostics = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          find_files = {
            hidden = true,
            layout_config = {
              preview_width = 0.6,
            },
          },
          git_files = {
            hidden = true,
            show_untracked = true,
            layout_config = {
              preview_width = 0.6,
            },
          },
          git_branches = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          git_commit = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          git_status = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          grep_string = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          help_tags = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          live_grep = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          lsp_document_symbols = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          lsp_workspace_symbols = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          marks = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          man_pages = {
            layout_config = {
              preview_width = 0.6,
            },
          },
          oldfiles = {
            layout_config = {
              preview_width = 0.5,
            },
          },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
        },
      }
    end,
    keys = function()
      local symbols = {
        "Class",
        "Function",
        "Method",
        "Constructor",
        "Interface",
        "Module",
        "Struct",
        "Trait",
        "Field",
        "Property",
      }
      return {
        { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy find(buf)" },
        { "<leader>:", "<cmd>Telescope commands<cr>", desc = "Commands" },
        { "<leader>'", "<cmd>Telescope marks<cr>", desc = "Marks" },
        { '<leader>"', "<cmd>Telescope registers<cr>", desc = "Registers" },
        { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
        { "<leader>fB", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
        { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "commands" },
        { "<leader>fC", "<cmd>Telescope command_history<cr>", desc = "Command history" },
        {
          "<leader>fd",
          Util.telescope("diagnostics", { bufnr = 0 }),
          desc = "Diagnostics(document)",
        },
        {
          "<leader>fD",
          "<cmd>Telescope diagnostics<cr>",
          desc = "Diagnostics(workspace)",
        },
        { "<leader>ff", Util.telescope("files"), desc = "Files(root)" },
        { "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Files(cwd)" },
        { "<leader>fg", "<cmd>Telescope git_status<cr>", desc = "Git status" },
        { "<leader>fG", "<cmd>Telescope git_commits<cr>", desc = "Git commits" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help pages" },
        { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keybindings" },
        { "<leader>fl", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>s", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
        { "<leader>fL", "<cmd>Telescope resume<cr>", desc = "Last find" },
        { "<leader>fm", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
        -- { "<leader>fp", telescope.extensions.projects.projects,                         desc = "Projects" },
        { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
        { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
        { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
        {
          "<leader>fs",
          Util.telescope("lsp_document_symbols", { symbols = symbols }),
          desc = "Goto symbol(document)",
        },
        {
          "<leader>fS",
          Util.telescope("lsp_workspace_symbols", { symbols = symbols }),
          desc = "Goto symbol(workspace)",
        },
        { "<leader>fw", Util.telescope("grep_string", { cwd = false }), desc = "Grep string" },
        { "<leader>oo", "<cmd>Telescope vim_options<cr>", desc = "Vim options" },
        { "<leader>pc", Util.telescope("colorscheme", { enable_preview = true }), desc = "Colorscheme" },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- To get fzf loaded and working with telescope, you need to call load_extension, somewhere after setup function:
      telescope.load_extension("fzf")
      telescope.load_extension("notify")
      telescope.load_extension("projects")
    end,
  },

  -- Navigate your code with search labels, enhanced character motions and Treesitter integration
  {
    "folke/flash.nvim",
    opts = {
      modes = {
        search = {
          enabled = false, -- disable: integrate flash.nvim with your regular search using / or ?
        },
      },
    },
    keys = {
      -- TODO: confix with nvim-surround in operator-pending mode
      -- { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end,       desc = "Flash jump" },
      -- { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      {
        "s",
        mode = { "n", "x" },
        function()
          require("flash").jump()
        end,
        desc = "Flash jump",
      },
      {
        "S",
        mode = { "n", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash treesitter",
      },
      -- {
      --   "r",
      --   mode = { "o", "x" },
      --   function() require("flash").treesitter_search() end,
      --   desc =
      --   "Treesitter search"
      -- },
      -- { "r", mode = { "o" },           function() require("flash").remote() end,     desc = "Remote Flash" },
      -- {
      --   "<c-s>",
      --   mode = { "c" },
      --   function() require("flash").toggle() end,
      --   desc =
      --   "Toggle Flash Search"
      -- },
    },
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
        "<leader>as",
        function()
          require("spectre").toggle()
        end,
        "n",
        desc = "Spectre(Replace)",
      },
      {
        "<leader>rw",
        function()
          require("spectre").open_visual({ select_word = true })
        end,
        "n",
        desc = "Replace current word",
      },
      {
        "<leader>rw",
        "<esc><cmd>lua require('spectre').open_visual()<CR>",
        "v",
        desc = "Replace current word",
      },
      {
        "<leader>rW",
        function()
          require("spectre").open_file_search({ select_word = true })
        end,
        "n",
        desc = "Replace in current file",
      },
    },
  },

  -- trouble.nvim, enhanced Quickfix, better diagnostics list and others
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the troubles.
  -- usage:
  -- 		:Trouble {mode}						-- document_diagnostics| workspace_diagnostics| lsp_references | lsp_definitions | lsp_type_definitions | quickfix | loclist
  -- 		:TroubleToggle {mode}
  {
    "folke/trouble.nvim",
    opts = function()
      local trouble = require("trouble.providers.telescope")
      return {
        -- mode = "workspace_diagnostics", 					-- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
        -- auto_open = true, -- automatically open the list when you have diagnostics
        --                   -- when press U in Lazy UI, the window will lose focus because of auto_open trouble
        auto_close = true, -- automatically close the list when you have no diagnostics
        defaults = {
          mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
          },
        },
      }
    end,

    cmd = {
      "Trouble",
      "TroubleToggle",
    },
    keys = {
      { "<leader>at", "<cmd>TroubleToggle<cr>", desc = "Trouble" },
      { "<leader>td", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document diagnostics(Trouble)" },
      { "<leader>tD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace diagnostics(Trouble)" },
      { "<leader>tr", "<cmd>TroubleToggle lsp_references<cr>", desc = "References(Trouble)" },
      { "<leader>tq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix(Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
      {
        "[Q",
        function()
          if require("trouble").is_open() then
            require("trouble").first({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cfirst)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "First trouble/quickfix item",
      },
      {
        "]Q",
        function()
          if require("trouble").is_open() then
            require("trouble").last({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.clast)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Last trouble/quickfix item",
      },
    },
  },

  -- git signs, Git integration for Buffers
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Next hunk" })

        map("n", "[c", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return "<Ignore>"
        end, { expr = true, desc = "Previous hunk" })

        map("n", "<leader>gj", gs.next_hunk, { desc = "Next hunk" })
        map("n", "<leader>gk", gs.prev_hunk, { desc = "Previous hunk" })

        map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage hunk" })
        map("v", "<leader>gs", function()
          gs.stage_hunk(vim.fn.line("v"), { vim.fn.line(".") })
        end, { desc = "Stage hunk" })
        map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage buffer" })
        map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
        map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset hunk" })
        map("v", "<leader>gr", function()
          gs.reset_hunk({ vim.fn.line("v"), vim.fn.line(".") })
        end, { desc = "Reset hunk" })
        map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset buffer" })

        map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview hunk" })
        map("n", "<leader>gl", function()
          gs.blame_line({ full = true })
        end, { desc = "Blame line" })
        map("n", "<leader>gd", gs.diffthis, { desc = "Diff this" }) -- diff again the index
        map("n", "<leader>gD", function()
          gs.diffthis("~")
        end, { desc = "Diff this ~" }) -- diff again last commit

        map("n", "<leader>go", "<cmd>Telescope git_status<cr>", { desc = "Open changed file" })
        map("n", "<leader>gb", "<cmd>Telescope git_branches<cr>", { desc = "Checkout branch" })
        map("n", "<leader>gc", "<cmd>Telescope git_commits<cr>", { desc = "Checkout commit" })
        map("n", "<leader>gC", "<cmd>Telescope git_bcommits<cr>", { desc = "Checkout commit (for current file)" })

        map("n", "<leader>oD", gs.toggle_deleted, { desc = "GitSigns deleted" })
        map("n", "<leader>oL", gs.toggle_current_line_blame, { desc = "GitSigns blameline" })

        -- Text object
        map({ "o", "x" }, "ih", gs.select_hunk, { desc = "GitSigns select hunk" })

        map("n", "<leader>gU", function()
          vim.cmd.nohlsearch()
          vim.cmd.diffupdate()
        end, { desc = "Diff update" })
      end,
    },
  },

  -- references
  -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  -- <a-n>/]r and <a-p>/[r, move between references
  -- :Illuminate{Pause, Resume, Toggle, PauseBuf, ResumeBuf, ToggleBuf,}
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      providers = { "lsp", "treesitter", "regex" },
      delay = 120,
      large_file_cutoff = 2000,
      -- filetype_overrides = {},
      -- large_file_overrides = {},

      filetypes_denylist = {
        "dirvish",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "neogitstatus",
        "Trouble",
        "lir",
        "Outline",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },

      -- filetypes_allowlist = {},
      -- modes_denylist = {},
      -- modes_allowlist = {},
      -- providers_regex_syntax_denylist = {},
      -- providers_regex_syntax_allowlist = {},

      under_cursor = true,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
    keys = {
      {
        "]r",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next reference",
      },
      {
        "[r",
        function()
          require("illuminate").goto_prev_reference()
        end,
        desc = "Previous reference",
      },
    },
  },

  -- todo comments
  -- Highlight, list and search todo comments  in your projects
  -- keywords: TODO, HACK, WARN, PERF, NOTE, TEST, and FIX ...
  -- usage: ("-" stand for todolist)
  -- -- :TodoTrouble, :TodoTelescope, :TodoQuickfix, :TodoLocList,
  -- -- <leader>f-/F-, <leader>t-/T-
  -- -- ]-/[-
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    -- opts = {
    -- TODO: Add more keywords
    -- keywords = {
    -- 	FIX = {
    -- 		icon = " ", -- icon used for the sign, and in search results
    -- 		color = "error", -- can be a hex color, or a named color (see below)
    -- 		alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
    -- 		-- signs = false, -- configure signs for some keywords individually
    -- 	},
    -- 	TODO = { icon = " ", color = "info" },
    -- 	HACK = { icon = " ", color = "warning" },
    -- 	WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    -- 	PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    -- 	NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    -- 	TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    -- },
    -- 	-- merge_keywords = true, -- when true, custom keywords will be merged with the defaults
    -- },
    keys = {
      {
        "]-",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next todo",
      },
      {
        "[-",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous todo",
      },
      {
        "<leader>t-",
        "<cmd>TodoTrouble<cr>",
        desc = "Todolist(Trouble)",
      },
      {
        "<leader>t+",
        "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>",
        desc = "Todolist(TODO/FIX/FIXME)",
      },
      {
        "<leader>f-",
        "<cmd>TodoTelescope<cr>",
        desc = "Todolist",
      },
      {
        "<leader>f+",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
        desc = "Todolist(TODO/FIX/FIXME)",
      },
    },
    config = function()
      require("todo-comments").setup()
    end,
  },

  -- which-key
  -- displays a popup with possible key bindings of the command you started typing.
  -- and built-in plugins: marks, registers, presets(built-in key binding help for motions, text-objects, operators, windows, nav, z and g) and spelling suggestions.
  --
  -- usage:
  --  to triggger text-objects:         i and a
  --  to triggger operators:            c, d, y, ~, g~, !, =, gq,
  --  to triggger motions:              b, w, j, f, /, ? g
  --
  -- 	to trigger marks:                 ' and `
  --  to trigger register:              " in normal mode and <C-r> in insert mode
  --  to trigger spelling suggestions: 	z=
  --  to trigger window commands:		    <c-w>
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 800
    end,

    opts = {
      -- triggers = "auto", -- automatically setup triggers
      -- triggers = {"<leader>"} -- or specify a list manually
      triggers_nowait = {}, -- disable triggers_nowait
      -- {
      --   -- marks
      --   "`",
      --   "'",
      --   "g`",
      --   "g'",
      --   -- registers
      --   '"',
      --   "<c-r>",
      --   -- spelling
      --   "z=",
      -- },

      -- plugins = {
      -- 	spelling = true,
      -- },

      -- triggers_blacklist = {
      -- 	-- list of mode / prefixes that should never be hooked by WhichKey
      -- 	-- this is mostly relevant for keymaps that start with a native binding
      -- 	i = { "j", "k" },
      -- 	v = { "j", "k" },
      -- },

      -- -- disable the WhichKey popup for certain buf types and file types.
      -- -- Disabled by default for Telescope
      disable = {
        buftypes = {
          "help",
          "quickfix",
          "terminal",
          "prompt",
        },
        filetypes = require("leovim.config").non_essential_filetypes,
      },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+Goto" },
        ["]"] = { name = "+Next" },
        ["["] = { name = "+Prev" },
        ["<leader>a"] = { name = "+Alternate" },
        ["<leader>c"] = { name = "+Code" },
        ["<leader>d"] = { name = "+Diagnostics/Debug" },
        ["<leader>e"] = { name = "+Explore" },
        ["<leader>f"] = { name = "+Fuzzy_find" },
        ["<leader>g"] = { name = "+Git" },
        ["<leader>h"] = { name = "+Hunks" },
        ["<leader>I"] = { name = "+Info" },
        ["<leader>l"] = { name = "+LSP" },
        ["<leader>o"] = { name = "+Options" },
        ["<leader>p"] = { name = "+Pick" },
        ["<leader>r"] = { name = "+Replace" },
        ["<leader>t"] = { name = "+Trouble/Test" },
      },
    },
    config = function(_, opts)
      -- wk.register can be called multiple times from anywhere in your config files.
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)
    end,
  },

  -- project management
  -- TODO: failed to change cwd, nvim restore cwd after a project is selected from Telescope projects
  {
    "ahmedkhalf/project.nvim",
    opts = {
      -- Methods of detecting the root directory. **"lsp"** uses the native neovim lsp, while **"pattern"** uses vim-rooter like glob pattern matching.
      -- Here order matters: if one is not detected, the other is used as fallback.
      detection_methods = { "lsp", "pattern" },

      -- All the patterns used to detect root dir, when **"pattern"** is in detection_methods
      patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },

      -- Table of lsp clients to ignore by name
      -- eg: { "efm", ... }
      ignore_lsp = {},

      -- Don't calculate root dir on specific directories
      -- Ex: { "~/.cargo/*", ... }
      exclude_dirs = {},

      -- Show hidden files in telescope
      show_hidden = false,

      -- When set to false, you will get a message when project.nvim changes your
      -- directory.
      silent_chdir = true,

      -- What scope to change the directory, valid options are
      -- * global (default)
      -- * tab
      -- * win
      scope_chdir = "global",

      -- Path where project.nvim will store the project history for use in
      -- telescope
      datapath = vim.fn.stdpath("data"),
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)
    end,
  },

  -- neovim plugin to help easily manage multiple terminal windows: persist and toggle multiple terminals during an editing session
  {
    "akinsho/toggleterm.nvim",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.o.lines * 0.4
        elseif term.direction == "vertical" then
          return vim.o.columns * 0.4
        else
          return 0
        end
      end,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true, -- open_mapping = [[<c-\>]], is also applied in insert and terminal mode
      terminal_mappings = true,
      persist_size = true,
      persist_mode = true,
      direction = "float",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    },
    keys = {
      {
        "<leader>gg",
        -- "<cmd>ToggleTerm cmd=lazygit<cr>",
        "<cmd>lua _LAZYGIT_TOGGLE()<cr>",
        desc = "Lazygit",
      },
      {
        "<C-1>",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (horizontal)",
      },
      {
        "<C-2>",
        "<cmd>ToggleTerm direction=vertical<cr>",
        -- "<cmd>ToggleTerm =vertical<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (vertical)",
      },
      {
        "<C-3>",
        "<cmd>ToggleTerm direction=float<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (float)",
      },
    },
    config = function(_, opts)
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
        return
      end
      toggleterm.setup(opts)

      -- _G.set_terminal_keymaps = function()
      --   vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], { noremap = true })
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], { noremap = true })
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true })
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true })
      --   vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true })
      -- end
      --
      -- vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,

        direction = "float",
        float_opts = {
          border = "none",
          width = 100000,
          height = 100000,
        },
        on_open = function(_)
          vim.cmd("startinsert!")
        end,
        on_close = function(_) end,
        count = 99,
      })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      -- local node = Terminal:new({ cmd = "node", hidden = true })
      -- function _NODE_TOGGLE()
      --   node:toggle()
      -- end

      -- local python = Terminal:new({ cmd = "python3", hidden = true })
      -- function _PYTHON_TOGGLE()
      --   python:toggle()
      -- end
    end,
  },
}