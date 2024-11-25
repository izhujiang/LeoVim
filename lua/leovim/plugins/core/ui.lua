-- extensions of vim.ui
-- .. notify
-- .. input
-- .. select
-- .. winbar
-- .. statusline
-- .. bufferline
-- .. indent
-- .. messages
-- .. cmdline
-- .. popupmenu

return {
  -- Better `vim.notify()`
  -- A fancy, configurable, notification manager for NeoVim
  {
    "rcarriga/nvim-notify",
    event = { "VeryLazy" },
    keys = {
      {
        "<leader>dn",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss Notifications",
      },
    },
    opts = {
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },

  -- better vim.ui
  -- Neovim plugin to improve the default vim.ui interfaces (select, input)
  {
    "stevearc/dressing.nvim",
    event = { "VeryLazy" },
    opts = {
      -- input = {}
      select = {
        -- Priority list of preferred vim.select implementations
        backend = { "telescope", "builtin" },
      },
    },
    config = true,
  },

  -- bufferline
  -- A snazzy buffer line for Neovim
  {
    "akinsho/bufferline.nvim",
    event = { "VeryLazy" },
    dependencies = {
      {
        "nvim-tree/nvim-web-devicons",
      },
    },
    keys = {
      { "[b",         "<Cmd>BufferLineCyclePrev<CR>",       desc = "Previous Buffer" },
      { "]b",         "<cmd>BufferLineCycleNext<cr>",       desc = "Next Buffer" },
      { "<leader>bj", "<cmd>BufferLinePick<cr>",            desc = "Jump Buffer" },
      { "<leader>bd", "<cmd>BufferLinePickClose<cr>",       desc = "Close" },
      { "<leader>bh", "<cmd>BufferLineCloseLeft<cr>",       desc = "Close Left" },
      { "<leader>bl", "<cmd>BufferLineCloseRight<cr>",      desc = "Close Right", },
      { "<leader>bs", "<cmd>BufferLineSortByDirectory<cr>", desc = "Sort by Directory" },
      { "<leader>bS", "<cmd>BufferLineSortByExtension<cr>", desc = "Sort by Language" },
      { "<leader>bp", "<Cmd>BufferLineTogglePin<CR>",       desc = "Pin Buffer", },
    },
    opts = function()
      local opts = {
        options = {
          -- mode = "buffers",      -- set to "tabs" to only show tabpages instead
          -- style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.default,
          themable = true, -- allows highlight groups to be overridden i.e. sets highlights as default
          -- numbers = "buffer_id", -- "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
          -- indicator = {
          -- style = "icon",      --'icon', 'underline' | 'none',
          -- },

          -- buffer_close_icon = "󰅖",
          -- modified_icon = "●",
          -- close_icon = "",
          -- left_trunc_marker = "",
          -- right_trunc_marker = "",
          -- max_name_length = 18,
          -- max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
          -- truncate_names = true,  -- whether or not tab names should be truncated
          -- tab_size = 18,
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

          -- color_icons = true,       -- whether or not to add the filetype icon highlights
          -- show_buffer_icons = true, -- disable filetype icons for buffers
          -- show_buffer_close_icons = true,
          -- show_close_icon = true,
          show_tab_indicators = false,
          -- show_duplicate_prefix = true, -- whether to show duplicate buffer prefix
          -- persist_buffer_sort = true,   -- whether or not custom sorted buffers should persist
          -- move_wraps_at_ends = false,   -- whether or not the move command "wraps" at the first or last position
          separator_style = "thin", --"slant" | "slope" | "thick" | "thin" | { 'any', 'any' },
          sort_by = "id",

          hover = { enabled = false },

          -- close_command = function(n)
          --   require("leovim.plugins.util.buffer").buf_kill("bd", n)
          -- end,
          always_show_bufferline = false,

          offsets = {
            {
              filetype = "NvimTree", -- or "neo-tree" dependent on which file explorer is used
              text = "Explorer",
              highlight = "Directory",
              text_align = "left",
              -- separator = false,
              -- padding = 0,
            },
            {
              filetype = "undotree",
              text = "Undotree",
              highlight = "PanelHeading",
            },
            {
              filetype = "DiffviewFiles",
              text = "Diff View",
              highlight = "PanelHeading",
            },
            {
              filetype = "lazy",
              text = "Lazy",
              highlight = "PanelHeading",
            },
          },
        },

        highlights = {
          buffer_selected = {
            bold = true,
            italic = true,
          },
        },
      }
      -- FIX: when colors_name changed, theme should change too.
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end

      return opts
    end,
  },

  -- nvim-navic, A simple statusline/winbar component that uses LSP to show
  -- your current code context.
  -- lsp symbol navigation for lualine,
  -- Simple winbar/statusline plugin that shows your current code context
  -- nvim-navic does not alter your statusline or winbar on its own. Instead,
  -- you are provided with these two functions (is_available(bufnr), get_location(opts, bufnr)) and its
  -- left up to you how you want to incorporate this into your setup.
  {
    "SmiteshP/nvim-navic",
    init = function()
      vim.g.navic_silence = true
      vim.opt.showtabline = 2
    end,
    opts = {
      lsp = {
        auto_attach = true,
      },
      -- highlight = false,
      depth_limit = 5,
      -- lazy_update_context = true,
      icons = require("leovim.config.defaults").icons.kinds,
    },
  },

  -- Statusline, A blazing fast and easy to configure neovim statusline plugin
  {
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function()
      local icons = require("leovim.config.defaults").icons
      local exclude_filetypes = require("leovim.config.defaults").non_essential_filetypes
      local Util = require("leovim.plugins.util")
      local function trim(s)
        return s:match("^%s*(.-)%s*$")
      end

      return {
        options = {
          globalstatus = true,
          icons_enabled = true,
          -- theme = "auto", -- DON'T fix, let it change dynamically.
          component_separators = "",
          section_separators = "|", -- { left = "", right = "" },
          disabled_filetypes = exclude_filetypes,
          -- disabled_filetypes = {
          --   statusline = {},
          --   winbar = {},
          -- },
          -- always_divide_middle = true,
          padding = { left = 1, right = 1 },
        },
        sections = {
          -- lualine_a = { "mode" },
          lualine_b = {
            {
              "branch",
              icon = { trim(icons.git.Branch) },
            },
            {
              "diff",
              symbols = {
                added = icons.git.LineAdded,
                modified = icons.git.LineModified,
                removed = icons.git.LineRemoved,
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
              padding = { left = 0, right = 0 },
            },
            {
              "filename",
              path = 1,
              symbols = {
                modified = trim(icons.file.Modified),
                readonly = trim(icons.file.Readonly),
                unnamed = trim(icons.file.Unnamed),
              },
              padding = { left = 0, right = 1 },
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
            -- TODO: append this component after setup dap
            -- {
            --   function()
            --     return "  " .. require("dap").status()
            --   end,
            --   cond = function()
            --     return package.loaded["dap"] and require("dap").status() ~= ""
            --   end,
            --   color = Util.fg("Debug"),
            -- },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = Util.fg("Special"),
            },
          },
          lualine_y = {
            {
              "progress",
            },
            {
              "location",
            },
          },
          lualine_z = {
            {
              function()
                return icons.misc.Clock .. os.date("%R")
              end,
              padding = { left = 1, right = 1 },
            },
            {
              "hostname",
              padding = { left = 1, right = 1 },
            },
          },
        },

        -- winbar setting confict with neo-tree's source-selector settings.
        -- TODO: wait for updating neo-tree.nvim, or walk around by
        -- enabl/disable this component dependent on neo-tree's visibility.
        winbar = {
          lualine_b = {
            -- TODO: append this component after setup lsp
            {
              function()
                local navic = require("nvim-navic")
                return navic.get_location()
              end,
              padding = { left = 1, right = 0 },
            },
          },
          lualine_z = {
            {
              "filename",
              -- section_separators = "", -- { left = "", right = "" },
              cond = function()
                return vim.bo.filetype ~= "NvimTree"
              end,
            },
          },
        },
        inactive_winbar = {
          lualine_z = { 'filename' },
        }
        -- lualine extensions change statusline appearance for a window/buffer with specified filetypes
        -- By default no extensions are loaded to improve performance.
        -- extensions = { "nvim-tree", "lazy" },
      }
    end,
    -- config = function(_, opts)
    --   -- disable builtin statusline before setup lualine
    --   -- vim.opt.statusline = ""
    --   require("lualine").setup(opts)
    -- end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "VeryLazy" },
    main = "ibl", -- update from version 2 to version 3
    ---@module "ibl"
    ---@type ibl.config
    opts = {
      indent = {
        char = "╎",
      },
      scope = {
        enabled = true,
        char = "│",
        exclude = {
          language = { "rust" },
          node_type = { lua = { "block", "chunk" } },
        },
      },
      exclude = {
        buftypes = {
          "nofile",
          "prompt",
          "quickfix",
          "terminal",
        },
        filetypes = {
          "alpha",
          "checkhealth",
          "dashboard",
          "fugitive",
          "gitcommit",
          "help",
          "lazy",
          "lazyterm",
          "lspinfo",
          "man",
          "mason",
          "neo-tree",
          "notify",
          "toggleterm",
          "NvimTree",
          "Trouble",
          "TelescopePrompt",
          "TelescopeResults",
        },
      },
    },
  },
}
