return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "toml",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "taplo",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        taplo = {
          keys = {
            {
              "K",
              function()
                if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
                  require("crates").show_popup()
                else
                  vim.lsp.buf.hover()
                end
              end,
              desc = "Show Crate Documentation",
            },
          },
        },
      },
    },
  },

  -- {
  --   "jose-elias-alvarez/null-ls.nvim",
  --   opts = function(_, opts)
  --     if type(opts.sources) == "table" then
  --       local null_ls = require("null-ls")
  --       local formatting = null_ls.builtins.formatting

  --       vim.list_extend(opts.sources, {
  --         formatting.taplo,
  --       })
  --     end
  --   end,
  -- },
}