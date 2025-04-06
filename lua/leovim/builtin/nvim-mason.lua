return {
  keys = {
    { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" },
  },

  opts = {
    ui = {
      check_outdated_packages_on_open = false,
      border = "none",
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,

    pip = {
      upgrade_pip = true,
    },
    packages = {
      -- DON'T try to install any redundant lsp, dap, linter and formatter via mason.nvim, which have been already install globally.
      ensure_installed = {
        -- "bash-language-server",
        -- "clangd",
        -- "cmake-language-server", -- python 3.12 yes, python 3.13 not supported
        -- "deno",
        -- "gopls",
        -- "lua-language-server",
        "marksman",
        -- "pyright", -- Microsoft
        -- "rust-analyzer",
        -- "ruff-lsp",
        -- "typescript-language-server",

        -- null-ls (linters, formatters)
        -- "biome",
        -- "cmakelang",
        -- "commitlint",
        -- "editorconfig-checker",
        -- "gofumpt",
        -- "golangci-lint",
        -- "gomodifytags",
        -- "impl",
        "json-lsp",
        -- "misspell",
        -- "shellcheck",
        -- "shfmt",
        -- "selene",
        -- "stylua",
        --
        -- dap
        -- "debugpy",
        -- "delve",
        "js-debug-adapter",
        -- "codelldb",
      },
    },
  },
}