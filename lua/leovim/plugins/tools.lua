return {
  {
    -- Portable package manager for Neovim that runs everywhere Neovim runs.
    -- Easily install and manage (external editor toolkits) such as LSP servers, DAP servers, linters, and formatters.
    -- g? for more informatioin in Mason UI
    "williamboman/mason.nvim",
    -- DON'T be lazy load, insert vim.stdpath("data")/mason/bin into $PATH dynamically,
    -- ensure nvim to find and activate (vim.lsp.enable) language servers.
    lazy = false,
    build = ":MasonUpdate",
    cmd = "Mason",
    keys = require("leovim.config.plugins.nvim-mason").keys or {},
    opts = require("leovim.config.plugins.nvim-mason").opts or {},
  },
  {
    -- Install and upgrade third party tools automatically via mason.nivm
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = {
      "MasonToolsInstall",
      "MasonToolsInstallSync",
      "MasonToolsUpdate",
      "MasonToolsUpdateSync",
      "MasonToolsClean",
    },

    opts = {
      -- DON'T try to install any redundant lsp, dap, linter and formatter via mason.nvim, which have been already install globally.
      ensure_installed = vim.g.tools_ensure_installed,
    },
  },
}
