return {
  keys = {
    {
      "<leader>dt",
      function()
        require("dap-go").debug_test()
      end,
      desc = "Debug closest test",
    },
    {
      "<leader>dT",
      function()
        require("dap-go").debug_last_test()
      end,
      desc = "Debug last test",
    },
  },
  opts = {},
}