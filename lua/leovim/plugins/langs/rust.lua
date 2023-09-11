return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "rust-analyzer",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          keys = {
            {
              "K",
              "<cmd>RustHoverActions<cr>",
              desc = "Hover Actions (Rust)",
            },
            {
              "<leader>cR",
              "<cmd>RustCodeAction<cr>",
              desc = "Code Action (Rust)",
            },
            {
              "<leader>dr",
              "<cmd>RustDebuggables<cr>",
              desc = "Run Debuggables (Rust)",
            },
          },
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                runBuildScripts = true,
              },
              -- Add clippy lints for Rust.
              checkOnSave = {
                allFeatures = true,
                command = "clippy",
                extraArgs = { "--no-deps" },
              },
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },
            },
          },
        },
      },
      setup = {
        rust_analyzer = function(_, opts)
          local rust_tools_opts = require("leovim.util").opts("rust-tools.nvim")
          require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))
        end,
      },
    },
  },

  {
    "simrat39/rust-tools.nvim",
    ft = { "rust" },
  },
}