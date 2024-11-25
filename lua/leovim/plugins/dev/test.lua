return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",

      "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-python",
      -- "nvim-neotest/neotest-vim-test",
      -- "markemmons/neotest-deno"
    },
    keys = function()
      -- local neotest = require("neotest")
      return {
        {
          "<leader>tf",
          function()
            require("neotest").run.run(vim.fn.expand("%"))
          end,
          desc = "File(Test)",
        },
        {
          "<leader>tF",
          function()
            require("neotest").run.run(vim.loop.cwd())
          end,
          desc = "All Files(Test)",
        },
        {
          "<leader>tt",
          function()
            require("neotest").run.run()
          end,
          desc = "Run Test",
        },
        -- T for terminate
        {
          "<leader>tT",
          function()
            require("neotest").run.stop()
          end,
          desc = "Stop Test",
        },
        {
          "<leader>ta",
          function()
            require("neotest").run.attach()
          end,
          desc = "Attach Test",
        },
        {
          "<leader>to",
          function()
            require("neotest").output.open({ enter = true, auto_close = true })
          end,
          desc = "Output(Test)",
        },
        {
          "<leader>tO",
          function()
            require("neotest").output_panel.toggle()
          end,
          desc = "Test Output Panel",
        },
        {
          "<leader>ts",
          function()
            require("neotest").summary.open({ enter = true, auto_close = true })
          end,
          desc = "Test Summary",
        },
        {
          "<leader>tS",
          function()
            require("neotest").summary.toggle()
          end,
          desc = "Test Summary",
        },
        -- i for identify or debug
        {
          "<leader>ti",
          function()
            require("neotest").run.run({ strategy = "dap" })
          end,
          desc = "Debug Test",
        },
      }
    end,
    opts = {
      adapters = {
        ["neotest-go"] = {
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
          if require("lazyvim.util").has("trouble.nvim") then
            vim.cmd("Trouble quickfix")
          else
            vim.cmd("copen")
          end
        end,
      },
    },

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
}
