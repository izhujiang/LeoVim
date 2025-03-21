return {
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
  keys = function()
    -- local neotest = require("neotest")
    return {
      {
        -- Test single (nearest) function
        "<leader>tf",
        function()
          require("neotest").run.run()
        end,
        desc = "function",
      },
      {
        "<leader>tr",
        function()
          require("neotest").run.run_last()
        end,
        desc = "last(recent)",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "file(%)",
      },
      {
        -- Test directory(cwd, files)
        "<leader>tT",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "directory(%)",
      },
      {
        -- Test suite
        "<leader>tS",
        function()
          -- TODO: get project root path
          --`require('neotest').run.run("path/to/root_project")`
          vim.notify("TODO: call neotest to run run(path/to/root_project)")
        end,
        desc = "suite",
      },

      {
        -- test race
        "<leader>tR",
        function()
          -- Additional arguments for the go test command can be sent using the `extra_args` field e.g.
          -- require("neotest").run.run({ path, extra_args = { "-race" } })
          vim.notify("TODO: run go test -race")
        end,
        desc = "suite",
      },
      {
        -- halt/stop
        "<leader>th",
        function()
          require("neotest").run.stop()
        end,
        desc = "halt/stop",
      },
      {
        "<leader>tA",
        function()
          require("neotest").run.attach()
        end,
        desc = "attach",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "output",
      },
      {
        "<leader>uto",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "output_panel",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.open({ enter = true, auto_close = true })
        end,
        desc = "summary",
      },
      {
        "<leader>uts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "summary",
      },
      -- i for identify or debug
      {
        "<leader>td",
        function()
          require("neotest").run.run({ strategy = "dap" })
        end,
        desc = "debug",
      },
      {
        "<leader>tw",
        function()
          require("neotest").watch.watch(vim.fn.expand("%"))
        end,
        desc = "watch %",
      },
      {
        "<leader>utw",
        function()
          require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "watch %",
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
    local has_plugin = require("leovim.core").has_plugin

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
}