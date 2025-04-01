return {
  -- DAP(Debug Adapter Protocol) client implementation for Neovim
  -- usage: A typical debug flow consists of:
  -- 	1) Setting breakpoints via :lua require'dap'.toggle_breakpoint().
  -- 	2) Launching debug sessions and resuming execution via :lua require'dap'.continue().
  -- 	3) Stepping through code via :lua require'dap'.step_over() and :lua require'dap'.step_into().
  -- 	4) Inspecting the state via the built-in REPL: :lua require'dap'.repl.open() or using the widget UI (:help dap-widgets)
  {
    "mfussenegger/nvim-dap",
    -- enabled = false,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "jbyuki/one-small-step-for-vimkind" },
    },
    cmd = { "Debug" },
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
      adapters = require("leovim.plugins.dev.dap.adapters"),
      configurations = require("leovim.plugins.dev.dap.configurations"),
      -- adapters = {},
      -- configurations = {},
    },
    config = function(_, opts)
      local icons = require("leovim.config.defaults").icons
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      -- load and setup dap adapters via nvim-dap extension
      local load_module = require("leovim.utils").load_module
      load_module("dap-go")
      load_module("dap-python")

      -- config adapters manually (as following)
      local dap = require("dap")
      vim.tbl_deep_extend("keep", dap.adapters, opts.adapters)
      vim.tbl_deep_extend("keep", dap.configurations, opts.configurations)

      -- load and setup dapui
      load_module("dapui")
    end,
  },
  -- nvim-dap extensions for config adapters and configurations
  -- loaded by nvim-dap config
  {
    "leoluz/nvim-dap-go",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
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
    config = function()
      require("dap-go").setup()
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    config = function()
      -- python3 -m debugpy --version must work in the shell
      require("dap-python").setup("python3")
    end,
  },

  {
    -- fancy UI for the debugger
    -- usage:
    --    edit: e
    --    expand: <CR>
    --    open: o
    --    remove: d
    --    repl: r
    --    toggle: t
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        -- toggle dapui
        "<leader><leader>d",
        function()
          require("dapui").toggle()
        end,
        desc = "Dapui(debug)",
      },
      {
        "<leader>du",
        function()
          require("dapui").toggle({ reset = true })
        end,
        desc = "Reset dapui",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
      },
      {
        "<leader>dE",
        function()
          require("dapui").eval(vim.fn.input("[Expression] > "))
        end,
        desc = "Eval expr",
      },
    },
    opts = {
      expand_lines = true,
      icons = { expanded = "", collapsed = "", circular = "" },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      local dap = require("dap")
      dapui.setup(opts)

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open({})
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close({})
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close({})
      end
    end,
  },

  -- virtual text support to nvim-dap
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
    opts = {
      commented = true,
    },
  },

  -- {
  --  -- an adapter for the Neovim lua language
  --   "jbyuki/one-small-step-for-vimkind",
  --   keys = {
  --     {
  --       "<leader>daL",
  --       function()
  --         require("osv").launch({ port = 8086 })
  --       end,
  --       desc = "Adapter Lua Server",
  --     },
  --     {
  --       "<leader>dal",
  --       function()
  --         require("osv").run_this()
  --       end,
  --       desc = "Adapter Lua",
  --     },
  --   },
  -- },
}