local function register(opts)
  opts.user_plugins = opts.user_plugins or "user.plugins"

  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(lazypath) then
    -- bootstrap lazy.nvim
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable",
      lazypath,
    })
  end
  vim.opt.rtp:prepend(vim.env.LAZY or lazypath)

  -- Make sure to set `mapleader` in config before lazy so your mappings are correct
  require("leovim.config").setup({})

  -- setup lazy.nvim
  require("lazy").setup({
    spec = {
      { import = "leovim.plugins.core" },
      { import = "leovim.plugins.dev" },
      { import = "leovim.plugins.extra.coding" },
      { import = "leovim.plugins.extra.ui" },
      { import = "leovim.plugins.extra.misc" },
      -- import any extras modules here
      { import = opts.user_plugins },
    },
    defaults = {
      lazy = true,
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      -- version = false, -- always use the latest git commit
      version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = { colorscheme = { "tokyonight", "habamax" } },
    ui = {
      -- size = {
      -- 	width = 1,
      -- 	height = 1,
      -- },
      border = "single",
    },
    -- dev = {
    -- 	-- directory where you store your local plugin projects
    -- 	path = "~/projects",
    -- 	---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    -- 	patterns = {}, -- For example {"folke"}
    -- 	fallback = false, -- Fallback to git when local plugin doesn't exist
    -- },
    checker = {
      enabled = false,
      frequency = 604800, -- check for updates every week 60*60*24*7
    },                    -- automatically check for plugin updates
    performance = {
      rtp = {
        -- disable some rtp plugins
        disabled_plugins = {
          "gzip",
          -- "matchit",
          -- "matchparen",
          "netrwPlugin",
          "tarPlugin",
          "tohtml",
          "tutor",
          "zipPlugin",
        },
      },
    },
  })
end

-- nvim entry point
register({ user_plugins = "user.plugins" })