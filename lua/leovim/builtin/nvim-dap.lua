return {
  keys = {
    {
      "<F9>",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      -- TODO: add <C-F5> start without debugging,  <C-S-F5> Restart debugging
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Start/Continue debug",
    },
    {
      -- NOTE: Disable <S-F5> in iterm2 (setting -> profiles -> keys -> key mappings)
      -- TODO: <S-F5> doesn't work
      -- "<S-F5>",
      "<F4>",
      function()
        require("dap").terminate()
      end,
      desc = "Stop debug",
    },
    {
      "<C-S-F5>",
      function()
        require("dap").run_last()
      end,
      desc = "Run last debug",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<S-F11>",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },

    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("breakpoint condition: "))
      end,
      desc = "Set breakpoint condition",
    },
    {
      "<leader>ds",
      function()
        require("dap").continue()
      end,
      desc = "Start debug",
    },
    {
      "<leader>dc",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<leader>dg",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Run(go) to cursor",
    },
    {
      "<leader>di",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<leader>do",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
    {
      "<leader>dn",
      function()
        require("dap").step_over()
      end,
      desc = "Step over/next",
    },
    {
      "<leader>dp",
      function()
        require("dap").step_back()
      end,
      desc = "Step back/previous",
    },
    {
      "<leader>dP",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<leader>dh",
      function()
        require("dap").close()
      end,
      desc = "Close/halt",
    },
    {
      -- toggle repl
      "<leader><leader>R",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Toggle repl(debug)",
    },
    {
      "<leader>dw",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "DAP widgets",
    },
  },

  opts = {
    -- adapters = {},
    -- configurations = {},
    adapters = {
      ["pwa-node"] = function()
        local adapter_root = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
        return {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = {
              adapter_root .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            },
          },
        }
      end,
    },
    configurations = {
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
      javascript = {
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
    },
  },
}