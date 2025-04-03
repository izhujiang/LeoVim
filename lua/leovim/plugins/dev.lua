return {
  -- diagnostics, debug, test, and fix
  {
    -- trouble.nvim (enhanced QuicKfix or C(K)ompass ), better diagnostics list and others
    -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the troubles.
    -- usage:
    --  :Trouble [mode] [action] [options]
    -- 		-- document_diagnostics| workspace_diagnostics| lsp_references | lsp_definitions | lsp_type_definitions | quickfix | loclist

    "folke/trouble.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "Trouble",
    },
    config = function(_, opts)
      require("trouble").setup(opts)

      -- When you open fzf-lua, you can now hit <c-t> to open the results in Trouble
      local config = require("fzf-lua.config")
      local actions = require("trouble.sources.fzf").actions
      config.defaults.actions.files["ctrl-t"] = actions.open
      -- config.defaults.actions.files["ctrl-k"] = actions.open
    end,
  },

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "nvim-neotest/nvim-nio" },
      { "antoinemadec/FixCursorHold.nvim" },

      { "nvim-neotest/neotest-go" },
      { "nvim-neotest/neotest-python" },
      -- "nvim-neotest/neotest-vim-test",
      -- "markemmons/neotest-deno"
    },
    keys = require("leovim.builtin.nvim-neotest").keys or {},
    opts = require("leovim.builtin.nvim-neotest").opts or {},
    config = function(_, opts)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      if opts.adapters then
        local adapters = {}
        for name, config in pairs(opts.adapters or {}) do
          if type(name) == "number" then
            if type(config) == "string" then
              config = require(config)
            end
            adapters[#adapters + 1] = config
          elseif config ~= false then
            local adapter = require(name)
            if type(config) == "table" and not vim.tbl_isempty(config) then
              local meta = getmetatable(adapter)
              if adapter.setup then
                adapter.setup(config)
              elseif meta and meta.__call then
                adapter(config)
              else
                error("Adapter " .. name .. " does not support setup")
              end
            end
            adapters[#adapters + 1] = adapter
          end
        end
        opts.adapters = adapters
      end

      require("neotest").setup(opts)
    end,
  },

  -- debug
  {
    -- DAP(Debug Adapter Protocol) client implementation for Neovim
    -- usage: A typical debug flow consists of:
    -- 	1) Setting breakpoints via :lua require'dap'.toggle_breakpoint().
    -- 	2) Launching debug sessions and resuming execution via :lua require'dap'.continue().
    -- 	3) Stepping through code via :lua require'dap'.step_over() and :lua require'dap'.step_into().
    -- 	4) Inspecting the state via the built-in REPL: :lua require'dap'.repl.open() or using the widget UI (:help dap-widgets)
    "mfussenegger/nvim-dap",
    -- enabled = false,
    dependencies = {
      { "theHamsta/nvim-dap-virtual-text" },
      -- { "jbyuki/one-small-step-for-vimkind" },
    },
    cmd = { "Debug" },
    keys = require("leovim.builtin.nvim-dap").keys or {},
    opts = require("leovim.builtin.nvim-dap").opts or {},

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
    keys = require("leovim.builtin.nvim-dap-go").keys or {},
    opts = require("leovim.builtin.nvim-dap-go").opts or {},
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
    keys = require("leovim.builtin.nvim-dap-ui").keys or {},
    opts = require("leovim.builtin.nvim-dap-ui").opts or {},
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