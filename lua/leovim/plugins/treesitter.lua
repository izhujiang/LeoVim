return {
  {
    -- Nvim Treesitter configurations and abstraction layer
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdateSync",
      "TSUpdate",
      "TSInstallSync",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSConfigInfo",
    },
    keys = require("leovim.builtin.nvim-treesitter").keys or {},
    opts = require("leovim.builtin.nvim-treesitter").opts or {},
    init = require("leovim.builtin.nvim-treesitter").init,

    config = function(_, opts)
      -- avoid running in headless mode since it's harder to detect failures
      if #vim.api.nvim_list_uis() == 0 then
        vim.notify("headless mode detected, skipping running setup for treesitter")
        return
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    -- plugin that shows the context of the currently visible buffer contents When scroll out of a function,
    -- class, or other block, the context will be displayed at the top of the screen.
    -- useful for long files or deeply nested code, providing immediate context about the surrounding structure.
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure it loads after nvim-treesitter
    cmd = {
      "TSContextToggle",
      "TSContextEnable",
      "TSContextDisable",
    },
    keys = require("leovim.builtin.nvim-treesitter-context").keys or {},
    opts = require("leovim.builtin.nvim-treesitter-context").opts or {},
  },

  {
    -- treesitter plugin: Syntax aware text-objects, select, move, swap, and peek support.
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure it loads after nvim-treesitter
    event = { "BufReadPost", "BufNewFile" },
    opts = require("leovim.builtin.nvim-treesitter-textobjects").opts or {},
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textobjects = opts })

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ "n", "x", "o" }, "].", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, "[.", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end,
  },

  {
    -- treesitter plugin: setting 'commentstring' option based on the cursor's location.
    -- TODO: unable to set /* %s */ for c/c++ code block, guess it's bug, wait...
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    opts = require("leovim.builtin.nvim-ts-context-commentstring").opts or {},
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)

      -- override the Neovim internal get_option function which is called whenever the commentstring is requested:
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },
}