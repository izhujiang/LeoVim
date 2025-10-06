return {
  tokyonight = {
    opts = { style = "moon" },
  },

  everforest = {
    init = function()
      -- config everforest init function, before ":colorscheme everforest"
      vim.g.everforest_background = "soft"
      -- vim.g.everforest_enable_italic = 1
      -- vim.g.everforest_disable_italic_comment = 1
      -- vim.g.everforest_cursor = 'auto'
      -- vim.g.everforest_transparent_background = 0
      -- vim.g.everforest_sign_column_background = 'none'
      -- vim.g.everforest_ui_contrast = 'low'
      -- vim.g.everforest_show_eob = 1
      -- vim.g.everforest_float_style = 'bright'
      -- vim.g.everforest_diagnostic_text_highlight = 1
      -- vim.g.everforest_diagnostic_line_highlight = 1
      -- vim.g.everforest_diagnostic_virtual_text = 'grey' " 'colored' 'highlighted'
      -- vim.g.everforest_lightline_disable_bold = 1
      -- vim.g.everforest_current_word = 'grey background'
      -- vim.g.everforest_inlay_hints_background = 'none'
      -- vim.g.everforest_disable_terminal_colors = 0
      vim.g.everforest_lightline_disable_bold = 1
      vim.g.everforest_better_performance = 1
      -- vim.g.everforest_colors_override = {}
    end,
  },

  catppuccin = {
    opts = {
      default_integrations = true,
      integrations = {
        blink_cmp = true,
        illuminate = true,
        lsp_trouble = true,
        mason = true,
        navic = { enabled = true },
        neotest = true,
        nvimtree = true,
        noice = false,
        notify = true,
        which_key = true,
      },
    },
  },
}
