local M = {
  typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = function()
        return require("dap.utils").pick_process
      end,
      cwd = "${workspaceFolder}",
    },
  },
}
M.javascript = M.typescript

return M
