return {
  {
    -- A collection of small QoL plugins for Neovim.
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    -- Snacks is a global variable defined in snacks.nvim, use it directly
    keys = require("leovim.builtin.snacks").keys or {},
    opts = require("leovim.builtin.snacks").opts or {},
    init = require("leovim.builtin.snacks").init,
  },
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
    },
    cmd = { "FzfLua" },
    keys = require("leovim.builtin.fzf").keys or {},
    opts = require("leovim.builtin.fzf").opts or {},
    -- config = function(_, opts)
    -- local fzf = require("fzf-lua")
    -- fzf.setup(opts)
    -- fzf.register_ui_select()
    -- end,
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
    keys = require("leovim.builtin.nvim-tree").keys or {},
    opts = require("leovim.builtin.nvim-tree").opts or {},
    init = require("leovim.builtin.nvim-tree").init,
  },
  {
    -- File Explorer (a feature-rich, customizable, and modern experience), manage the file system and other tree like structures.
    -- usage:
    --  :Neotree filesystem reveal right
    -- TODO: colorscheme should been applied before neo-tree setup.
    "nvim-neo-tree/neo-tree.nvim",
    enabled = vim.g.explorer == "neo-tree", -- "neo-tree" or "nvim-tree"
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    event = { "VimEnter" },
    cmd = "Neotree",
    keys = require("leovim.builtin.nvim-neo-tree").keys or {},
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    opts = require("leovim.builtin.nvim-neo-tree").opts or {},
    init = require("leovim.builtin.nvim-neo-tree").init,

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
    keys = require("leovim.builtin.toggleterm").keys or {},
    opts = require("leovim.builtin.toggleterm").opts or {},
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

    -- local python = Terminal:new({ cmd = "python3", hidden = true })
    -- function _PYTHON_TOGGLE()
    --   python:toggle()
    -- end
    -- end,
  },
  {
    -- Simple session management for Neovim
    -- automatically saves the active session under ~/.local/state/nvim/sessions on exit
    -- usage:
    -- :SessionLoadLast, :SessionLoadCurrent, :SessionStop, :SessionStart, :SessionSave
    -- Alternate: rmagatti/auto-session
    "folke/persistence.nvim",
    event = "VeryLazy",
    opts = require("leovim.builtin.nvim-persistence").opts or {},
    config = function(_, opts)
      local persistence = require("persistence")
      persistence.setup(opts)

      -- load the session for the current directory
      vim.api.nvim_create_user_command("SessionLoad", function()
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
    -- which-key
    -- displays a popup with possible key bindings of the command you started typing.
    -- and built-in plugins: marks, registers, presets(built-in key binding help for motions, text-objects, operators, windows, nav, z and g) and spelling suggestions.
    --
    -- usage:
    --  to triggger text-objects:         i and a
    --  to triggger operators:            c, d, y, ~, g~, !, =, gq,
    --  to triggger motions:              b, w, j, f, /, ? g
    --
    -- 	to trigger marks:                 ' and `
    --  to trigger register:              " in normal mode and <C-r> in insert mode
    --  to trigger fold:                  z
    --  to trigger spelling suggestions: 	z=
    --  to trigger window commands:		    <c-w>
    --  scroll_down = "<c-d>", -- binding to scroll down inside the popup
    --  scroll_up = "<c-u>", -- binding to scroll up inside the popup
    "folke/which-key.nvim",
    event = "VeryLazy",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "echasnovski/mini.icons",
    },
    keys = require("leovim.builtin.which-key").keys or {},
    opts = require("leovim.builtin.which-key").opts or {},
    init = require("leovim.builtin.which-key").init,
  },
}