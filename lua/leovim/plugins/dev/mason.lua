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
    keys = {
      { "<leader>Im", "<cmd>Mason<cr>", desc = "Mason" },
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

      ensure_installed = {
        "commitlint",
        "editorconfig-checker",
        "misspell",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)

      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -- it is recommended to use other 3rd party plugins to further integrate these packages.
  -- The following plugins are recommended:
  -- -   LSP: `lspconfig` & `mason-lspconfig.nvim`
  -- -   DAP: `nvim-dap`
  -- -   Linters: `null-ls.nvim` or `nvim-lint`
  -- -   Formatters: `null-ls.nvim` or `formatter.nvim`

  -- {
  --   "williamboman/mason-lspconfig.nvim",
  --   -- event = { "BufReadPost", "BufNewFile" }, -- Important: right time to load and config lsp. config function is executed when the plugin loads.
  --   dependencies = {
  --     { "williamboman/mason.nvim" },
  --     { "neovim/nvim-lspconfig" },
  --   },
  --   config = function()
  --     -- It's important that you set up the plugins in the following order:
  --     -- 1) mason.nvim                      -- require("mason").setup()
  --     -- 2) mason-lspconfig.nvim            -- require("mason-lspconfig").setup()
  --     -- 3) Setup servers via lspconfig     -- or via handlers, require("lspconfig")[server_name].setup(make_server_opts({}))

  --     require("mason-lspconfig").setup({
  --       ensure_installed = {
  --         -- "solargraph",
  --       },
  --       automatic_installation = false, -- All servers set up via lspconfig are automatically installed.
  --       handlers = require("leovim.plugins.dev.settings.lsp.handlers"),
  --     })

  --     -- TODO: disable tsserver or denols (https://www.lazyvim.org/plugins/lsp)
  --     -- if Util.lsp_get_config("denols") and Util.lsp_get_config("tsserver") then
  --     --   local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")zend xjfnc,m[pl;,.]
  --     --   Util.lsp_disable("tsserver", is_deno)
  --     --   Util.lsp_disable("denols", function(root_dir)
  --     --     return not is_deno(root_dir)
  --     --   end)
  --     -- end
  --   end
  -- },

  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   -- event = { "BufReadPost", "BufNewFile" }, -- Important: right time to load and config lsp. config function is executed when the plugin loads.
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "jose-elias-alvarez/null-ls.nvim",
  --   },
  --   config = function()
  --     require("mason-null-ls").setup({
  --       ensure_installed = {},
  --       automatic_installation = false, -- disable automatic, due to mason-null-ls missing tools like makecheck in null-ls list
  --       -- automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
  --     })
  --   end,
  -- },

  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   -- event = "VeryLazy",
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     "mfussenegger/nvim-dap",
  --   },
  --   cmd = { "DapInstall", "DapUninstall" },
  --   config = function()
  --     require("mason-nvim-dap").setup({
  --       -- {'python', 'cppdbg', 'delve', 'node2', 'chrome', 'firefox', 'php', 'coreclr', 'js', 'codelldb', 'bash', 'javadbg', 'javatest', 'mock', 'puppet', 'elixir', 'kotlin', 'dart', 'haskell'}
  --       ensure_installed = {
  --         "python",
  --         "delve",
  --         "codelldb",
  --         "js",
  --       },
  --       automatic_installation = false,

  --       handlers = {}, -- sets up dap in the predefined manner. Provides a dynamic way of setting up sources and any other logic needed;
  --     })
  --   end,
  -- },
}