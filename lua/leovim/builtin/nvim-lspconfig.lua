return {
  keys = {
    { "<leader>zi", "<cmd>LspInfo<cr>", desc = "Info(LSP)" },
    {
      "<leader>zL",
      function()
        vim.cmd.edit(vim.lsp.get_log_path())
      end,
      "<cmd>LspInfo<cr>",
      desc = "Log(LSP)",
    },
  },
  opts = {
    diagnostics = {
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = false,
    },
  },
}