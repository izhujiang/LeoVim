return {
  {
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters.
    -- g? for more informatioin in Mason UI
    "williamboman/mason.nvim",
    -- lazy = false,
    -- ensure to find language servers, insert vim.stdpath("data")/mason/bin into $PATH dynamically.
    -- event = "VimEnter",
    build = ":MasonUpdate",
    cmd = "Mason",
    keys = require("leovim.builtin.nvim-mason").keys or {},
    opts = require("leovim.builtin.nvim-mason").opts or {},

    config = function(_, opts)
      require("mason").setup(opts)

      -- install packages automatically.
      local _packages_ensure_installed = {}
      local registry = require("mason-registry")

      local function resolve_package(package_name)
        local Optional = require("mason-core.optional")
        -- local server_mapping = require "mason-lspconfig.mappings.server"

        return Optional.of_nilable(package_name):map(function(pkg_name)
          local ok, pkg = pcall(registry.get_package, pkg_name)
          if ok then
            return pkg
          end
        end)
      end

      local ensure_installed = function()
        local Package = require("mason-core.package")
        for _, pkg_identifier in ipairs(_packages_ensure_installed) do
          local pkg_name, version = Package.Parse(pkg_identifier)
          resolve_package(pkg_name)
            :if_present(function(pkg)
              if not pkg:is_installed() then
                pkg:install({ version = version }):once(
                  "closed",
                  vim.schedule_wrap(function()
                    if pkg:is_installed() then
                      vim.notify(("[mason.nvim] %s was successfully installed"):format(pkg_name))
                    else
                      vim.notify(
                        ("[mason.nvim] failed to install %s. Installation logs are available in :Mason and :MasonLog"):format(
                          pkg_name
                        ),
                        vim.log.levels.ERROR
                      )
                    end
                  end)
                )
              end
            end)
            :if_not_present(function()
              vim.notify(
                ("[mason.nvim] %q is not a valid entry in ensure_installed. Make sure to only provide valid package names."):format(
                  pkg_name
                ),
                vim.log.levels.WARN
              )
            end)
        end
      end

      if opts.packages and opts.packages.ensure_installed then
        vim.list_extend(_packages_ensure_installed, opts.packages.ensure_installed)

        if registry.refresh then
          registry.refresh(vim.schedule_wrap(ensure_installed))
        else
          ensure_installed()
        end
      end
      -- TODO: handle automatic_installation in case missing packages
    end,
  },
  {
    -- Quickstart configs for Nvim LSP
    -- nvim-lspconfig providing basic, default Nvim LSP client configurations for various LSP servers.
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6
    dependencies = {
      "williamboman/mason.nvim", -- ensure lsp servers has been installed. and mason/bin directory added to $PATH
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = require("leovim.builtin.nvim-lspconfig").keys or {},
    opts = require("leovim.builtin.nvim-lspconfig").opts or {},

    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local lsp_server = require("leovim.builtin.lsp.server")

      -- TODO: config server dynamically.
      local servers = { "lua_ls", "gopls", "clangd", "pyright", "rust_analyzer", "bashls", "cmake" }
      for _, server_name in ipairs(servers) do
        -- hook_setup_before()
        local lsp_server_conf = lsp_server.make_config(server_name, {})
        lspconfig[server_name].setup(lsp_server_conf)
        -- hook_setup_after()
      end

      local lsp_client = require("leovim.builtin.lsp.client")
      lsp_client.setup(opts)
    end,
  },

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "nvimtools/none-ls.nvim",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = require("leovim.builtin.none-ls").keys or {},
    opts = require("leovim.builtin.none-ls").opts or {},
  },

  -- The Refactoring library based off the Refactoring book by Martin Fowler
  -- Refactoring Features, Support for various common refactoring operations: Extract/Inline Function/Variable
  -- Debug Features, useful features for debugging(Printf, Print var, Cleanup)
  -- usage:
  --   '<,'>:Refactor operation
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}