return {
  {
    -- fuzzy finder: a highly extendable fuzzy finder over lists.
    -- Built on the latest awesome features from neovim core.
    -- Optional dependencies:
    --    fd - better find utility
    --    rg - better grep utility
    --    bat - syntax highlighted previews when using fzf's native previewer
    --    delta - syntax highlighted git pager for git status previews
    --    nvim-dap - for Debug Adapter Protocol (DAP) support
    --    nvim-treesitter-context - for viewing treesitter context within the previewer
    --    render-markdown.nvim or markview.nvim - for rendering markdown files in the previewer
    --    chafa - terminal image previewer (recommended, supports most media file formats)
    "ibhagwan/fzf-lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      -- "nvim-treesitter/nvim-treesitter-context"
    },
    cmd = { "FzfLua" },
    keys = require("leovim.config.plugins.fzf").keys or {},
    opts = require("leovim.config.plugins.fzf").opts or {},
    config = function(_, opts)
      local fzf = require("fzf-lua")
      fzf.setup(opts)
      fzf.register_ui_select()
    end,
  },

  -- explorer
  {
    -- a simple fast, lightweight file explorer
    "nvim-tree/nvim-tree.lua",
    enabled = vim.g.explorer == "nvim-tree", -- "neo-tree" or "nvim-tree"

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
    keys = require("leovim.config.plugins.nvim-tree").keys or {},
    opts = require("leovim.config.plugins.nvim-tree").opts or {},
    init = require("leovim.config.plugins.nvim-tree").init,
  },
  {
    -- File Explorer (a feature-rich, customizable, and modern experience), manage the file system and other tree like structures.
    -- usage:
    --  :Neotree filesystem reveal right
    "nvim-neo-tree/neo-tree.nvim",
    enabled = vim.g.explorer == "neo-tree", -- "neo-tree" or "nvim-tree"
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = require("leovim.config.plugins.nvim-neo-tree").keys or {},
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = require("leovim.config.plugins.nvim-neo-tree").init,
    opts = require("leovim.config.plugins.nvim-neo-tree").opts or {},

    config = function(_, opts)
      require("neo-tree").setup(opts)

      vim.api.nvim_create_autocmd("TermClose", {
        pattern = "*lazygit",
        callback = function()
          if package.loaded["neo-tree.sources.git_status"] then
            require("neo-tree.sources.git_status").refresh()
          end
        end,
      })
    end,
  },
  {
    -- easily manage multiple terminal windows: persist and
    -- toggle multiple terminals during an editing session
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    keys = require("leovim.config.plugins.toggleterm").keys or {},
    opts = require("leovim.config.plugins.toggleterm").opts or {},
    -- config = function(_, opts)
    --   local status_ok, toggleterm = pcall(require, "toggleterm")
    --   if not status_ok then
    --     return
    --   end
    --   toggleterm.setup(opts)

    -- local Terminal = require("toggleterm.terminal").Terminal
    -- local lazygit = Terminal:new({
    --   cmd = "lazygit",
    --   hidden = true,

    --   direction = "float",
    --   float_opts = {
    --     border = "none",
    --     width = 100000,
    --     height = 100000,
    --   },
    --   on_open = function(_)
    --     vim.cmd("startinsert!")
    --   end,
    --   on_close = function(_) end,
    --   count = 99,
    -- })

    -- function _LAZYGIT_TOGGLE()
    --   lazygit:toggle()
    -- end

    -- local node = Terminal:new({ cmd = "node", hidden = true })
    -- function _NODE_TOGGLE()
    --   node:toggle()
    -- end

    -- end,
  },
  {
    "LintaoAmons/scratch.nvim",
    dependencies = {
      { "ibhagwan/fzf-lua" },
    },
    cmd = {
      "Scratch", -- new scratch (note)
      "ScratchWithName", -- new scratch with name
      "ScratchOpen", -- open scratch with fzf file_picker
    },
    keys = {
      { "<leader>N", "<cmd>Scratch<cr>", desc = "New note (scratch)" },
      { "<leader>fN", "<cmd>ScratchOpen<cr>", desc = "Note (scratch)" },
    },
    opts = {
      use_telescope = false,
      file_picker = "fzflua",
    },
  },
  {
    -- Simple session management for Neovim
    -- automatically saves the active session under ~/.local/state/nvim/sessions on exit
    -- usage:
    -- :SessionLoadCwd, :SessionLoadLast, :SessionStart, :SessionStop, :SessionSave
    "folke/persistence.nvim",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "SessionLoadCwd",
      "SessionLoadLast",
      "SessionSelect",
      "SessionStart",
    },
    keys = require("leovim.config.plugins.nvim-persistence").keys or {},
    opts = require("leovim.config.plugins.nvim-persistence").opts or {},
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      -- load the session for the current directory
      vim.api.nvim_create_user_command("SessionLoadCwd", function()
        persistence.load()
      end, {})
      -- restore(load) session
      vim.api.nvim_create_user_command("SessionLoadLast", function()
        persistence.load({ last = true })
      end, {})
      -- select a session to load
      vim.api.nvim_create_user_command("SessionSelect", function()
        persistence.select()
      end, {})
      -- save current session
      vim.api.nvim_create_user_command("SessionSave", function()
        persistence.save()
      end, {})

      -- start Persistence => session will be saved on exit
      vim.api.nvim_create_user_command("SessionStart", function()
        persistence.start()
      end, {})
      -- stop Persistence => session won't be saved on exit
      vim.api.nvim_create_user_command("SessionStop", function()
        persistence.stop()
      end, {})
    end,
  },
  {
    "nvimdev/dashboard-nvim",
    lazy = false, -- As https://github.com/nvimdev/dashboard-nvim/pull/450, dashboard-nvim shouldn't be lazy-loaded to properly handle stdin.
    keys = require("leovim.config.plugins.dashboard").keys or {},
    opts = require("leovim.config.plugins.dashboard").opts or {},
  },
  {
    -- which-key
    -- displays a popup with possible key bindings of the command you started typing and built-in plugins.
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons",
    },
    keys = require("leovim.config.plugins.which_key").keys or {},
    init = require("leovim.config.plugins.which_key").init,
    opts = require("leovim.config.plugins.which_key").opts or {},
  },
}
