return {
  keys = {
    {
      "]-",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Todo",
    },
    {
      "[-",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Todo",
    },
    {
      "<leader>x-",
      "<cmd>TodoTrouble<cr>",
      desc = "Todo",
    },
    {
      "<leader>f-",
      "<cmd>TodoFzfLua<cr>",
      desc = "Todo",
    },
  },

  opts = {
    -- opts must be non-null.
    --   keywords = {
    --     FIX = {
    --       icon = " ", -- icon used for the sign, and in search results
    --       color = "error", -- can be a hex color, or a named color (see below)
    --       alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
    --       -- signs = false, -- configure signs for some keywords individually
    --     },
    --     TODO = { icon = " ", color = "info" },
    --     HACK = { icon = " ", color = "warning" },
    --     WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
    --     PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
    --     NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
    --     TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
    --   },
  },
}
