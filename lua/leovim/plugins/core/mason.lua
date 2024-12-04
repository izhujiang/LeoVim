return {
  {
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters.
    -- g? for more informatioin in Mason UI
    "williamboman/mason.nvim",
    -- lazy = false,
    -- ensure to find language servers, insert vim.stdpath("data")/mason/bin into $PATH dynamically.
    -- event = "VimEnter",
    cmd = "Mason",
    keys = {
      { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" },
    },
    build = ":MasonUpdate",
    opts = function()
      local lang_servers = {
        -- "bash-language-server",
        -- "cmake-language-server", -- python 3.12 yes, python 3.13 not supported
        -- "css-lsp",
        -- "dockerfile-language-server",
        "gopls",
        -- "html-lsp",
        -- "json-lsp",
        "marksman",
        "pyright", -- Microsoft
        "ruff-lsp",
        -- "tailwindcss-language-server",
        -- "taplo",
        "typescript-language-server",
        -- "yaml-language-server",

        -- null-ls (linters, formatters)
        -- "cmakelang",
        "commitlint",
        -- "editorconfig-checker",
        "gofumpt",
        "goimports",
        "golangci-lint",
        "gomodifytags",
        "impl",
        "jq",
        "misspell",
        "shellcheck",
        "shfmt",

        -- dap
        -- "debugpy",
        "delve",
        -- "js-debug-adapter",
      }

      if vim.uv.fs_stat("/etc/alpine-release") == nil then
        vim.list_extend(
          lang_servers,
          { "clangd", "deno", "lua-language-server", "rust-analyzer", "selene", "stylua", "codelldb" }
        )
      end

      return {
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
          ensure_installed = lang_servers,
        },
      }
    end,

    config = function(_, opts)
      require("mason").setup(opts)

      if opts.packages and opts.packages.ensure_installed then
        local mason_util = require("leovim.plugins.util.pkg")
        local ensure_installed = mason_util.ensure_installed
        ensure_installed(opts.packages.ensure_installed)
      end
      -- handle automatic_installation in case missing packages
    end,
  },
}
-- it is recommended to use other 3rd party plugins to further integrate
-- these packages.
-- The following plugins are recommended:
-- -   LSP: `lspconfig` & `mason-lspconfig.nvim`
-- -   DAP: `nvim-dap`
-- -   Linters: `null-ls.nvim` or `nvim-lint`
-- -   Formatters: `null-ls.nvim` or `formatter.nvim`

-- {
--   -- Extension to mason.nvim that makes it easier to use lspconfig with mason.nvim.
--   "williamboman/mason-lspconfig.nvim",
--   event = { "BufReadPost", "BufNewFile" },
--   -- dependencies = {
--   -- { "williamboman/mason.nvim" },
--   -- },
--   opts = {
--     ensure_installed = {
--       "astro",
--       "bashls",
--       "cmake",
--       "clangd",
--       "cssls",
--       "denols",
--       "dockerls",
--       "gopls",
--       "html",
--       "jsonls",
--       "lua_ls",
--       "marksman",
--       "pyright",
--       "ruff_lsp",
--       "rust_analyzer",
--       "tailwindcss",
--       "taplo",
--       "ts_ls",
--       "yamlls",
--     },
--     automatic_installation = false, -- All servers set up via lspconfig are automatically installed.
--
--     -- {handlers} are the functions to be called when that server is ready to be setup.
--     -- handlers = require("leovim.plugins.dev.settings.lsp.handlers"),
--   },

-- config = function()
-- It's important that you set up the plugins in the following order:
-- 1) mason.nvim                      -- require("mason").setup()
-- 2) mason-lspconfig.nvim            -- require("mason-lspconfig").setup()
-- 3) Setup servers via lspconfig     -- or via handlers, require("lspconfig")[server_name].setup(make_server_opts({}))
-- end,
-- },

-- {
--   "jay-babu/mason-null-ls.nvim",
--   enabled = false,
--   event = { "BufReadPost", "BufNewFile" },
--   dependencies = {
--     "williamboman/mason.nvim",
--   },
--   opts = {
--     automatic_installation = false, -- disable automatic, due to mason-null-ls missing tools like makecheck in null-ls list
--     ensure_installed = {
--       "biome",
--       "commitlint",
--       "impl",
--       "gofumpt",
--       "goimports",
--       "golangci-lint",
--       "gomodifytags",
--       "markdownlint",
--       "misspell",
--       "prettier",
--       "selene",
--       "shfmt",
--       "stylua",
--     },
--     -- automatic_installation = { exclude = { "rust_analyzer", "solargraph"
--   },
-- },

-- {
--   "jay-babu/mason-nvim-dap.nvim",
--   event = "VeryLazy",
--   -- dependencies = {
--   -- "williamboman/mason.nvim",
--   -- "mfussenegger/nvim-dap",
--   -- },
--   cmd = { "DapInstall", "DapUninstall" },
--   opts = {
--     -- {'python', 'cppdbg', 'delve', 'node2', 'chrome', 'firefox', 'php',
--     -- 'coreclr', 'js', 'codelldb', 'bash', 'javadbg', 'javatest', 'mock',
--     -- 'puppet', 'elixir', 'kotlin', 'dart', 'haskell'}
--     ensure_installed = {
--       "python",
--       "delve",
--       "codelldb",
--       "js",
--     },
--     automatic_installation = false,
--   }
--   -- config = function()
--   --   require("mason-nvim-dap").setup({
--   --     -- {'python', 'cppdbg', 'delve', 'node2', 'chrome', 'firefox', 'php', 'coreclr', 'js', 'codelldb', 'bash', 'javadbg', 'javatest', 'mock', 'puppet', 'elixir', 'kotlin', 'dart', 'haskell'}
--   --     ensure_installed = {
--   --       "python",
--   --       "delve",
--   --       "codelldb",
--   --       "js",
--   --     },
--   --     automatic_installation = false,
--   --
--   --     -- sets up dap in the predefined manner. Provides a dynamic way of setting up sources and any other logic needed;
--   --     handlers = {
--   --       -- config = {
--   --       --   name, -- adapter name
--   --       --   adapters, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/adapters.lua
--   --       --   configurations, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/configurations.lua
--   --       --   filetypes, -- https://github.com/jay-babu/mason-nvim-dap.nvim/blob/main/lua/mason-nvim-dap/mappings/filetypes.lua
--   --       -- },
--   --       function(config)
--   --         -- all sources with no handler get passed here
--   --         -- Keep original functionality
--   --         require("mason-nvim-dap").default_setup(config)
--   --       end,
--   --       -- python = function(config)
--   --       --     config.adapters = {
--   --       --     }
--   --       --     require('mason-nvim-dap').default_setup(config) -- don't forget this!
--   --       -- end,
--   --     },
--   --   })
--   -- end,
-- }
-- },