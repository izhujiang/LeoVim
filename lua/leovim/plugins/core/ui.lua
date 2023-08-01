return {
  -- Better `vim.notify()`
  -- A fancy, configurable, notification manager for NeoVim
  {
    "rcarriga/nvim-notify",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all Notifications",
      },
    },
    opts = {
      timeout = 3000,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    init = function()
      -- when noice is not enabled, install notify on VeryLazy
      local Util = require("leovim.util")
      if not Util.has("noice.nvim") then
        Util.on_very_lazy(function()
          vim.notify = require("notify") -- setting it as default notify function, so other plugins can use the notification windows by calling vim.notify(msg)
        end)
      end
    end,
  },

  -- better vim.ui
  -- Neovim plugin to improve the default vim.ui interfaces (select, input)
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
    opts = {
      input = {
        -- Set to `false` to disable
        mappings = {
          n = {
            ["<Esc>"] = "Close",
            ["<CR>"] = "Confirm",
          },
          i = {
            ["<C-c>"] = "Close",
            ["<CR>"] = "Confirm",
            ["<C-n>"] = "HistoryNext",
            ["<C-p>"] = "HistoryPrev",
            ["<C-j>"] = "HistoryNext",
            ["<C-k>"] = "HistoryPrev",
            ["<Up>"] = "false",
            ["<Down>"] = "false",
          },
        },
      },
    },
  },

  -- bufferline
  -- A snazzy buffer line for Neovim
  {
    "akinsho/bufferline.nvim",
    dependencies = {
      {
        "famiu/bufdelete.nvim",
        "nvim-tree/nvim-web-devicons",
      },
    },

    event = "VeryLazy",
    keys = {
      {
        "<leader>up",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle pin"
      },
      {
        "<leader>up",
        "<Cmd>BufferLineTogglePin<CR>",
        desc = "Toggle pin"
      },
      {
        "<leader>uP",
        "<Cmd>BufferLineGroupClose ungrouped<CR>",
        desc = "Delete non-pinned buffers"
      },
      {
        "[b",
        "<Cmd>BufferLineCyclePrev<CR>",
        desc = "Prev buffer"
      },
      {
        "]b",
        "<cmd>BufferLineCycleNext<cr>",
        desc = "Next buffer"
      },
    },
    config = function()
      local bufferline = require("bufferline")
      local opts = {
        options = {
          mode = "buffers",                               -- set to "tabs" to only show tabpages instead
          style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
          themable = true,                                -- allows highlight groups to be overridden i.e. sets highlights as default
          numbers = "buffer_id",                          -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          -- close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
          -- right_mouse_command = "Bdelete! %d", 	-- can be a string | function, see "Mouse actions"
          indicator = {
            style = "icon", --'icon', 'underline' | 'none',
          },

          buffer_close_icon = "󰅖",
          modified_icon = "●",
          close_icon = "",
          left_trunc_marker = "",
          right_trunc_marker = "",
          --- name_formatter can be used to change the buffer's label in the bufferline.
          -- name_formatter = function(buf)  -- buf contains:
          -- name                | str        | the basename of the active file
          -- path                | str        | the full path of the active file
          -- bufnr (buffer only) | int        | the number of the active buffer
          -- buffers (tabs only) | table(int) | the numbers of the buffers in the tab
          -- tabnr (tabs only)   | int        | the "handle" of the tab, can be converted to its ordinal number using: `vim.api.nvim_tabpage_get_number(buf.tabnr)`
          -- end,
          max_name_length = 18,
          max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          truncate_names = true,  -- whether or not tab names should be truncated
          tab_size = 18,
          diagnostics = "nvim_lsp",
          diagnostics_update_in_insert = false,
          diagnostics_indicator = function(_, _, diagnostics_dict, _)
            local s = " "
            for e, n in pairs(diagnostics_dict) do
              local sym = e == "error" and " " or (e == "warning" and " " or " ")
              s = s .. n .. sym
            end
            return s
          end,

          color_icons = true,       -- whether or not to add the filetype icon highlights
          show_buffer_icons = true, -- disable filetype icons for buffers
          show_buffer_close_icons = true,
          show_close_icon = true,
          show_tab_indicators = true,
          show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
          persist_buffer_sort = true,   -- whether or not custom sorted buffers should persist
          move_wraps_at_ends = false,   -- whether or not the move command "wraps" at the first or last position
          separator_style = "solpe",    --"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          sort_by = "id",

          close_command = function(n)
            require("mini.bufremove").delete(n, false)
          end,
          always_show_bufferline = false,

          offsets = {
            {
              filetype = "neo-tree", -- or "NvimTree"
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left",
              separator = true,
              padding = 0,
            },
          },

          highlights = {
            fill = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            background = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            buffer_visible = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            close_button_visible = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_selected = {
              fg = { attribute = "fg", highlight = "Normal" },
              bg = { attribute = "bg", highlight = "Normal" },
            },
            tab = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            tab_close = {
              fg = { attribute = "fg", highlight = "TabLineSel" },
              bg = { attribute = "bg", highlight = "Normal" },
            },
            duplicate_selected = {
              fg = { attribute = "fg", highlight = "TabLineSel" },
              bg = { attribute = "bg", highlight = "TabLineSel" },
              italic = true,
            },
            duplicate_visible = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
              italic = true,
            },
            duplicate = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
              italic = true,
            },
            modified = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            modified_selected = {
              fg = { attribute = "fg", highlight = "Normal" },
              bg = { attribute = "bg", highlight = "Normal" },
            },
            modified_visible = {
              fg = { attribute = "fg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            separator = {
              fg = { attribute = "bg", highlight = "TabLine" },
              bg = { attribute = "bg", highlight = "TabLine" },
            },
            separator_selected = {
              fg = { attribute = "bg", highlight = "Normal" },
              bg = { attribute = "bg", highlight = "Normal" },
            },
            indicator_selected = {
              fg = { attribute = "fg", highlight = "LspDiagnosticsDefaultHint" },
              bg = { attribute = "bg", highlight = "Normal" },
            },
          },
        },
      }

      bufferline.setup(opts)
    end,
  },

  -- statusline
  {
    "nvim-lualine/lualine.nvim",
    event = { "BufNew", "BufReadPost" },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      "SmiteshP/nvim-navic",
    },
    opts = function()
      local icons = require("leovim.config").icons
      local Util = require("leovim.util")

      return {
        options = {
          globalstatus = true,
          icons_enabled = true,
          theme = "auto",
          component_separators = nil,
          section_separators = nil, -- { left = "", right = "" },
          -- component_separators = { left = '', right = '' },
          -- section_separators = { left = '', right = '' },
          disabled_filetypes = { "alpha", "dashboard" },
          always_divide_middle = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = {
            "branch",
            {
              "diff",
              symbols = {
                added = icons.git.added,
                modified = icons.git.modified,
                removed = icons.git.removed,
              },
              cond = function()
                return vim.fn.winwidth(0) > 80
              end,
            },
          },
          lualine_c = {
            {
              "filetype",
              icon_only = true,
              separator = "",
              padding = { left = 1, right = 0 }
            },
            {
              "filename",
              path = 1,
              -- TODO: find icons for readonly and unnamed
              symbols = { modified = "", readonly = "", unnamed = "" }
            },
            {
              function()
                return require("nvim-navic").get_location()
              end,
              cond = function()
                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
              end,
            },
          },
          lualine_x = {
            {
              "diagnostics",
              symbols = {
                error = icons.diagnostics.Error.symbol,
                warn = icons.diagnostics.Warn.symbol,
                info = icons.diagnostics.Info.symbol,
                hint = icons.diagnostics.Hint.symbol,
              },
            },
            {
              function() return "  " .. require("dap").status() end,
              cond = function() return package.loaded["dap"] and require("dap").status() ~= "" end,
              color = Util.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.fg("Special"),
            },
          },
          lualine_y = {
            {
              "progress",
              separator = " ",
              padding = { left = 1, right = 0 }
            },
            {
              "location",
              padding = { left = 0, right = 1 }
            },
          },
          lualine_z = {
            function()
              return " " .. os.date("%R")
            end,
          },
        },
        extensions = { "neo-tree", "lazy" },
      }
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
        "fugitive",
      },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- dashboard
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
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

      dashboard.section.header.val = vim.split(logo, "\n")
      dashboard.section.buttons.val = {
        dashboard.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("f", "󰮗 " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        -- dashboard.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dashboard.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
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

  -- lsp symbol navigation for lualine,
  -- Simple winbar/statusline plugin that shows your current code context
  {
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
      vim.g.navic_silence = true
      require("leovim.util").on_attach(function(client, buffer)
        if client.server_capabilities.documentSymbolProvider then
          require("nvim-navic").attach(client, buffer)
        end
      end)
    end,
    opts = function()
      return {
        separator = " ",
        highlight = true,
        depth_limit = 5,
        icons = require("leovim.config").icons.kinds,
      }
    end,
  },

  -- icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true
  },

  -- ui components
  {
    "MunifTanjim/nui.nvim",
    lazy = true
  },
}
