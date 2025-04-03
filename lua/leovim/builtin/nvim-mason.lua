return {
  keys = {
    { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" },
  },
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
}