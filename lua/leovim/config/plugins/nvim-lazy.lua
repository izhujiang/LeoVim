return {
  opts = {
    -- update & upgrade (add, replace and delele) plugins, ref https: //www.lazyvim.org/news
    -- spec = nil,
    defaults = {
      -- set this to `true` to have all your plugins lazy-loaded by default.
      lazy = true,
      -- the latest stable version for plugins that support semver
      version = "*",
    },
    install = {
      -- install missing plugins on startup.
      missing = true,
      -- colorscheme that will be used when installing plugins.
      colorscheme = { "habamax" },
    },
    ui = {
      border = "single",
      icons = require("leovim.config.icons").lazy,
    },
    custom_keys = nil,
    -- dev = {
    -- 	-- directory where you store your local plugin projects
    -- 	path = "~/projects",
    -- 	---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
    -- 	patterns = {}, -- For example {"folke"}
    -- 	fallback = false, -- Fallback to git when local plugin doesn't exist
    -- },
    checker = {
      enabled = false,
      frequency = 2592000, -- check for updates every week 60*60*24*30
    }, -- automatically check for plugin updates
    performance = {
      rtp = {
        -- ---@type string[]
        -- paths = {}, -- custom paths to include in the rtp

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

    -- Enable profiling of lazy.nvim with extra overhead,
    -- only enable when debugging lazy.nvim
    -- profiling = {
    --   -- Enables extra stats on the debug tab related to the loader cache.
    --   -- Additionally gathers stats about all package.loaders
    --   loader = false,
    --   -- Track each new require in the Lazy profiling tab
    --   require = false,
    -- },
    -- https://lazy.folke.io/usage/profiling
  },
}
