return {
  -- Debug Adapter Protocol client implementation for Neovim
  -- A typical debug flow consists of:
  -- 	1) Setting breakpoints via :lua require'dap'.toggle_breakpoint().
  -- 	2) Launching debug sessions and resuming execution via :lua require'dap'.continue().
  -- 	3) Stepping through code via :lua require'dap'.step_over() and :lua require'dap'.step_into().
  -- 	4) Inspecting the state via the built-in REPL: :lua require'dap'.repl.open() or using the widget UI (:help dap-widgets)
  {
    "mfussenegger/nvim-dap",
    -- enabled = false,
    dependencies = {
      { "rcarriga/nvim-dap-ui" },
      { "theHamsta/nvim-dap-virtual-text" },
      { "nvim-telescope/telescope-dap.nvim" },
      -- { "jbyuki/one-small-step-for-vimkind" },
    },
    cmd = { "Debug" },
    keys = function()
      return {
        {
          "<F9>",
          function() require("dap").toggle_breakpoint() end,
          desc = "Breakpoint"
        },
        {
          -- TODO: add <C-F5> start without debugging,  <C-S-F5> Restart debugging
          "<F5>",
          function() require("dap").continue() end,
          desc = "Start Debugging / Continue"
        },
        {
          -- NOTE: Disable <S-F5> in iterm2 (setting -> profiles -> keys -> key mappings)
          -- TODO: <S-F5> doesn't work
          -- "<S-F5>",
          "<F4>",
          function() require("dap").terminate() end,
          desc = "Terminate"
        },
        {
          "<C-S-F5>",
          function() require("dap").run_last() end,
          desc = "Run Last"
        },
        {
          "<F11>",
          function() require("dap").step_into() end,
          desc = "Step Into"
        },
        {
          "<S-F11>",
          function() require("dap").step_out() end,
          desc = "Step Out"
        },
        {
          "<F10>",
          function() require("dap").step_over() end,
          desc = "Step Over"
        },

        {
          "<leader>db",
          function() require("dap").toggle_breakpoint() end,
          desc = "Breakpoint"
        },
        {
          "<leader>dB",
          function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
          desc = "Breakpoint Condition"
        },
        {
          "<leader>ds",
          function() require("dap").continue() end,
          desc = "Start"
        },
        {
          "<leader>dc",
          function() require("dap").continue() end,
          desc = "Continue"
        },
        {
          "<leader>dC",
          function() require("dap").run_to_cursor() end,
          desc = "Run to Cursor"
        },
        {
          "<leader>di",
          function() require("dap").step_into() end,
          desc = "Step Into"
        },
        {
          "<leader>dI",
          function() require("dap").step_out() end,
          desc = "Step Out"
        },
        {
          "<leader>do",
          function() require("dap").step_over() end,
          desc = "Step Over"
        },
        {
          "<leader>dO",
          function() require("dap").step_back() end,
          desc = "Step Back"
        },
        {
          "<leader>dp",
          function() require("dap").pause() end,
          desc = "Pause"
        },
        {
          "<leader>dt",
          function() require("dap").close() end,
          desc = "Close"
        },

        {
          "<leader>dr",
          function() require("dap").repl.toggle() end,
          desc = "Toggle REPL"
        },

        {
          "<leader>du",
          function() require("dapui").toggle() end,
          "Toggle DapUI"
        },
        {
          "<leader>dU",
          function() require("dapui").toggle({ reset = true }) end,
          "Reset DapUI"
        },
        {
          "<leader>dw",
          function() require("dap.ui.widgets").hover() end,
          desc = "Widgets"
        },
        { "<leader>de",
          function() require("dapui").eval() end,
          "Eval"
        },
        { "<leader>dE",
          function() require("dapui").eval(vim.fn.input('[Expression] > ')) end,
          "Eval"
        },

      }
    end,
    opts = {
      adapters = require("leovim.plugins.dev.dap.adapters"),
      configurations = require("leovim.plugins.dev.dap.configurations"),
      -- adapters = {},
      -- configurations = {},
    },
    config = function(_, opts)
      -- config dap.adapters and configurations by mason-nvim-dap in mason.lua, but only 24 adapters are supported.
      -- OR install and config adapters manually (as following) (https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation)
      local dap = require("dap")
      for name, adapter in pairs(opts.adapters) do
        if type(adapter) == "function" then
          dap.adapters[name] = adapter()
        else
          dap.adapters[name] = adapter
        end
      end
      for name, conf in pairs(opts.configurations) do
        dap.configurations[name] = conf
      end

      local icons = require("leovim.config.defaults").icons
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      -- vim.fn.sign_define(
      -- 	"DapBreakpoint",
      -- 	{ text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" }
      -- )
      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define(
          "Dap" .. name,
          { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
        )
      end

      local dapui = require("dapui")
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

  -- fancy UI for the debugger
  {
    -- WARN: dap is developing dap-widgets, use dap_widgets later.
    -- dap_widgets: API is experimental and subject to change.
    -- The UI of nvim-dap is by default minimal and noninvasive, but it provides
    -- widget primitives that can be used to build and customize a UI.
    "rcarriga/nvim-dap-ui",
    -- enabled = false,
    -- dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"},
    dependencies = { "nvim-neotest/nvim-nio" },
    keys = function()
      return {
        {
          "<leader>du",
          function()
            require("dapui").toggle({})
          end,
          desc = "DapUI",
        },
        { "<leader>dU",
          function()
            require 'dapui'.toggle({ reset = true })
          end,
          "DapUI(reset)"
        },
        {
          "<leader>de",
          function()
            require("dapui").eval()
          end,
          desc = "Eval",
          mode = { "n", "v" },
        },
        {
          "<leader>dE",
          function()
            require("dapui").eval(vim.fn.input("[Expression] > "))
          end,
          desc = "Eval Input",
          mode = { "n", "v" },
        },
      }
    end,
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
            { id = "scopes",      size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
          },
          size = 0.33,
          position = "left",
        },
        {
          elements = {
            { id = "repl",    size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,             -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    },
    config = function(_, opts)
      local dapui = require("dapui")
      dapui.setup(opts)
    end,
  },

  -- virtual text support to nvim-dap
  {
    "theHamsta/nvim-dap-virtual-text",
    enabled = false,
    opts = {
      commented = true,
    },
    -- config = function(_, opts)
    --   require("nvim-dap-virtual-text").setup(opts)
    -- end,
  },

  -- an adapter for the Neovim lua language
  -- {
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
