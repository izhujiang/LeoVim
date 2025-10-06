return {
  keys = {
    { "<leader>zm", "<cmd>Mason<cr>", desc = "Mason" },
  },

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
}
