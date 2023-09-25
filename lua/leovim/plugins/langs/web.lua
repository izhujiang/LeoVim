return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css",
        "html",
        "javascript",
        "typescript",
        "tsx",
      })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    ft = {
      "html",
      "javascript",
      "jsx",
      "tsx",
      "typescript",
      "xml",
    },
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "css-lsp",
        "html-lsp",
        "deno",
        "typescript-language-server",
        "eslint_d",
        "js-debug-adapter", -- debugger adapter
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          keys = {
            { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
          root_dir = require("lspconfig").util.root_pattern("package.json"),
          single_file_support = false,
        },
        denols = {
          settings = {
            {
              deno = {
                enable = true,
                suggest = {
                  imports = {
                    hosts = {
                      ["https://crux.land"] = true,
                      ["https://deno.land"] = true,
                      ["https://x.nest.land"] = true,
                    },
                  },
                },
              },
            },
          },
          root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
        },
      },
      setup = {},
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local methods = null_ls.methods

      if type(opts.sources) == "table" then
        vim.list_extend(opts.sources, {
          formatting.deno_fmt.with({
            condition = function(utils)
              return utils.root_has_file({ "deno.jsonc", "deno.json" })
            end,
          }),

          formatting.eslint_d.with({
            condition = function(utils)
              return utils.root_has_file({ "package.json" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
            timeout = 1000,
          }),

          diagnostics.deno_lint.with({
            condition = function(utils)
              return utils.root_has_file({ "deno.jsonc", "deno.json" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),

          diagnostics.tsc.with({
            condition = function(utils)
              return utils.root_has_file({ "tsconfig.json" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        })
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    opts = function(_, opts)
      opts.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          -- 💀 Make sure to update this path to point to your installation
          args = function()
            return {
              require("mason-registry").get_package("js-debug-adapter"):get_install_path()
                .. "/js-debug/src/dapDebugServer.js",
              "${port}",
            }
          end,
        },
      }
      opts.configurations.typescript = {
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
      }
    end,
  },
}