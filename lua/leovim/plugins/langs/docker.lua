return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "dockerfile" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "dockerfile-language-server",
        -- "docker_compose_language_service",
        "hadolint",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
      },
      setup = {},
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
          diagnostics.hadolint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        })
      end
    end,
  },
}