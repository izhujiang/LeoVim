return {
  {
    -- AI pair programmer
    -- Make sure to run :Lazy load copilot-cmp followed by
    -- :Copilot auth
    -- once the plugin is installed to start the authentication process.
    "zbirenbaum/copilot-cmp",
    enabled = false, -- disable copilot disable

    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          -- disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp.
          suggestion = { enabled = false },
          panel = { enabled = false },
        })                             -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
}
