return {
  keys = {
    {
      -- toggle dapui
      "<leader>dt",
      function()
        require("dap-go").debug_test()
      end,
      desc = "Debug closest test",
    },
    {
      -- toggle dapui
      "<leader>dT",
      function()
        require("dap-go").debug_last_test()
      end,
      desc = "Debug last test",
    },
  },
  opts = {},
}