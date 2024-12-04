return {
  {
    "nvim-tree/nvim-tree.lua",
    -- Lazy loading is not recommended. nvim-tree setup is very inexpensive,
    -- doing little more than validating and setting configuration.
    -- There's no performance benefit for lazy loading.
    -- Lazy loading can be problematic due to the somewhat nondeterministic
    -- startup order of plugins, session managers, netrw, "VimEnter" event etc.
    -- TODO: have not seen loading problems yet.  :Lazy profile to check performance.
    -- lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
    keys = {
      {
        "<M-e>",
        "<cmd>NvimTreeToggle<cr>",
        desc = "Explorer",
      },
    },
    init = function()
      -- disable netrw at the very start of init.lua
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,

    opts = {
      on_attach = "default",
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
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

  -- fuzzy finder: a highly extendable fuzzy finder over lists.
  -- Built on the latest awesome features from neovim core.

  -- TODO: fzf-lua as a replacement for telescope.nvim
  {
    "nvim-telescope/telescope.nvim",
    -- event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = "Telescope",
    opts = function()
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      local open_with_trouble = require("trouble.sources.telescope").open
      local Util = require("leovim.plugins.util")

      return {
        defaults = {
          -- prompt_prefix = " ",
          -- selection_caret = " ",
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              -- TODO: binds to trouble?
              ["<c-t>"] = open_with_trouble,
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
            },
            n = {
              ["q"] = actions.close,
              ["<c-t>"] = open_with_trouble,
            },
          },
          sorting_strategy = "ascending", -- display results top->bottom
          -- layout_strategy = "horizontal",
          -- layout_config = {
          --   anchor = "N",
          --   height = 0.9,
          --   width = 0.9,
          --   prompt_position = "top",
          --
          --   -- preview_width = 0.6,
          --   preview_cutoff = 80,
          -- },
        },
        pickers = {
          -- buffers = {
          --   hidden = true,
          --   enable_preview = false,
          --   layout_config = {
          --     preview_width = 0.6,
          --   },
          -- },
          -- git_files = {
          --   hidden = true,
          --   show_untracked = true,
          --   layout_config = {
          --     preview_width = 0.4,
          --   },
          -- },
        },
        extensions = {
          fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
          },
          -- ["ui-select"] = {
          --   require("telescope.themes").get_dropdown({})
          -- },
        },
      }
    end,
    keys = {
      { "<leader>s", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Fuzzy Find(Buffer)" },
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Files" }, -- shortcut for find_files
      { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>f/", "<cmd>Telescope search_history<cr>", desc = "Command History" },
      { "<leader>f'", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { '<leader>f"', "<cmd>Telescope registers<cr>", desc = "Registers" },
      { "<leader>fa", "<cmd>Telescope autocommands<cr>", desc = "Autocommands" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>fC", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
      -- diagnostics
      { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Diagnostics(Buffer)" },
      { "<leader>fD", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics(Workspace)" },
      -- 'e' for expression
      -- Search for a string in your current working directory and get results live as you type,
      { "<leader>fe", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
      -- git
      { "<leader>fgb", "<cmd>Telescope git_branches<cr>", desc = "Git Branches" },
      { "<leader>fgc", "<cmd>Telescope git_commits<cr>", desc = "Git Commits" },
      { "<leader>fgC", "<cmd>Telescope git_bcommits<cr>", desc = "Git Commits(Buffer)" },
      { "<leader>fgf", "<cmd>Telescope git_files<cr>", desc = "Git Files" },
      { "<leader>fgs", "<cmd>Telescope git_status<cr>", desc = "Git Status" },
      { "<leader>fgS", "<cmd>Telescope git_stash<cr>", desc = "Git stash" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fH", "<cmd>Telescope highlights<cr>", desc = "Highlight Groups" },
      { "<leader>fj", "<cmd>Telescope jumplist<cr>", desc = "Jumplist" },
      { "<leader>fk", "<cmd>Telescope keymaps<cr>", desc = "Keybindings" },
      -- lsp group
      { "<leader>flc", "<cmd>Telescope lsp_incoming_calls<cr>", desc = "Incoming Calls" },
      { "<leader>flC", "<cmd>Telescope lsp_outgoing_calls<cr>", desc = "Outgoing Calls" },
      { "<leader>fld", "<cmd>Telescope lsp_definitions<cr>", desc = "Definitions" },
      { "<leader>fle", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>fli", "<cmd>Telescope lsp_implementations<cr>", desc = "Implementations" },
      { "<leader>flr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "<leader>fls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Symbols(Document)" },
      { "<leader>flS", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Symbols(Workspace)" },
      { "<leader>flt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Type Definitions" },
      { "<leader>flw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Symbols(Dynamic)" },
      { "<leader>fm", "<cmd>Telescope marks<cr>", desc = "Marks" },
      { "<leader>fM", "<cmd>Telescope man_pages<cr>", desc = "Man pages" },
      { "<leader>fn", "<cmd>Telescope notify<cr>", desc = "Notifications" },
      { "<leader>fo", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      { "<leader>fq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix" },
      { "<leader>fQ", "<cmd>Telescope loclist<cr>", desc = "Loclist" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
      { "<leader>fs", "<cmd>Telescope spell_suggest<cr>", desc = "Spelling Suggestion" },
      -- For Intra-File Navigation: Yes, Tree-sitter can replace tags within a single file.
      -- Its real-time parsing is very useful for jumping to definitions, functions, or classes within a file.
      { "<leader>ft", "<cmd>Telescope treesitter<cr>", desc = "Treesitter" },
      -- { "<leader>ft",  "<cmd>Telescope current_buffer_tags,           desc = "Tags (buffer)" },
      -- Cross-file navigation: Use tags or a language server for fast, project-wide symbol indexing and jumping to definitions
      { "<leader>fT", "<cmd>Telescope tags<cr>", desc = "Tags(CWD)" },
      -- Searches for the string under your cursor or selection in your current working directory
      { "<leader>fw", "<cmd>Telescope grep_string<cr>", desc = "Grep String" },
      { "<leader>fx", "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Search" },
      { "<leader>fz", "<cmd>Telescope resume<cr>", desc = "Last Find" },
      { "<leader>fZ", "<cmd>Telescope pickers<cr>", desc = "Last Picker" },
    },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)

      -- To get fzf loaded and working with telescope, call load_extension after setup function:
      telescope.load_extension("fzf")
      telescope.load_extension("notify")
      -- telescope.load_extension("ui-select")
    end,
  },
  {
    -- FZF sorter for telescope,
    -- fzf-native is a c port of fzf, means that the fzf syntax is supported.
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make", -- use gcc or clang and make (another option, cmake)
  },
  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy", -- project.nvim load project history list asynchronously, make it ready before call :Telescope projects command
    keys = {
      { "<leader>fp", "<cmd>Telescope projects<cr>", desc = "Projects" },
    },
    opts = {
      -- detection_methods = { "lsp", "pattern" }, -- NOTE: lsp detection will
      -- get annoying with multiple langs in one project
      detection_methods = { "pattern" },
      patterns = { ".git", "Makefile", "package.json", "go.mod" },
    },
    config = function(_, opts)
      require("project_nvim").setup(opts)

      require("telescope").load_extension("projects")
    end,
  },

  -- trouble.nvim (like tree), enhanced Quickfix, better diagnostics list and others
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the troubles.
  -- usage:
  --  :Trouble [mode] [action] [options]
  -- 		-- document_diagnostics| workspace_diagnostics| lsp_references | lsp_definitions | lsp_type_definitions | quickfix | loclist
  {
    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "Trouble",
    },
    keys = {
      {
        "<leader>td",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Document Diagnostics(Trouble)",
      },
      {
        "<leader>tD",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Workspace Diagnostics(Trouble)",
      },
      {
        "<leader>tl",
        "<cmd>Trouble lsp toggle<cr>",
        desc = "LSP(Trouble)",
      },
      {
        "<leader>tr",
        "<cmd>Trouble lsp_references toggle<cr>",
        desc = "References(Trouble)",
      },
      {
        "<leader>tq",
        "<cmd>Trouble quickfix toggle<cr>",
        desc = "Quickfix(Trouble)",
      },
      {
        "[q",
        function()
          local t = require("trouble")
          if t.is_open() then
            t.prev({ skip_groups = true, jump = true })
          else
            vim.cmd.cprevious()
          end
        end,
        desc = "Previous Trouble/Quickfix",
      },
      {
        "]q",
        function()
          local t = require("trouble")
          if t.is_open() then
            t.next({ skip_groups = true, jump = true })
          else
            vim.cmd.cnext()
          end
        end,
        desc = "Next Trouble/Quickfix",
      },
      {
        "[Q",
        function()
          local t = require("trouble")
          if t.is_open() then
            t.first({ skip_groups = true, jump = true })
          else
            vim.cmd.cfirst()
          end
        end,
        desc = "First Trouble/Quickfix",
      },
      {
        "]Q",
        function()
          local t = require("trouble")
          if t.is_open() then
            t.last({ skip_groups = true, jump = true })
          else
            vim.cmd.clast()
          end
        end,
        desc = "Last Trouble/Quickfix",
      },
    },
    opts = {
      modes = {
        lsp = {
          win = { position = "right" },
        },
      },
    },
  },

  -- References highlighting
  -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  -- <a-n>/]r and <a-p>/[r, move between references
  -- :Illuminate{Pause, Resume, Toggle, PauseBuf, ResumeBuf, ToggleBuf,}
  {
    "RRethy/vim-illuminate",
    event = { "VeryLazy" },
    keys = {
      {
        "<M-r>",
        function()
          require("illuminate").toggle_buf()
        end,
        desc = "Toggle Illuminate(Buffer)",
      },
      {
        "<M-R>",
        function()
          require("illuminate").toggle()
        end,
        desc = "Toggle Illuminate",
      },
      {
        "]r",
        function()
          require("illuminate").goto_next_reference(false)
        end,
        desc = "Next Reference(Illuminate)",
      },
      {
        "[r",
        function()
          require("illuminate").goto_prev_reference()
        end,
        desc = "Previous Reference(Illuminate)",
      },
    },
    opts = {
      -- providers = { "lsp", "treesitter", "regex" },
      delay = 120,
      large_file_cutoff = 2000,
      -- filetype_overrides = {},
      -- large_file_overrides = {},

      filetypes_denylist = require("leovim.config.defaults").non_essential_filetypes,
      under_cursor = true,
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Smart and powerful comment plugin
  -- Supports treesitter, dot repeat, left-right/up-down motions, hooks,
  -- usage:
  --    gc, linewise comment
  --    gb, blockwise comment
  --    gcc, gbc
  --    gco, gcO, gcA
  {
    "numToStr/Comment.nvim",
    keys = { { "gc", mode = { "n", "v" } }, { "gb", mode = { "n", "v" } } },
    opts = {
      ignore = "^$", -- ignore blank line

      pre_hook = function(...)
        local loaded, ts_comment = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
        if loaded and ts_comment then
          return ts_comment.create_pre_hook()(...)
        end
      end,

      post_hook = nil,
    },
  },

  -- todo comments
  -- Highlight, list and search todo comments  in your projects
  -- usage: ("-" stand for todolist)
  -- -- :TodoTrouble, :TodoTelescope, :TodoQuickfix, :TodoLocList,
  -- -- <leader>f-/F-, <leader>t-/T-
  -- -- ]-/[-
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "VeryLazy" },
    cmd = { "TodoTrouble", "TodoTelescope" },
    opts = {
      -- BUG: opts must be non-null.
      --
      --   keywords = {
      --     FIX = {
      --       icon = " ", -- icon used for the sign, and in search results
      --       color = "error", -- can be a hex color, or a named color (see below)
      --       alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
      --       -- signs = false, -- configure signs for some keywords individually
      --     },
      --     TODO = { icon = " ", color = "info" },
      --     HACK = { icon = " ", color = "warning" },
      --     WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
      --     PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
      --     NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
      --     TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      --   },
    },
    keys = {
      {
        "]-",
        function()
          require("todo-comments").jump_next()
        end,
        desc = "Next Todo",
      },
      {
        "[-",
        function()
          require("todo-comments").jump_prev()
        end,
        desc = "Previous Todo",
      },
      {
        "<leader>t-",
        "<cmd>TodoTrouble<cr>",
        desc = "Todo(Trouble)",
      },
      {
        "<leader>f-",
        "<cmd>TodoTelescope<cr>",
        desc = "Todo(Telescope)",
      },
    },
  },

  -- neovim plugin to help easily manage multiple terminal windows: persist and
  -- toggle multiple terminals during an editing session
  {
    "akinsho/toggleterm.nvim",
    keys = {
      {
        "<M-1>",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal(Horizontal)",
      },
      {
        "<M-2>",
        "<cmd>ToggleTerm direction=vertical<cr>",
        -- "<cmd>ToggleTerm =vertical<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal(Vertical)",
      },
      {
        "<M-3>",
        "<cmd>ToggleTerm direction=float<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal(Float)",
      },
      {
        "<M-\\>",
        "<cmd>ToggleTerm direction=float<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal(Float)",
      },
    },
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
      open_mapping = [[<M-\>]],
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
    -- config = function(_, opts)
    --   local status_ok, toggleterm = pcall(require, "toggleterm")
    --   if not status_ok then
    --     return
    --   end
    --   toggleterm.setup(opts)

    -- local Terminal = require("toggleterm.terminal").Terminal
    -- local lazygit = Terminal:new({
    --   cmd = "lazygit",
    --   hidden = true,

    --   direction = "float",
    --   float_opts = {
    --     border = "none",
    --     width = 100000,
    --     height = 100000,
    --   },
    --   on_open = function(_)
    --     vim.cmd("startinsert!")
    --   end,
    --   on_close = function(_) end,
    --   count = 99,
    -- })

    -- function _LAZYGIT_TOGGLE()
    --   lazygit:toggle()
    -- end

    -- local node = Terminal:new({ cmd = "node", hidden = true })
    -- function _NODE_TOGGLE()
    --   node:toggle()
    -- end

    -- local python = Terminal:new({ cmd = "python3", hidden = true })
    -- function _PYTHON_TOGGLE()
    --   python:toggle()
    -- end
    -- end,
  },

  -- dashboard, alpha is a fast and fully programmable greeter
  -- TODO: popup and greeter when start up nvim without oponning any file
  {
    "goolord/alpha-nvim",
    cmd = { "Alpha" },
    keys = { { "<leader>;", "<cmd>Alpha<cr>", desc = "Dashboard" } },
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local logo = [[
            ██╗     ███████    ████═╗  ██╗   ██╗██╗███╗   ███╗          Z
            ██║     ██╚══╗    ██  ██║  ██║   ██║██║████╗ ████║      Z
            ██║     ██████╗  ██╚╗  ██╗ ██║   ██║██║██╔████╔██║   z
            ██║     ██╚═══╝   ██╚═██╔╝ ╚██╗ ██╔╝██║██║╚██╔╝██║ z
            ███████╗███████╗  ╚████╔╝   ╚████╔╝ ██║██║ ╚═╝ ██║
            ╚══════╝╚══════╝   ╚═══╝     ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
      local icons = require("leovim.config.defaults").icons

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("p", string.format("%s%s", icons.dashboard.Project, "Projects"), ":Telescope projects<CR>"),
        dashboard.button(
          "n",
          string.format("%s%s", icons.dashboard.NewFile, "New file"),
          ":ene <BAR> startinsert <CR>"
        ),
        dashboard.button(
          "r",
          string.format("%s%s", icons.dashboard.RecentFiles, "Recent files"),
          ":Telescope oldfiles <CR>"
        ),
        dashboard.button(
          "f",
          string.format("%s%s", icons.dashboard.FindFile, "Find file"),
          ":Telescope find_files <CR>"
        ),
        dashboard.button(
          "g",
          string.format("%s%s", icons.dashboard.FindText, "Find text"),
          ":Telescope live_grep <CR>"
        ),
        dashboard.button(
          "s",
          string.format("%s%s", icons.dashboard.FindText, "Restore Session"),
          [[:lua require("persistence").load() <cr>]]
        ),
        dashboard.button("l", string.format("%s%s", icons.dashboard.Lazy, "Lazy"), ":Lazy<CR>"),
        dashboard.button("q", string.format("%s%s", icons.dashboard.Quit, "Quit"), ":qa<CR>"),
      }
      dashboard.section.footer.val = "m.zhujiang@gmail.com\nPowered by lazy.nvim"

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end

      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LeoVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}