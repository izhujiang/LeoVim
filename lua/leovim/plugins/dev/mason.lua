return {
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
      "bash-language-server",
      -- "cmake-language-server", -- python 3.12 yes, python 3.13 not supported
      "gopls",
      "marksman",
      "pyright", -- Microsoft
      "ruff-lsp",
      "typescript-language-server",

      -- null-ls (linters, formatters)
      "biome",
      -- "cmakelang",
      "commitlint",
      -- "editorconfig-checker",
      "gofumpt",
      "goimports",
      "golangci-lint",
      "gomodifytags",
      "impl",
      "jq",
      "prettier",
      "black",
      "misspell",
      "shellcheck",
      "shfmt",

      -- dap
      "debugpy",
      "delve",
      "js-debug-adapter",
    }

    if vim.uv.fs_stat("/etc/alpine-release") == nil then
      vim.list_extend(
        lang_servers,
        { "clangd", "deno", "lua-language-server", "rust-analyzer", "selene", "stylua", "codelldb" }
      )
    end

    local os_name = vim.uv.os_uname().sysname
    local arch = vim.uv.os_uname().machine
    if os_name == "Linux" and (arch == "armv7l" or arch == "arm" or arch == "aarch64") then
      vim.print("installl clangd, deno, lua-language-server, rust-analyzer, selene stylua via Mason unsupported")
    else
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
}