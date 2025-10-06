return {
  {
    --A super powerful autopair plugin for Neovim that supports multiple
    --characters.
    -- usage:
    --      just type open pair like: {|
    --      fast_wrap open pair and words (|foo bar, <M-e>, <M-e>$ <M-e>q[hH]
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = require("leovim.config.plugins.autopairs").opts or {},
    -- config = function(_, opts)
    --   local autopairs = require("nvim-autopairs")
    --   autopairs.setup(opts)
    -- end,
  },

  {
    -- Nvim-Surround (Manipulating SurrOundings)
    -- usage:
    -- 	y[sS]{motion}{char} or yss[SS]{char}, char: " ' { [ ( t }  Examples: ys$"
    -- 	cs{s1}{s2}
    -- 	ds{s1}
    -- 	Use a single character as an alias for several text-object,
    -- 	  q for nearest quote(', ", or `),
    -- 	  t for tag,
    -- 	  b for bracket,
    -- 	  f for function
    "kylechui/nvim-surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = require("leovim.config.plugins.nvim-surround").opts or {},
  },

  {
    -- Use treesitter to autoclose and autorename html tag
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "typescript",
      "jsx",
      "tsx",
      "html",
      "xml",
      "astro",
    },
  },

  -- completion
  {
    "saghen/blink.cmp",
    -- use a release tag to download pre-built binaries
    version = "*",
    -- OR build from source,
    -- build = "cargo build --release",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      -- {
      --   -- reconstructs completion item and applies highlight range with streesitter.
      --   "xzbdmw/colorful-menu.nvim",
      -- },
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
      {
        -- for zbirenbaum/copilot.lua
        "giuxtaposition/blink-cmp-copilot",
        cond = vim.g.ai_provider == "copilot",
        dependencies = {
          "zbirenbaum/copilot.lua",
        },
      },
      {
        -- Compatibility layer for using nvim-cmp sources on blink.cmp, used by codeium ...
        "saghen/blink.compat",
        cond = vim.g.ai_provider == "codeium",
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = "*",
        opts = {},
      },
      {
        "Exafunction/windsurf.nvim",
        cond = vim.g.ai_provider == "codeium",
      },
      {
        "Kaiser-Yang/blink-cmp-avante",
        -- cond = (vim.version().major == 0 and vim.version().minor >= 11) and
        cond = vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
          and vim.g.ai_ui == "avante",
      },
      -- optional: provides snippets for the snippet source
      { "rafamadriz/friendly-snippets" },
      -- { "L3MON4D3/LuaSnip", version = "v2.*" },
    },

    opts = require("leovim.config.plugins.blink").opts or {},
  },
  {
    -- todo comments
    -- Highlight, list and search todo comments  in your projects
    -- usage: ("-" stand for todolist)
    -- -- :TodoTrouble, :TodoFzfLua, :TodoQuickfix, :TodoLocList,
    -- -- <leader>f-/F-, <leader>t-/T-
    -- -- ]-/[-
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- event = { "VeryLazy" },
    cmd = { "TodoTrouble", "TodoFzfLua" },
    keys = require("leovim.config.plugins.todo-comments").keys or {},
    opts = require("leovim.config.plugins.todo-comments").opts or {},
  },
}
