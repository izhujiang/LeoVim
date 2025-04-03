return {
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = true })
      end,
      desc = "Help",
    },
  },
  opts = {
    preset = "helix",
    -- triggers = {
    -- { "<auto>", mode = "nxso" },
    -- },
    spec = {
      mode = { "n" },
      { "<leader>", group = "Leader" },
      { "[", group = "Previous" },
      { "]", group = "Next" },
      { "g", group = "Goto" },
      { "z", group = "Fold/Scroll" },
      { "gr", group = "LSP" },
      { "gs", group = "Swap Next" },
      { "gS", group = "Swap Previous" },
      { "g'", group = "Mark`" },
      { "g`", group = "Mark'" },
      { "<leader>a", group = "AI" },
      -- { "<leader>d", name = "+Debug", icon = { color = "green" } },
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Fuzzy Finder" },
      { "<leader>fg", group = "Find git" },
      { "<leader>fl", group = "Find LSP" },
      { "<leader>k", group = "Trouble" },
      { "<leader>g", group = "Git" },
      { "<leader>g", name = "Git" },
      { "<leader>h", group = "Hunk" },
      { "<leader>j", group = "Jump" },
      { "<leader>o", group = "Options" },
      { "<leader>oh", group = "Gitsigns" },
      { "<leader>p", group = "Select(Pick)" },
      { "<leader>t", group = "Test" },
      { "<leader>z", group = "Info" },
      { "<leader><leader>", group = "Toggle" },
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
    -- sort = { "alphanum", "case" },
    sort = { "local", "order", "group", "alphanum", "mod" },
  },

  init = function()
    vim.o.timeout = true
    -- vim.o.timeoutlen = 800
  end,
}