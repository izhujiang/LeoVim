return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "python",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "pyright", -- lsp
        "ruff-lsp",
        "flake8",  -- linter
        "debugpy", -- debugger adapter
      })
    end,
  },

  -- TODO: config ruff_lsp
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "off",
              },
            },
          },
        },
      },
      setup = {
        -- ruff_lsp = require("leovim.util").on_attach(function(client, _)
        --   if client.name == "ruff_lsp" then
        --     -- Disable hover in favor of Pyright
        --     client.server_capabilities.hoverProvider = false
        --   end
        -- end),
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        local diagnostics = null_ls.builtins.diagnostics
        local methods = null_ls.methods

        vim.list_extend(opts.sources, {
          diagnostics.flake8.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        })
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    -- dependencies = {
    --   "mfussenegger/nvim-dap-python",
    -- },
    opts = {
      adapters = {
        python = function(cb, config)
          if config.request == 'attach' then
            local port = (config.connect or config).port
            local host = (config.connect or config).host or '127.0.0.1'
            cb({
              type = 'server',
              port = assert(port, '`connect.port` is required for a python `attach` configuration'),
              host = host,
              options = {
                source_filetype = 'python',
              },
            })
          else
            cb({
              type = 'executable',
              command = 'python',
              -- command = 'path_pathon',
              args = { '-m', 'debugpy.adapter' },
              options = {
                source_filetype = 'python',
              },
            })
          end
        end,
      },
      configurations = {
        python = {
          {
            -- The first three options are required by nvim-dap
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = function()
              -- TODO: return different python according user's choice
              -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
              local cwd = vim.fn.getcwd()
              if vim.fn.executable(cwd .. '/.pyenv/shims/python') == 1 then
                return cwd .. '/.pyenv/shims/python'
              else
                return '/usr/bin/python'
              end
            end,
          },
        },
      },
    }
  },

  -- {
  --   "mfussenegger/nvim-dap-python",
  --   keys = {
  --     { "<leader>dT", function() require('dap-python').test_method() end, desc = "Debug Method(Python)" },
  --     { "<leader>dc", function() require('dap-python').test_class() end,  desc = "Debug Class(Python)" },
  --   },
  --   config = function()
  --     -- TODO: setup dap-python path
  --     local path = require("mason-registry").get_package("debugpy"):get_install_path()
  --     require("dap-python").setup(path .. "/venv/bin/python")
  --   end,
  -- },
  -- { ruby only
  --   "suketa/nvim-dap-ruby",
  --   config = function()
  --     require("dap-ruby").setup()
  --   end,
  -- }
  -- {
  -- DAPInstall.nvim is a NeoVim plugin written in Lua that extends nvim-dap's functionality for managing various debuggers. Everything from installation, configuration, setup, etc.
  -- "ravenxrz/DAPInstall.nvim",
  -- }

  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          -- runner = "pytest",
          -- python = ".venv/bin/python",
        },
      }
    }
  }
}
