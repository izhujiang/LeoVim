return {
  -- Statusline, A blazing fast and easy to configure neovim statusline plugin
  "nvim-lualine/lualine.nvim",
  event = { "VeryLazy" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
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
        lualine_z = { "filename" },
      },
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
}