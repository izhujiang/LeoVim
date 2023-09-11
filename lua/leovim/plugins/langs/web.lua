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
        "css-lsp", -- lsp
        "html-lsp",
        -- "denols",
        "typescript-language-server", -- confix with denols
        "rome",                       -- linter
        "js-debug-adapter",           -- debugger adapter
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
            { "<leader>cR", "<cmd>TypescriptRenameFile<CR>",      desc = "Rename File" },
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
        },
      },
      setup = {},
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local null_ls = require("null-ls")
      local formatting = null_ls.builtins.formatting
      local diagnostics = null_ls.builtins.diagnostics
      local methods = null_ls.methods
      return {
        sources = {
          -- formatting.deno_fmt.with({
          --   condition = function(utils) -- ndicating whether null-ls should register the source.
          --     return utils.root_has_file({ "deno.jsonc" })
          --   end,
          -- }),

          formatting.rome.with({
            filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json" },
            -- To prefer using a local executable for a built-in. This will cause null-ls to search upwards from the current buffer's directory,
            -- try to find a local executable at each parent directory, and fall back to a global executable if it can't find one locally.
            prefer_local = "node_modules/.bin",
            timeout = 1000,
          }),

          -- diagnostics.deno_lint.with({
          --   condition = function(utils)
          --     return utils.root_has_file({ "deno.jsonc" })
          --   end,
          --   method = methods.DIAGNOSTICS_ON_SAVE,
          -- }),

          diagnostics.tsc.with({
            condition = function(utils)
              return not utils.root_has_file({ "deno.jsonc" })
            end,
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        },
      }
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
          end
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
    end
  }
}
