-- extensions of vim.ui
-- .. notify
-- .. input
-- .. select
-- .. winbar
-- .. statusline
-- .. tagpage(bufferline)
-- .. messages
-- .. cmdline
-- .. popupmenu
return {
  {
    -- Better `vim.notify()`
    -- A fancy, configurable, notification manager for NeoVim
    "rcarriga/nvim-notify",
    event = { "VeryLazy" },
    opts = {
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      background_colour = "Normal",
    },
    config = function(_, opts)
      local notify = require("notify")
      notify.setup(opts)
      vim.notify = notify
    end,
  },
  {
    -- Statusline, A blazing fast and easy to configure neovim statusline plugin
    "nvim-lualine/lualine.nvim",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = function(_, opts)
      local icons = require("leovim.config.defaults").icons
      local exclude_filetypes = require("leovim.config.defaults").non_essential_filetypes

      local function trim(s)
        return s:match("^%s*(.-)%s*$")
      end

      local foreground = function(name)
        ---@type {foreground?:number}?
        local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
          or vim.api.nvim_get_hl(0, { name = name, create = true })
        local fg = hl and hl.foreground
        return fg and { fg = string.format("#%06x", fg) }
      end

      return vim.tbl_deep_extend("keep", {
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
          lualine_a = { "mode" },
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
            {
              -- TODO: append this component after setup dap
              function()
                return "  " .. require("dap").status()
              end,
              cond = function()
                return package.loaded["dap"] and require("dap").status() ~= ""
              end,
              -- color = Util.fg("Debug"),
            },
            {
              require("lazy.status").updates,
              cond = require("lazy.status").has_updates,
              color = foreground("Special"),
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
          lualine_z = { "filename" },
        },
        -- lualine extensions change statusline appearance for a window/buffer with specified filetypes
        -- By default no extensions are loaded to improve performance.
        -- extensions = { "nvim-tree", "lazy" },
      }, opts or {})
    end,
    -- init = function()
    -- -- disable builtin statusline before setup lualine
    -- vim.opt.statusline = ""
    -- end,
  },
  {
    -- nvim-navic, A simple statusline/winbar component that uses LSP to show your current code context.
    -- usage: call the functions:
    --  is_available(bufnr)
    --  get_location(opts, bufnr)
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
}