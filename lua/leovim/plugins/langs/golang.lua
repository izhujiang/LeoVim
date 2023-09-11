return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "go",
        "gomod",
        "gowork",
        "gosum",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gopls",   -- lsp
        "gofumpt", -- formators and linters
        "goimports",
        "golangci-lint",
        "gomodifytags",
        "impl",
        "delve", -- debugger adapter
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                fieldalignment = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = false,
              -- semanticTokens = true,
            },
          },
        },
      },
      setup = {},
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local nls = require("null-ls")
        vim.list_extend(opts.sources, {
          nls.builtins.formatting.gofumpt,
          nls.builtins.formatting.goimports_reviser,
          nls.builtins.code_actions.gomodifytags,
          nls.builtins.code_actions.impl,
        })
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    opts = {
      adapters = {
        delve = {
          type = 'server',
          port = '${port}',
          executable = {
            command = 'dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}' },
          }
        },
      },
      configurations = {
        go = {
          {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${file}"
          },
          {
            type = "delve",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}"
          },
          -- works with go.mod packages and sub packages
          {
            type = "delve",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
          }
        },
      },
    }
  },


  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-go",
    },
    opts = {
      adapters = {
        ["neotest-go"] = {
          -- args = { "-tags=integration" }
        },
      }
    }
  }

}
