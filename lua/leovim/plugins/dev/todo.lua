return {
  -- todo comments
  -- Highlight, list and search todo comments  in your projects
  -- usage: ("-" stand for todolist)
  -- -- :TodoTrouble, :TodoFzfLua, :TodoQuickfix, :TodoLocList,
  -- -- <leader>f-/F-, <leader>t-/T-
  -- -- ]-/[-
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = { "VeryLazy" },
  cmd = { "TodoTrouble", "TodoFzfLua" },
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
  keys = {
    {
      "]-",
      function()
        require("todo-comments").jump_next()
      end,
      desc = "Next todo",
    },
    {
      "[-",
      function()
        require("todo-comments").jump_prev()
      end,
      desc = "Previous todo",
    },
    {
      "<leader>k-",
      "<cmd>TodoTrouble<cr>",
      desc = "Trboule todo",
    },
    {
      "<leader>f-",
      "<cmd>TodoFzfLua<cr>",
      desc = "Find todo",
    },
  },
}