return {
  {
    -- A plugin for profiling Vim and Neovim startup time.
    -- usage
    -- :StartupTime
    -- Press K on events to get additional information.
    -- Press gf on sourcing events to load the corresponding file in a new split.
    -- :help startuptime-configuration for details on customization options.
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
    init = function()
      vim.g.startuptime_tries = 10
    end,
  },
  { -- Smooth scrolling neovim plugin
    -- usage:
    --  MinimapUpdateHighlightAll these keys will be mapped to their corresponding default scrolling animation
    --  "<C-u>", "<C-d>", "<C-b>", "<C-f>", "<C-y>", "<C-e>", "zt", "zz", "zb"

    "karb94/neoscroll.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}