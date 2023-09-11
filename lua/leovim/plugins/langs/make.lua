return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "cmake" })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "cmake-language-server",
        "cmakelang", -- TODO: config cmakelang
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        cmake = {},
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
        local methods = null_ls.methods

        vim.list_extend(opts.sources, {
          formatting.cmake_format,
          diagnostics.checkmake.with({
            method = methods.DIAGNOSTICS_ON_SAVE,
          }),
        })
      end
    end,
  },
}