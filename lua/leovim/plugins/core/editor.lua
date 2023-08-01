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
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = require("leovim.util").get_root() })
        end,
        desc = "Explorer NeoTree (root dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
      -- {
      -- 	"<leader>B",
      -- 	function()
      -- 		require("neo-tree.command").execute({ source = "buffers", toggle = true })
      -- 	end,
      -- 	desc = "Explorer NeoTree (buffers)",
      -- },
      {
        "<leader>G",
        function()
          -- require("neo-tree.command").execute({ position = "float", source = "git_status", toggle = true})
          require("neo-tree.command").execute({ position = "left", source = "git_status", toggle = true })
        end,
        desc = "Explorer NeoTree (git_status)",
      },
      {
        -- R for Reference
        "<leader>R",
        function()
          require("neo-tree.command").execute({ position = "left", source = "document_symbols", toggle = true })
        end,
        desc = "Explorer NeoTree (document_symbols)",
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
      if vim.fn.argc() == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == "directory" then
          require("neo-tree")
        end
      end
    end,

    opts = {
      close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      -- add_blank_line_at_top = true,
      sources = { "filesystem", "buffers", "git_status", "document_symbols" },
      open_files_do_not_replace_types = { "terminal", "Trouble", "qf", "Outline" },

      default_component_configs = {
        container = {
          enable_character_fade = true
        },
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = "",
          expander_expanded = "",
          expander_highlight = "NeoTreeExpander",
        },
        icon = {
          folder_closed = "",
          folder_open = "",
          folder_empty = "󰜌",

          -- The next two settings are only a fallback,
          -- TODO: find out other icon more meaningful
          default = " ", -- for unknown filetype
          highlight = "NeoTreeFileIcon"
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
          follow_current_file = true, -- This will find and focus the file in the active buffer every time the current file is changed while the tree is open.
          group_empty_dirs = false,
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            }
          },
        },
        git_status = {
          symbols = {
            -- Change type
            added     = "+", -- or "✚", but this is redundant info if you use git_status_colors on the name
            modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
            deleted   = "x", -- this can only be used in the git_status source
            renamed   = "󰁕", -- this can only be used in the git_status source
            -- Status type
            untracked = "?",
            ignored   = "",
            unstaged  = "󰄱",
            staged    = "",
            conflict  = "",
          },
        },
      }, -- end of default_component_configs

      filesystem = {
        bind_to_cwd = false,
        follow_current_file = false,   -- find and focus the file in the active buffer every time the current file is changed while the tree is open.
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
            "node_modules"
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
            ".git"
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
          }
        }
      }, -- end of filesystem

      buffers = {
        follow_current_file = true, -- This will find and focus the file in the active buffer every
        show_unloaded = true,
        window = {
          mappings = {
            ["bd"] = "buffer_delete",
            ["<bs>"] = "navigate_up",
            ["."] = "set_root",
          }
        }
      }, -- end of buffers
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
          }
        }
      },
      document_symbols = {
        kinds = {
          File = { icon = "󰈙", hl = "Tag" },
          Namespace = { icon = "󰌗", hl = "Include" },
          Package = { icon = "󰏖", hl = "Label" },
          Class = { icon = "󰌗", hl = "Include" },
          Property = { icon = "󰆧", hl = "@property" },
          Enum = { icon = "󰒻", hl = "@number" },
          Function = { icon = "󰊕", hl = "Function" },
          String = { icon = "󰀬", hl = "String" },
          Number = { icon = "󰎠", hl = "Number" },
          Array = { icon = "󰅪", hl = "Type" },
          Object = { icon = "󰅩", hl = "Type" },
          Key = { icon = "󰌋", hl = "" },
          Struct = { icon = "󰌗", hl = "Type" },
          Operator = { icon = "󰆕", hl = "Operator" },
          TypeParameter = { icon = "󰊄", hl = "Type" },
          StaticMethod = { icon = '󰠄 ', hl = 'Function' },
        }
      },
      source_selector = {
        winbar = true,
        statusline = false,
        sources = {
          { source = "filesystem", display_name = " 󰉓 Files " },
          -- { source = "buffers", display_name = "󰌗 Buffers" },
          { source = "document_symbols", display_name = " 󰀬 Symbols " },
          { source = "git_status", display_name = " 󰊢 Git " },
        },
      },
    },

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

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-tree/nvim-web-devicons" },
      {
        "folke/trouble.nvim",
        event = "VeryLazy"
      },
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        event = "VeryLazy"
      },
    },
    -- cmd = "Telescope",
    -- version = false, -- telescope did only one release, so use HEAD for now
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

              -- ["<c-t>"] = function(...)
              -- 	return trouble.open_with_trouble(...)
              -- end,
              -- ["<a-t>"] = function(...)
              -- 	return trouble.open_selected_with_trouble(...)
              -- end,
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
          layout_strategy = 'horizontal',
          layout_config = {
            anchor = "N",
            height = 0.8,
            prompt_position = "top",
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
          }
        }
      }
    end,

    config = function(_, opts)
      local telescope = require("telescope")
      -- local trouble = require("trouble.providers.telescope")
      telescope.setup(opts)
      -- To get fzf loaded and working with telescope, you need to call load_extension, somewhere after setup function:
      telescope.load_extension('fzf')

      local builtin = require('telescope.builtin')

      vim.keymap.set('n', "<leader>`", Util.telescope("buffers", { show_all_buffers = true }),
        { desc = "Switch Buffer" })
      vim.keymap.set('n', "<leader>/", builtin.current_buffer_fuzzy_find, { desc = "Grep (root dir)" })
      vim.keymap.set('n', "<leader>\\", Util.telescope("live_grep", {}), { desc = "Find in current buffer" })
      vim.keymap.set('n', "<leader>:", builtin.command_history, { desc = "Command History" })

      vim.keymap.set('n', '<leader>fa', builtin.autocommands, { desc = "Autocommands" })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Buffers" })
      vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Commands" })
      vim.keymap.set('n', '<leader>fC', builtin.command_history, { desc = "Command History" })
      vim.keymap.set('n', '<leader>ff', Util.telescope("files"), { desc = "Find Files (root dir)" })
      vim.keymap.set('n', '<leader>fF', Util.telescope("files", { cwd = false }), { desc = "Find Files (cwd)" })
      vim.keymap.set('n', '<leader>fg', builtin.git_commits, { desc = "Git Commits" })
      vim.keymap.set('n', '<leader>fG', builtin.git_status, { desc = "Git Status" })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Help Pages" })
      vim.keymap.set('n', '<leader>fH', builtin.highlights, { desc = "Search Highlight Groups" })
      vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Key Maps" })
      vim.keymap.set('n', '<leader>fl', Util.telescope("live_grep", { cwd = false }), { desc = "Grep (cwd)" })
      vim.keymap.set('n', '<leader>fL', Util.telescope("live_grep", { cwd = true }), { desc = "Grep (root dir)" })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = "Jump to Marks" })
      vim.keymap.set('n', '<leader>fM', builtin.man_pages, { desc = "Man Pages" })
      vim.keymap.set('n', '<leader>fo', builtin.vim_options, { desc = "Options" })
      vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = "Quickfix" })
      vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "Recent" })
      vim.keymap.set('n', '<leader>fR', builtin.resume, { desc = "Resume" })
      vim.keymap.set('n', '<leader>fw', Util.telescope("grep_string", { cwd = false }), { desc = "Word (cwd)" })
      vim.keymap.set('n', '<leader>fW', Util.telescope("grep_string", { cwd = true }), { desc = "Word (cwd)" })

      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "Workspace Diagnostics" })
      vim.keymap.set('n', '<leader>fD', Util.telescope("diagnostics", { bufnr = 0 }), { desc = "Document Diagnostics" })

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
      vim.keymap.set('n', '<leader>fs', Util.telescope("lsp_document_symbols", { symbols = symbols }),
        { desc = "Goto Symbol" })
      vim.keymap.set('n', '<leader>fS', Util.telescope("lsp_dynamic_workspace_symbols", { symbols = symbols }),
        { desc = "Goto Symbol (Workspace)" })
    end
  },

  --	A search and research tool, PANEL for neovim.
  -- search/replace in multiple files
  -- buf filetype: spectre
  -- Use command: :Spectre or <leader>S, <leader>ss, <leader>sw
  -- local commands:
  -- dd, <cr>, <leader>Q, <leader>l, <leader>R, <leader>rc, <leader>c, <leader>uu/uv/ui/uo/uh
  -- Warnings: Always commit your files before you replace text. nvim-spectre does not support undo directly.
  -- TODO: config nvim-spectre's panel
  {
    "nvim-pack/nvim-spectre",
    dependencies = {
      { 'nvim-lua/plenary.nvim', event = "VeryLazy" }
    },
    cmd = "Spectre",
    opts = {
      open_cmd = "noswapfile vnew",
      live_update = true,
      is_insert_mode = true,
      mapping = {
        ['send_to_qf'] = {
          map = "<leader>Q",
          cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
          desc = "send all items to quickfix"
        },
        ['show_option_menu'] = {
          map = "uo",
          cmd = "<cmd>lua require('spectre').show_options()<CR>",
          desc = "show options"
        },
        ['toggle_live_update'] = {
          map = "uu",
          cmd = "<cmd>lua require('spectre').toggle_live_update()<CR>",
          desc = "update when vim writes to file"
        },
        ['change_view_mode'] = {
          map = "uv",
          cmd = "<cmd>lua require('spectre').change_view()<CR>",
          desc = "change result view mode"
        },
        ['toggle_ignore_case'] = {
          map = "ui",
          cmd = "<cmd>lua require('spectre').change_options('ignore-case')<CR>",
          desc = "toggle ignore case"
        },
        ['toggle_ignore_hidden'] = {
          map = "uh",
          cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
          desc = "toggle search hidden"
        },
        ['change_replace_sed'] = {
          map = "us",
          cmd = "<cmd>lua require('spectre').change_engine_replace('sed')<CR>",
          desc = "use sed to replace"
        },
        ['change_replace_oxi'] = {
          map = "ux",
          cmd = "<cmd>lua require('spectre').change_engine_replace('oxi')<CR>",
          desc = "use oxi to replace"
        },
      },
    },
    keys = {
      {
        "<leader>S",
        function() require("spectre").open() end,
        "n",
        desc = "Replace in files (Spectre)"
      },
      {
        '<leader>sw',
        function() require("spectre").open_visual({ select_word = true }) end,
        "n",
        desc = "Search current word"
      },
      {
        '<leader>sw',
        function() require("spectre").open_visual() end,
        "v",
        desc = "Search and replace current word"
      },
      {
        '<leader>ss',
        function() require("spectre").open_file_search({ select_word = true }) end,
        "n",
        desc = "Search and replace in current file"
      }
    },
  },

  -- -- easily jump to any location and enhanced f/t motions for Leap
  -- -- usage:
  -- {
  -- 	"ggandor/flit.nvim",
  --    dependencies = {
  -- 		{ "tpope/vim-repeat", event = "VeryLazy" },
  -- 		{ "ggandor/leap.nvim",}
  -- 	},
  -- 	keys = function()
  -- 		local ret = {}
  -- 		for _, key in ipairs({ "f", "F", "t", "T" }) do
  -- 			ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
  -- 		end
  -- 		return ret
  -- 	end,
  -- 	opts = {
  -- 		labeled_modes = "nx",
  -- 		multiline = false,
  -- 	},
  -- },

  -- easily motion
  -- usage:
  -- -- s{c1}{c2}
  -- -- s<enter> / s<enter><enter>
  -- {
  -- 	"ggandor/leap.nvim",
  --    dependencies = {
  -- 		{ "tpope/vim-repeat", event = "VeryLazy" },
  -- 	},
  -- 	keys = {
  -- 		{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
  -- 		{ "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
  -- 		{ "gS", mode = { "n", "x", "o" }, desc = "Leap from windows" },
  -- 	},
  -- 	opts = {
  -- 		highlight_unlabeled_phase_one_targets = false,
  -- 	},
  -- 	config = function(_, opts)
  -- 		local leap = require("leap")
  -- 		leap.setup(opts)
  -- 		leap.add_default_mappings(false)  -- check for conflicts with any custom mappings created by you or other plugins, and will not overwrite them
  --
  -- 		leap.add_repeat_mappings(';', ',', {
  -- 			-- False by default. If set to true, the keys will work like the native semicolon/comma,
  -- 			-- i.e., forward/backward is understood in relation to the last motion.
  -- 			relative_directions = true,
  -- 			-- By default, all modes are included.
  -- 			modes = {'n', 'x', 'o'},
  -- 		})
  -- 	end,
  -- },
  --
  -- easily jump, Hop is an EasyMotion-like plugin allowing you to jump anywhere in a document with as few keystrokes as possible.
  {
    "phaazon/hop.nvim",
    event = "VeryLazy",

    config = function()
      local hop = require('hop')
      hop.setup()
      local directions = require('hop.hint').HintDirection
      vim.keymap.set('n', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
      end, { remap = true })
      vim.keymap.set('n', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
      end, { remap = true })
      vim.keymap.set('n', 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
      end, { remap = true })
      vim.keymap.set('n', 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
      end, { remap = true })

      vim.keymap.set('n', 's', function()
        hop.hint_char2({ multi_windows = true })
      end, { remap = true })
      vim.keymap.set('n', 'S', function()
        hop.hint_lines({ multi_windows = true })
      end, { remap = true })
      -- hop.hint_with
      -- hop.hint_with_callback
      -- hop.hint_words
      -- hop.hint_patterns
      -- hop.hint_char1
      -- hop.hint_char2
      -- hop.hint_lines
      -- hop.hint_vertical
      -- hop.hint_lines_skip_whitespace
      -- hop.hint_anywhere
    end,
  },

  -- which-key
  -- displays a popup with possible key bindings of the command you started typing.
  -- and built-in plugins: marks, registers, presets(built-in key binding help for motions, text-objects, operators, windows, nav, z and g) and spelling suggestions.
  -- usage:
  -- 			' and `  to trigger marks
  -- 			" in normal mode and <C-r> in insert mode to trigger register
  --  		z= to trigger spelling suggestions
  --  		<c-w> to trigger window commandsj
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
      -- disable = {
      -- 	buftypes = {},
      -- 	filetypes = {},
      -- },
      defaults = {
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+hunks" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>u"] = { name = "+toggle" },
        ["<leader>d"] = { name = "+diagnostics" },
      },
    },
    config = function(_, opts)
      -- Group names use the special name key in the tables.
      -- There's multiple ways to define the mappings.
      -- wk.register can be called multiple times from anywhere in your config files.
      local wk = require("which-key")
      wk.setup(opts)
      wk.register(opts.defaults)

      -- wk.register({
      -- 	f = {
      -- 		name = "file", -- optional group name
      -- 		f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
      -- 		r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
      -- 		n = { "New File" }, -- just a label. don't create any mapping
      -- 		e = "Edit File", -- same as above
      -- 		["1"] = "which_key_ignore",  -- special label to hide it in the popup
      -- 		b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
      -- 	},
      -- }, { prefix = "<leader>" })
    end,
  },

  -- git signs, Git integration for Buffers
  -- Features:
  -- Signs for added, removed, and changed lines
  -- Asynchronous using luv
  -- Navigation between hunks
  -- Stage hunks (with undo)
  -- Preview diffs of hunks (with word diff)
  -- Customizable (signs, highlights, mappings, etc)
  -- Status bar integration
  -- Git blame a specific line using virtual text.
  -- Hunk text object
  -- Automatically follow files moved in the index.
  -- Live intra-line word diff
  -- Ability to display deleted/changed lines via virtual lines.
  -- Support for yadm
  -- Support for detached working trees.
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- signs = {
      -- 	add = { text = "▎" },
      -- 	change = { text = "▎" },
      -- 	delete = { text = "" },
      -- 	topdelete = { text = "" },
      -- 	changedelete = { text = "▎" },
      -- 	untracked = { text = "▎" },
      -- },
      --
      on_attach = function()
        local gs = package.loaded.gitsigns

        -- Navigation
        vim.keymap.set('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        vim.keymap.set('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, { expr = true })

        -- Actions
        vim.keymap.set('n', '<leader>hs', gs.stage_hunk, { desc = "Stage Hunk" })
        vim.keymap.set('n', '<leader>hr', gs.reset_hunk, { desc = "Reset Hunk" })
        vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = "Stage Hunk" })
        vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end,
          { desc = "Reset Hunk" })
        vim.keymap.set('n', '<leader>hS', gs.stage_buffer, { desc = "Stage Buffer" })
        vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
        vim.keymap.set('n', '<leader>hR', gs.reset_buffer, { desc = "Reset Buffer" })
        vim.keymap.set('n', '<leader>hp', gs.preview_hunk, { desc = "Previous Hunk" })
        vim.keymap.set('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = "Blame Line" })
        vim.keymap.set('n', '<leader>hd', gs.diffthis, { desc = "Diff This" })
        vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "Diff This ~" })

        vim.keymap.set('n', '<leader>uD', gs.toggle_deleted, { desc = "GitSigns Toggle Deleted" })
        vim.keymap.set('n', '<leader>ub', gs.toggle_current_line_blame, { desc = "GitSigns Toggle Blame Line" })

        -- Text object
        vim.keymap.set({ 'o', 'x' }, 'ih', gs.select_hunk, { desc = "GitSigns Select Hunk" })
      end,
    },
  },

  -- fugitive.vim: A Git wrapper
  {
    "tpope/vim-fugitive",
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
      "Gedit"
    },
    -- TODO: move close_if_last_window to autocmds.lua
  },

  -- references
  -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  -- <a-n>/]] and <a-p>/[[, move between references
  -- :Illuminate{Pause, Resume, Toggle, PauseBuf, ResumeBuf, ToggleBuf,}
  {
    "RRethy/vim-illuminate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = {
        providers = { "lsp" },
      },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)

      local function map(key, dir, buffer)
        vim.keymap.set("n", key, function()
          require("illuminate")["goto_" .. dir .. "_reference"](false)
        end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
      end

      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          local buffer = vim.api.nvim_get_current_buf()
          map("]]", "next", buffer)
          map("[[", "prev", buffer)
        end,
      })
    end,
    keys = {
      { "]]", desc = "Next Reference" },
      { "[[", desc = "Prev Reference" },
    },
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    keys = {
      {
        "<leader>x",
        function()
          vim.cmd.write()
          require("mini.bufremove").delete(0, false)
        end,
        desc = "Delete Buffer"
      },
      {
        "<leader>X",
        function()
          vim.cmd.write()
          require("mini.bufremove").delete(0, true)
        end,
        desc =
        "Delete Buffer (Force)"
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
    -- cmd = { "TodoTrouble", "TodoTelescope" },
    cmd = { "TodoTelescope" },
    event = { "BufReadPost", "BufNewFile" },
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
    config = true, -- To use the default implementation without "opts", set config to true.
    -- or using customized config function
    -- config = function(_, opts)
    -- 	require("todo-comments").setup(opts)
    -- end,
    keys = {
      {
        "]-",
        function() require("todo-comments").jump_next() end,
        desc = "Next todo comment"
      },
      {
        "[-",
        function() require("todo-comments").jump_prev() end,
        desc = "Previous todo comment"
      },
      -- {
      -- 	"<leader>t-",
      -- 	"<cmd>TodoTrouble<cr>",
      -- 	desc = "Todo (Trouble)"
      -- },
      -- { "<leader>T-", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      {
        "<leader>f-",
        "<cmd>TodoTelescope<cr>",
        desc = "Todo"
      },
      {
        "<leader>F-",
        "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>",
        desc = "Todo/Fix/Fixme"
      },
    },
  },
}
