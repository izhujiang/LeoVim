return {
  {
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters.
    -- g? for more informatioin in Mason UI
    "williamboman/mason.nvim",
    -- ensure to find language servers, insert vim.stdpath("data")/mason/bin into $PATH dynamically.
    -- so that vim.lsp.enable() can activate lsp servers
    lazy = false,
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
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = require("leovim.builtin.none-ls").keys or {},
    opts = require("leovim.builtin.none-ls").opts or {}, -- once opts is set, default config function will cause none-ls.setup(opts) automatically.
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
    cmd = { "Refactor" },
    opts = {},
  },
}