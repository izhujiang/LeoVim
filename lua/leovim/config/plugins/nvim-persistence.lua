return {
  -- keys = {
  --   { "<leader>pc", "<cmd>SessionLoadCwd<cr>", desc = "Cwd" },
  --   { "<leader>pr", "<cmd>SessionLoadLast<cr>", desc = "Recent/Last" },
  --   { "<leader>ps", "<cmd>SessionSelect<cr>", desc = "Select" },
  -- },
  opts = {
    -- dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
    pre_save = nil, -- a function to call before saving the session
  },
}
