return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "bash-language-server",
        "shellcheck",
        "shfmt",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        bashls = {
          filetypes = { "zsh", "bash", "sh" },
        },
      },
    },
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics
        local code_actions = null_ls.builtins.code_actions
        local methods = null_ls.methods

        vim.list_extend(opts.sources, {
          formatting.shfmt,

          diagnostics.shellcheck.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }), -- shell script diagnostics

          code_actions.shellcheck, -- shell script code actions
        })
      end
    end,
  },
}