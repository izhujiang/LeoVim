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
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
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
    -- opts_extend = { "spec" },
    opts = {
      -- defaults = {},
      spec = {
        mode = { "n" },
        { "<leader>I", name = "+Info" },
        { "<leader>b", name = "+Buffer" },
        -- TODO: codelens config
        { "<leader>c", name = "+Code" },
        { "<leader>d", name = "+Debug", icon = { icon = "󱖫 ", color = "green" } },
        { "<leader>f", name = "+Fuzzy_Find" },
        { "<leader>g", name = "+Git", group = "Git" },
        { "<leader>h", name = "+Gitsigns", group = "Gitsigns" },
        { "<leader>l", name = "+LSP", group = "LSP" },
        { "<leader>o", name = "+Option" },
        { "<leader>t", name = "+Trouble/Test" },
        { "<leader>z", name = "+Info/Log" },
        -- { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" }
        -- },
        { "[", name = "+Previous" },
        { "]", name = "+Next" },
        { "g", name = "+Goto" },
        { "z", name = "+Fold" },
      },
      disable = {
        buftypes = {
          "help",
          "quickfix",
          "terminal",
          "prompt",
        },
        filetypes = require("leovim.config.defaults").non_essential_filetypes,
      },
      sort = { "alphanum", "case" },
    },
    -- config = function(_, opts)
    --   -- wk.register can be called multiple times from anywhere in your config files.
    --   local wk = require("which-key")
    --   wk.setup(opts)
    -- end,
    --   wk.register(opts.defaults)
  },
}
