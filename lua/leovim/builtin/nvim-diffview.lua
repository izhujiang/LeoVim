return {
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview" },
    -- use <leader>q :tabclose to quit diffview instead
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview history(%)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Diffview history(branch)" },
  },
  opts = {
    hooks = {
      view_opened = function()
        vim.t.is_diffview_tabpage = true
      end,
    },
  },
}