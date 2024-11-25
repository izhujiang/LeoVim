-- install all packages ensure_installed
local M = {
}

local _packages_ensure_installed = {}

-- packages = {
--   automatic_installation = false,
--   ensure_installed = {
--     -- lsp servers
--     "astro-language-server",
--     "bash-language-server",
--     "clangd",
--     "cmake-language-server",
--     "css-lsp",
--     "deno",
--     "dockerfile-language-server",
--     "gopls",
--     "html-lsp",
--     "json-lsp",
--     "lua-language-server",
--     "marksman",
--     "pyright",
--     "ruff-lsp",
--     "rust-analyzer",
--     "tailwindcss-language-server",
--     "taplo",
--     "typescript-language-server",
--     "yaml-language-server",
--
--     -- null-ls (linters, formatters)
--     "cmakelang",
--     "commitlint",
--     "editorconfig-checker",
--     "eslint_d",
--     "flake8",
--     "gofumpt",
--     "goimports",
--     "golangci-lint",
--     "gomodifytags",
--     "hadolint",
--     "impl",
--     "jq",
--     "misspell",
--     "selene",
--     "shellcheck",
--     "shfmt",
--     "stylua",
--
--     -- dap
--     "debugpy",
--     "delve",
--     "codelldb",
--     "js-debug-adapter",
--   },
-- }
-- ref: mason-lspconfig/mappings/server.lua
-- lspconfig_to_package = {

local notify = function(msg, level)
  level = level or vim.log.levels.INFO
  vim.notify(msg, level, {
    title = "mason.nvim",
  })
end

local registry = require("mason-registry")

-- ---@param lspconfig_server_name string
-- local function resolve_package(lspconfig_server_name)

local function resolve_package(package_name)
  local Optional = require "mason-core.optional"
  -- local server_mapping = require "mason-lspconfig.mappings.server"

  return Optional.of_nilable(package_name):map(function(pkg_name)
    local ok, pkg = pcall(registry.get_package, pkg_name)
    if ok then
      return pkg
    end
  end)
end

local function ensure_installed()
  local Package = require "mason-core.package"
  for _, pkg_identifier in ipairs(_packages_ensure_installed) do
    local pkg_name, version = Package.Parse(pkg_identifier)
    resolve_package(pkg_name)
        :if_present(
          function(pkg)
            if not pkg:is_installed() then
              pkg:install({ version = version }):once(
                "closed",
                vim.schedule_wrap(function()
                  if pkg:is_installed() then
                    notify(("[mason.nvim] %s was successfully installed"):format(pkg_name))
                  else
                    notify(
                      ("[mason.nvim] failed to install %s. Installation logs are available in :Mason and :MasonLog")
                      :format(
                        pkg_name
                      ),
                      vim.log.levels.ERROR
                    )
                  end
                end)
              )
            end
          end
        )
        :if_not_present(function()
          notify(
            ("[mason.nvim] %q is not a valid entry in ensure_installed. Make sure to only provide valid package names.")
            :format(
              pkg_name
            ),
            vim.log.levels.WARN
          )
        end)
  end
end


function M.ensure_installed(packages)
  vim.list_extend(_packages_ensure_installed, packages)

  if registry.refresh then
    registry.refresh(vim.schedule_wrap(ensure_installed))
  else
    ensure_installed()
  end
end

return M
