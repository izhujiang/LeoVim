return {
  keys = function()
    return {
      {
        -- Test single (nearest) function
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Test nearest",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run_last()
        end,
        desc = "Test last(recent)",
      },
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
          -- require("neotest").summary.open({ enter = false, auto_close = true })
        end,
        desc = "Test file(%)",
      },
      {
        -- Test directory(cwd, files)
        "<leader>tF",
        function()
          require("neotest").run.run(vim.fn.getcwd())
          -- require("neotest").summary.open({ enter = false, auto_close = true })
        end,
        desc = "Test directory(%)",
      },
      {
        -- Test suite(all)
        "<leader>ta",
        function()
          require("neotest").run.run(require("leovim.utils").get_root())
          -- require("neotest").summary.open({ enter = false, auto_close = true })
        end,
        desc = "Test suite",
      },

      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop test",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.attach()
        end,
        desc = "Attach test",
      },
      {
        "<leader>to",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle output_panel",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle summary",
      },
      {
        -- Debug the nearest function test (requires nvim-dap and adapter support)
        -- use <leader>tr to run last debug test as well
        "<leader>td",
        function()
          -- To insure dap is loaded
          -- local loaded = require("lazy.core.loader").loaded["dap"]
          -- set breakpoints first, and then run debug test
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Debug nearest test",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Start/Stop watch %",
      },
      {
        "]e",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "Next test(failed/error)",
      },
      {
        "[e",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "Previous test(failed/error)",
      },
    }
  end,

  opts = function()
    local has_plugin = require("leovim.utils").has_plugin

    return {
      status = { virtual_text = true },
      output = { open_on_run = true },

      quickfix = {
        open = function()
          if has_plugin("trouble.nvim") then
            vim.cmd("Trouble quickfix")
          else
            vim.cmd("copen")
          end
        end,
      },
    }
  end,
}