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
      { "gr", group = "LSP" },
      { "gs", group = "Swap Next" },
      { "gS", group = "Swap Previous" },
      { "g'", group = "Mark`" },
      { "g`", group = "Mark'" },
      { "z", group = "Fold/Scroll" },
      { "<leader>a", group = "AI" },
      { "<leader>b", group = "Buffer" },
      -- { "<leader>d",  name = "Debug",         icon = { color = "green" } },
      { "<leader>d", group = "Debug" },
      { "<leader>f", group = "Fuzzy Finder" },
      { "<leader>fg", group = "git" },
      { "<leader>fl", group = "LSP" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Hunk" },
      { "<leader>j", group = "Jump" },
      { "<leader>o", group = "Options" },
      { "<leader>oh", group = "Gitsigns" },
      { "<leader>t", group = "Test" },
      { "<leader>x", group = "Trouble" },
      { "<leader>z", group = "System" },
    },
    disable = {
      bt = {
        "help",
        "quickfix",
        "terminal",
        "prompt",
      },
      ft = vim.g.non_essential_filetypes,
    },
    sort = { "alphanum", "case" },
    -- sort = { "local", "order", "group", "alphanum", "mod" },
  },

  init = function()
    vim.o.timeout = true
    -- vim.o.timeoutlen = 800
  end,
}
