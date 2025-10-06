return {
  keys = {
    -- Open the status buffer in a new tab
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    { "<leader>gc", "<cmd>NeogitCommit<cr>", desc = "Neogit commit(HEAD)" },
    { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "Neogit log(%)" },
  },
  opts = {
    -- disable_hint = true,
    -- disable_context_highlighting = true,
    disable_signs = true,
    filewatcher = {
      -- interval = 1000,
      enabled = true,
    },
    integrations = {
      diffview = true,
      fzf_lua = true,
    },
    telescope_sorter = nil,
    status = {
      recent_commit_include_author_info = true,
    },
  },
}
