return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "vim",
          "vimdoc",
        })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "vim-language-server",
        "vint",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vimls = {},
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
          diagnostics.vint.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        })
      end
    end,
  },
}