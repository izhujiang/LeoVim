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
        end,
        desc = "Test file(%)",
      },
      {
        -- Test directory(cwd, files)
        "<leader>tF",
        function()
          require("neotest").run.run(vim.fn.getcwd())
        end,
        desc = "Test directory(%)",
      },
      {
        -- Test suite
        "<leader>tS",
        function()
          require("neotest").run.run(require("leovim.utils").get_root())
        end,
        desc = "Test suite",
      },

      {
        -- test race
        "<leader>tR",
        function()
          -- Additional arguments for the go test command can be sent using the `extra_args` field e.g.
          -- require("neotest").run.run({ path, extra_args = { "-race" } })
          vim.notify("TODO: run go test -race")
        end,
        desc = "Test race",
      },
      {
        -- halt/stop
        "<leader>th",
        function()
          require("neotest").run.stop()
        end,
        desc = "Halt/stop test",
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
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Output test",
      },
      {
        "<leader><leader>o",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle test output_panel",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.open({ enter = true, auto_close = true })
        end,
        desc = "Test summary",
      },
      {
        "<leader><leader>S",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle test summary",
      },
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "Test debug",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.watch(vim.fn.expand("%"))
        end,
        desc = "Test watch %",
      },
      {
        "<leader><leader>w",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Toogle test watch(%)",
      },
      {
        -- TODO: if neotest has not run, call vim.cmd.tnext (for tags) indead
        "]t",
        function()
          require("neotest").jump.next({ status = "failed" })
        end,
        desc = "test",
      },
      {
        "[t",
        function()
          require("neotest").jump.prev({ status = "failed" })
        end,
        desc = "test",
      },
    }
  end,

  opts = function()
    local has_plugin = require("leovim.utils").has_plugin

    return {
      adapters = {
        ["neotest-go"] = {
          experimental = {
            test_table = true,
          },
          -- provide more arguments to `go test` command if necessary
          -- args = { "-count=1", "-timeout=60s" },
          -- args = { "-tags=integration" }
        },
        ["neotest-python"] = {
          --   -- runner = "pytest",
          --   -- python = ".venv/bin/python",
        },
      },
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