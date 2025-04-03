return {
  {
    --A super powerful autopair plugin for Neovim that supports multiple
    --characters.
    -- usage:
    --      just type open pair like: {|
    --      fast_wrap open pair and words (|foo bar, <M-e>, <M-e>$ <M-e>q[hH]
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = require("leovim.builtin.autopairs").opts or {},
    config = function(_, opts)
      local autopairs = require("nvim-autopairs")
      autopairs.setup(opts)

      if vim.g.completion == "nvim-cmp" then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
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
    event = { "VeryLazy" },
    opts = require("leovim.builtin.nvim-surround").opts or {},
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
    -- blink.cmp as a replacement for nvim-cmp
    -- pro: performant, batteries-included
    "saghen/blink.cmp",
    enabled = vim.g.completion == "blink",
    -- version = false, -- latest development version
    -- use a release tag to download pre-built binaries
    version = "*",
    -- OR build from source,
    -- build = "cargo build --release",

    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = {
          "nvim-lua/plenary.nvim",
        },
      },
      -- {
      -- -- for github/copilot.vim
      --   "fang2hou/blink-copilot",
      --   cond = vim.g.ai_provider == "copilot",
      --   dependencies = {
      --     "github/copilot.vim",
      --   },
      -- },
      {
        -- for zbirenbaum/copilot.lua
        "giuxtaposition/blink-cmp-copilot",
        cond = vim.g.ai_provider == "copilot",
        dependencies = {
          "zbirenbaum/copilot.lua",
        },
      },
      {
        -- Compatibility layer for using nvim-cmp sources on blink.cmp
        "saghen/blink.compat",
        cond = vim.g.ai_provider == "codeium",
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = "*",
        -- make sure to set opts so that lazy.nvim calls blink.compat's setup
        opts = {},
      },
      {
        "Kaiser-Yang/blink-cmp-avante",
        cond = vim.fn.has("nvim-0.10")
          and vim.tbl_contains({ "claude", "openai", "azure", "gemini", "cohere", "copilot" }, vim.g.ai_provider)
          and vim.g.ai_ui == "avante",
      },
      -- optional: provides snippets for the snippet source
      { "rafamadriz/friendly-snippets" },
    },

    opts = require("leovim.builtin.blink").opts or {},
  },

  -- completion: nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    enabled = vim.g.completion == "nvim-cmp",
    version = false, -- last release is way too old
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" }, -- source: buffer words
      { "hrsh7th/cmp-path" }, -- source: file path
      { "hrsh7th/cmp-nvim-lsp" }, -- source: neovim builtin LSP client
      { "hrsh7th/cmp-nvim-lua" }, -- source: neovim's Lua runtime API such vim.lsp.*
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- source: function signatures
      { "saadparwaiz1/cmp_luasnip" }, -- source: luasnip
      { "hrsh7th/cmp-cmdline" }, -- source: cmdline
      { "petertriho/cmp-git", opts = {} }, -- source: git
      -- { "Exafunction/codeium.nvim" }, -- source: codeium
      {
        "zbirenbaum/copilot-cmp",
        cond = vim.g.ai_provider == "copilot",
        dependencies = { "zbirenbaum/copilot.lua" },
        opts = {},
      },
      "L3MON4D3/LuaSnip", -- Snippet Engine for Neovim
    },
    opts = require("leovim.builtin.nvim-cmp").opts or {},
    config = function(_, opts)
      local cmp = require("cmp")
      cmp.setup(opts.default)

      cmp.setup.filetype("gitcommit", opts.filetype.gitcommit)

      cmp.setup.cmdline(":", opts.cmdline[":"])
      cmp.setup.cmdline("/", opts.cmdline["/"])

      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })

      -- NOT working: Auto-hide documentation when the completion menu is visible
      -- cmp.event:on("menu_opened", function()
      --   cmp.close_docs()
      -- end)
    end,
  },
  -- snippets engine
  {
    "L3MON4D3/LuaSnip",
    enabled = vim.g.completion == "nvim-cmp",
    build = "make install_jsregexp",
    dependencies = {
      { "rafamadriz/friendly-snippets" },
    },
    config = function(opts)
      require("luasnip").setup(opts)
      -- be sure to load this first since it overwrites the snippets table.
      -- local luasnip = require("luasnip")
      -- luasnip.snippets = require("luasnip_snippets").load_snippets()

      -- require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
      -- require("luasnip.loaders.from_snipmate").lazy_load()
    end,
  },

  -- todo
  {
    -- todo comments
    -- Highlight, list and search todo comments  in your projects
    -- usage: ("-" stand for todolist)
    -- -- :TodoTrouble, :TodoFzfLua, :TodoQuickfix, :TodoLocList,
    -- -- <leader>f-/F-, <leader>t-/T-
    -- -- ]-/[-
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = { "VeryLazy" },
    cmd = { "TodoTrouble", "TodoFzfLua" },
    keys = require("leovim.builtin.todo-comments").keys or {},
    opts = require("leovim.builtin.todo-comments").opts or {},
  },
}