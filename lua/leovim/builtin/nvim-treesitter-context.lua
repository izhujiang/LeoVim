return {
  keys = {
    {
      "<leader><leader>c",
      "<cmd>TSContextToggle<cr>",
      desc = "Toggle TS_Context",
    },
  },
  opts = {
    enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = "-",
  },
}