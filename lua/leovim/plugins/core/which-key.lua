return {
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
  --  to trigger fold:                  z
  --  to trigger spelling suggestions: 	z=
  --  to trigger window commands:		    <c-w>
  --  scroll_down = "<c-d>", -- binding to scroll down inside the popup
  --  scroll_up = "<c-u>", -- binding to scroll up inside the popup
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "echasnovski/mini.icons",
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Help",
    },
  },
  init = function()
    vim.o.timeout = true
    -- vim.o.timeoutlen = 800
  end,
  opts = {
    preset = "helix",
    -- triggers = {
    -- { "<auto>", mode = "nxso" },
    -- },
    spec = {
      mode = { "n" },
      { "[", name = "+Previous" },
      { "]", name = "+Next" },
      { "g", name = "+Goto" },
      { "z", name = "+Fold/Scroll" },
      { "<leader>a", name = "+AI" },
      { "<leader>c", name = "+Code" },
      { "<leader>d", name = "+Debug", icon = { icon = "󱖫 ", color = "green" } },
      { "<leader>f", name = "+Find", group = "fzf" },
      { "<leader>g", name = "+Git" },
      { "gs", name = "+Swap Next" },
      { "gS", name = "+Swap Previous" },
      { "gr", name = "+LSP" },
      { "g'", name = "+Mark`" },
      { "g`", name = "+Mark'" },
      { "<leader>h", name = "+Gitsigns/Hunk" },
      -- { "<leader>j", name = "+Jump" },
      { "<leader>k", name = "+Trouble" },
      { "<leader>l", name = "+LSP" },
      { "<leader>o", name = "+Options" },
      { "<leader>oh", name = "+Gitsigns" },
      { "<leader>t", name = "+Test" },
      { "<leader>u", name = "+Toggle" },
      { "<leader>ut", name = "+Test" },
      { "<leader>z", name = "+Info/Log" },
      { "<leader>zl", name = "+Log" },
      { "<leader>zi", name = "+Info" },
    },
    disable = {
      bt = {
        "help",
        "quickfix",
        "terminal",
        "prompt",
      },
      ft = require("leovim.config.defaults").non_essential_filetypes,
    },
    sort = { "alphanum", "case" },
  },
  -- config = function(_, opts)
  -- wk.register can be called multiple times from anywhere in your config files.
  -- local wk = require("which-key")
  -- wk.setup(opts)
  -- end,
  -- wk.register(opts.defaults)
}