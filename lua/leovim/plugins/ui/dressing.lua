return {
  -- better vim.ui
  -- Neovim plugin to improve the default vim.ui interfaces (select, input)
  -- TODO: use snacks.nvim instead for your vim.ui.* interfaces.
  "stevearc/dressing.nvim",
  event = { "VeryLazy" },
  opts = {
    -- input = {}
    select = {
      -- Priority list of preferred vim.select implementations
      backend = { "fzf_lua", "builtin" },
    },
  },
}