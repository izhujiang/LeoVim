return {

  -- TODO: config "zbirenbaum/copilot.lua", "zbirenbaum/copilot-cmp", and "nvim-lualine/lualine.nvim" at same time
  -- Ref https://www.lazyvim.org/extras/coding/copilot#copilot-cmp
  {
    -- AI pair programmer
    -- Make sure to run :Lazy load copilot-cmp followed by
    -- :Copilot auth
    -- once the plugin is installed to start the authentication process.
    "zbirenbaum/copilot-cmp",
    enabled = false, -- disable copilot disable

    event = "InsertEnter",
    dependencies = { "zbirenbaum/copilot.lua" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          -- disable copilot.lua's suggestion and panel modules, as they can interfere with completions properly appearing in copilot-cmp.
          suggestion = { enabled = false },
          panel = { enabled = false },
        })                             -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
      end, 100)
    end,
  },

  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },

  -- Free, ultrafast Copilot alternative for Vim and Neovim
  -- {
  --   'Exafunction/codeium.vim',
  --   event = 'BufEnter'
  -- },
  {
    "Exafunction/codeium.nvim", -- authenticate with Codeium by running :Codeium Auth, copying the token from your browser
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    event = 'BufEnter',
    config = function()
      require("codeium").setup({
      })
    end
  },

  -- Tabnine client for Neovim from official
  -- usage:
  -- :TabnineStatus - to print Tabnine status
  -- :TabnineDisable - to disable Tabnine
  -- :TabnineEnable - to enable Tabnine
  -- :TabnineToggle - to toggle enable/disable
  -- :TabnineChat - to launch Tabnine chat
  -- {
  --   "codota/tabnine-nvim",
  --   -- enabled = false,
  --   cond = function()
  --     return vim.loop.os_uname().machine ~= "aarch64"
  --   end,
  --   -- build = "./dl_binaries.sh",
  --   build = function()
  --     if vim.loop.os_uname().sysname == "Windows_NT" then -- Windows installations need to be adjusted to utilize PowerShell with dl_binaries.ps1
  --       -- The build script needs a set execution policy (https://github.com/codota/tabnine-nvim).
  --       -- Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
  --       return "pwsh.exe -file .\\dl_binaries.ps1"
  --     else
  --       return "./dl_binaries.sh" -- for Unix (Linux, MacOS)
  --     end
  --   end,
  --   event = { "InsertEnter" },

  --   opts = {
  --     disable_auto_comment = false,
  --     accept_keymap = "<C-y>", -- don't use <Tab> or <CR> as accept_keymap
  --     dismiss_keymap = "<C-]>",
  --     debounce_ms = 800,
  --     suggestion_color = { gui = "#F00000", cterm = 244 },
  --     exclude_filetypes = { "TelescopePrompt" },
  --     log_file_path = nil, -- absolute path to Tabnine log file
  --     -- log_file_path = "~/tabnine.log", -- absolute path to Tabnine log file
  --   },
  --   -- solve confix with nvim-cmp's maps <Tab> to navigating through pop menu items (https://github.com/codota/tabnine-nvim#tab-and-nvim-cmp).
  --   -- This conflicts with Tabnine <Tab> for inline completion. To get this sorted you can either:
  --   -- 		- Bind Tabnine inline completion to a different key using accept_keymap
  --   -- 		- Bind cmp.select_next_item() & cmp.select_prev_item() to different keys, e.g: <C-k> & <C-j>.
  --   config = function(_, opts)
  --     require("tabnine").setup(opts)
  --   end,
  -- },

  -- better yank/paste
  {
    "gbprod/yanky.nvim",
    enabled = false,
    dependencies = {
      { "kkharji/sqlite.lua",           enabled = not jit.os:find("Windows") },
      { "nvim-telescope/telescope.nvim" },
    },
    opts = function()
      local mapping = require("yanky.telescope.mapping")
      local mappings = mapping.get_defaults()
      mappings.i["<c-p>"] = nil
      return {
        highlight = { timer = 200 },
        ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" },
        picker = {
          telescope = {
            use_default_mappings = false,
            mappings = mappings,
          },
        },
      }
    end,
    keys = {
      -- stylua: ignore
      {
        "<leader>fy",
        function() require("telescope").extensions.yank_history.yank_history({}) end,
        desc =
        "Yank history"
      },
      {
        "y",
        "<Plug>(YankyYank)",
        mode = { "n", "x" },
        desc = "Yank",
      },
      {
        "p",
        "<Plug>(YankyPutAfter)",
        mode = { "n", "x" },
        desc = "Put",
      },
      {
        "P",
        "<Plug>(YankyPutBefore)",
        mode = { "n", "x" },
        desc = "Put before",
      },
      {
        "gp",
        "<Plug>(YankyGPutAfter)",
        mode = { "n", "x" },
        desc = "Put",
      },
      {
        "gP",
        "<Plug>(YankyGPutBefore)",
        mode = { "n", "x" },
        desc = "Put before",
      },
      {
        "=p",
        "<Plug>(YankyPutAfterFilter)",
        desc = "Put after applying a filter",
      },
      {
        "=P",
        "<Plug>(YankyPutBeforeFilter)",
        desc = "Put before applying a filter",
      },
    },
  },
}
