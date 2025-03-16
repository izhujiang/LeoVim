return {
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
    -- Set a valid RGB hex color
    -- background_colour = "#000000",
    -- or  use the background color of the 'Normal' highlight group
    background_colour = "Normal",
  },
  config = function(_, opts)
    local notify = require("notify")
    notify.setup(opts)
    vim.notify = notify
  end,
}