return {
  -- Portable package manager for Neovim that runs everywhere Neovim runs.
  -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters.
  -- g? for more informatioin in Mason UI
  {
    "williamboman/mason.nvim",
    -- lazy = false, -- load at nvim startup to ensure the language servers to be found, which insert vim.stdpath("data")/mason/bin into $PATH dynamically.
    event = "VeryLazy",
    cmd = "Mason",
    build = ":MasonUpdate",
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
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  -- it is recommended to use other 3rd party plugins to further integrate these packages.
  -- The following plugins are recommended:
  -- -   LSP: `lspconfig` & `mason-lspconfig.nvim`
  -- -   DAP: `nvim-dap`
  -- -   Linters: `null-ls.nvim` or `nvim-lint`
  -- -   Formatters: `null-ls.nvim` or `formatter.nvim`

  {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      { "williamboman/mason.nvim" },
      { "neovim/nvim-lspconfig" },
    },
    config = function()
      -- It's important that you set up the plugins in the following order:
      -- 1) mason.nvim                      -- require("mason").setup()
      -- 2) mason-lspconfig.nvim            -- require("mason-lspconfig").setup()
      -- 3) Setup servers via lspconfig     -- or via handlers, require("lspconfig")[server_name].setup(make_server_opts({}))

      local ensure_installed = {
        "astro",
        "bashls",
        "cmake",
        "cssls",
        "dockerls",
        "gopls",
        "html",
        "jsonls",
        "lua_ls",
        "marksman",
        "pyright",
        "ruff_lsp",
        "rust_analyzer",
        "tailwindcss",
        "taplo",
        "tsserver",
        "yamlls",
      }

      if vim.loop.os_uname().machine ~= "aarch64" then
        vim.list_extend(ensure_installed, { "denols", "clangd" })
      end

      require("mason-lspconfig").setup({
        ensure_installed = {
          "astro",
          "bashls",
          "clangd",
          "cmake",
          -- "cssls",
          "denols",
          "dockerls",
          "gopls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "ruff_lsp",
          "rust_analyzer",
          "tailwindcss",
          "taplo",
          "tsserver",
          "yamlls",
        },
        automatic_installation = false, -- All servers set up via lspconfig are automatically installed.

        -- {handlers} are the functions to be called when that server is ready to be setup.
        handlers = require("leovim.plugins.dev.settings.lsp.handlers"),
      })
    end,
  },

  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
      local ensure_installed = {
        -- "actionlint", -- GitHub Actions workflow file
        "cmakelang",
        "commitlint",
        "editorconfig-checker",
        "eslint_d",
        "flake8",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "gomodifytags",
        "hadolint",
        "impl",
        "jq",
        "misspell",
        "shellcheck",
        "shfmt",
        "stylua",
      }
      if vim.loop.os_uname().machine ~= "aarch64" then
        vim.list_extend(ensure_installed, { "selene" })
      end

      require("mason-null-ls").setup({
        automatic_installation = false, -- disable automatic, due to mason-null-ls missing tools like makecheck in null-ls list
        ensure_installed = ensure_installed,
        -- automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
      })
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    cmd = { "DapInstall", "DapUninstall" },
    config = function()
      require("mason-nvim-dap").setup({
        -- {'python', 'cppdbg', 'delve', 'node2', 'chrome', 'firefox', 'php', 'coreclr', 'js', 'codelldb', 'bash', 'javadbg', 'javatest', 'mock', 'puppet', 'elixir', 'kotlin', 'dart', 'haskell'}
        ensure_installed = {
          "python",
          "delve",
          "codelldb",
          "js",
        },
        automatic_installation = false,

        -- sets up dap in the predefined manner. Provides a dynamic way of setting up sources and any other logic needed;
        handlers = {
          -- config = {
          --   name, -- adapter name
          --   adapters, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/adapters.lua
          --   configurations, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/configurations.lua
          --   filetypes, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/filetypes.lua
          -- },
          function(config)
            -- all sources with no handler get passed here
            -- Keep original functionality
            require("mason-nvim-dap").default_setup(config)
          end,
          -- python = function(config)
          --     config.adapters = {
          --     }
          --     require('mason-nvim-dap').default_setup(config) -- don't forget this!
          -- end,
        },
      })
    end,
  },
}