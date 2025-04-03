return {
  keys = {
    { "<leader>zn", "<cmd>NullLsInfo<cr>", desc = "Info(null_ls)" },
  },

  opts = function()
    return require("leovim.builtin.lsp.server")["null-ls"]()
  end,
}