return {
  {
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters through a single interface.
    -- Packages are installed in Neovim's data directory (:h standard-path) by default.
    -- :checkhealth mason
    -- g? for more informatioin in Mason UI
    --
    "williamboman/mason.nvim",
    lazy = false, -- load at nvim startup to ensure the language servers to be found, which insert vim.stdpath("data")/mason/bin into $PATH dynamically.
    -- cmd = "Mason",
    -- event = "VimEnter",
    build = ":MasonUpdate",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          "neovim/nvim-lspconfig",
          "hrsh7th/cmp-nvim-lsp",

          "p00f/clangd_extensions.nvim",
          "simrat39/rust-tools.nvim",
          "jose-elias-alvarez/typescript.nvim"
        }
      },
      {
        "jay-babu/mason-null-ls.nvim",
        dependencies = {
          "jose-elias-alvarez/null-ls.nvim",
        },
      },
      {
        "jay-babu/mason-nvim-dap.nvim",
        cmd = { "DapInstall", "DapUninstall" },
      },
    },
    opts = {
      ui = {
        check_outdated_packages_on_open = false,
        border = "none",
        -- width = 0.8,
        -- height = 0.9,
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,

      -- registries = { 																-- The registries to source packages from. Accepts multiple entries.
      --       "github:mason-org/mason-registry",
      --   },

      --   -- The provider implementations to use for resolving supplementary package metadata (e.g., all available versions).
      -- Accepts multiple entries, where later entries will be used as fallback should prior providers fail.
      -- providers = {   																-- Builtin providers
      --     "mason.providers.registry-api",						-- uses the https://api.mason-registry.dev API
      --     "mason.providers.client",									-- uses only client-side tooling to resolve metadata
      -- },

      -- github = {																			-- The template URL to use when downloading assets from GitHub.
      --     download_url_template = "https://github.com/%s/releases/download/%s/%s",
      -- },

      pip = {
        upgrade_pip = true,
        -- args to be added to `pip install` calls. (NOT recommended)
        -- Example: { "--proxy", "https://proxyserver" }
        -- install_args = {},
      },
    },
    config = function(_, opts)
      -- It's important that you set up the plugins in the following order:
      -- 1) mason.nvim
      -- 2) mason-lspconfig.nvim
      -- 3) Setup servers via lspconfig

      require("mason").setup(opts)
      require("mason-lspconfig").setup({
        ensure_installed = {
          "bashls",
          "clangd",
          "cssls",
          -- "denols",
          "dockerls",
          -- "docker_compose_language_service",
          "gopls",
          "html",
          "jsonls",
          "lua_ls",
          "marksman",
          "pyright",
          "ruff_lsp",
          "solargraph",
          "taplo",
          "tsserver", -- confix with denols
          "vimls",
          "yamlls",
        },
        automatic_installation = false, -- All servers set up via lspconfig are automatically installed.
        handlers = require("leovim.plugins.dev.settings.lsp.handlers"),
        -- handlers = handlers
      })


      -- TODO: disable denols or tsserver depending on has("deno.json/deno.jsonc")
      -- if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
      --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
      --   Util.lsp_disable("tsserver", is_deno)
      --   Util.lsp_disable("denols", function(root_dir)
      --     return not is_deno(root_dir)
      --   end)
      -- end

      require("mason-null-ls").setup({
        -- Opt to list sources here, when available in mason.
        ensure_installed = {
          "black",
          "actionlint",
          "cmakelang",
          "commitlint",
          "editorconfig-checker",
          "flake8",
          "gofumpt",
          "goimports",
          "golangci-lint",
          "gomodifytags",
          "hadolint",
          "impl",
          "jq",
          "misspell",
          "rome",
          "shfmt",
          "selene",
          "stylua",
          "shellcheck",
          "vint",
        },
        automatic_installation = false, -- disable automatic, due to mason-null-ls missing tools like makecheck in null-ls list
        -- automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
      })

      require("mason-nvim-dap").setup({
        -- {'python', 'cppdbg', 'delve', 'node2', 'chrome', 'firefox', 'php', 'coreclr', 'js', 'codelldb', 'bash', 'javadbg', 'javatest', 'mock', 'puppet', 'elixir', 'kotlin', 'dart', 'haskell'}
        ensure_installed = {
          "python",
          "delve",
          "codelldb",
          "js",
        },
        automatic_installation = false,

        handlers = {}, -- sets up dap in the predefined manner. Provides a dynamic way of setting up sources and any other logic needed;
      })
    end,
  },

  -- Although many packages are perfectly usable out of the box through Neovim
  -- builtins, it is recommended to use other 3rd party plugins to further
  -- integrate these. The following plugins are recommended:

  -- -   LSP: `lspconfig` & `mason-lspconfig.nvim`
  -- -   DAP: `nvim-dap`
  -- -   Linters: `null-ls.nvim` or `nvim-lint`
  -- -   Formatters: `null-ls.nvim` or `formatter.nvim`
}
