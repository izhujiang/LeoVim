return {
  "nvim-tree/nvim-tree.lua",
  enable = false,
  -- Lazy loading is not recommended. nvim-tree setup is very inexpensive,
  -- doing little more than validating and setting configuration.
  -- There's no performance benefit for lazy loading.
  -- Lazy loading can be problematic due to the somewhat nondeterministic
  -- startup order of plugins, session managers, netrw, "VimEnter" event etc.
  -- lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = { "NvimTreeOpen", "NvimTreeToggle", "NvimTreeFindFile" },
  keys = {
    {
      "<leader>ue",
      "<cmd>NvimTreeToggle<cr>",
      desc = "explorer",
    },
  },
  init = function()
    -- disable netrw at the very start of init.lua
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    -- optionally enable 24-bit colour
    vim.opt.termguicolors = true
  end,

  opts = {
    -- on_attach = "default",
    -- sync_root_with_cwd = true,
    -- respect_buf_cwd = true,
    -- update_focused_file = {
    --   enable = true,
    --   update_root = true,
    -- },
    -- sort = { sorter = "case_sensitive", },
    -- view = { width = 30, },
    -- renderer = { group_empty = true, },
    -- filters = { dotfiles = true, },
    diagnostics = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
      debounce_delay = 50,
      severity = {
        min = vim.diagnostic.severity.HINT,
        max = vim.diagnostic.severity.ERROR,
      },
    },
    modified = {
      enable = true,
      show_on_dirs = true,
      show_on_open_dirs = true,
    },
    -- filesystem_watchers = {
    --   enable = true,
    --   ignore_dirs = {
    --     "/.ccls-cache",
    --     "/build",
    --     "/node_modules",
    --     "/target",
    --   },
    -- },
  },
}