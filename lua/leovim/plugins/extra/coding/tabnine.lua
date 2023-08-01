return {
  -- Tabnine client for Neovim from official
  -- usage:
  -- :TabnineStatus - to print Tabnine status
  -- :TabnineDisable - to disable Tabnine
  -- :TabnineEnable - to enable Tabnine
  -- :TabnineToggle - to toggle enable/disable
  -- :TabnineChat - to launch Tabnine chat
  {
    "codota/tabnine-nvim",
    -- enabled = false,
    dependencies = {
      { "nvim-lualine/lualine.nvim" },
    },
    -- build = "./dl_binaries.sh",
    build = function()
      if vim.loop.os_uname().sysname == "Windows_NT" then -- Windows installations need to be adjusted to utilize PowerShell with dl_binaries.ps1
        -- The build script needs a set execution policy (https://github.com/codota/tabnine-nvim).
        -- Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
        return "pwsh.exe -file .\\dl_binaries.ps1"
      else
        return "./dl_binaries.sh" -- for Unix (Linux, MacOS)
      end
    end,
    event = { "InsertEnter" },

    opts = {
      disable_auto_comment = false,
      accept_keymap = "<C-y>", -- don't use <Tab> or <CR> as accept_keymap
      dismiss_keymap = "<C-]>",
      debounce_ms = 800,
      suggestion_color = { gui = "#F00000", cterm = 244 },
      exclude_filetypes = { "TelescopePrompt" },
      log_file_path = nil, -- absolute path to Tabnine log file
      -- log_file_path = "~/tabnine.log", -- absolute path to Tabnine log file
    },
    -- solve confix with nvim-cmp's maps <Tab> to navigating through pop menu items (https://github.com/codota/tabnine-nvim#tab-and-nvim-cmp).
    -- This conflicts with Tabnine <Tab> for inline completion. To get this sorted you can either:
    -- 		- Bind Tabnine inline completion to a different key using accept_keymap
    -- 		- Bind cmp.select_next_item() & cmp.select_prev_item() to different keys, e.g: <C-k> & <C-j>.
    config = function(_, opts)
      require("tabnine").setup(opts)

      -- DON'T override lualine
      -- require('lualine').setup({
      -- 	tabline = {
      -- 		lualine_a = {},
      -- 		lualine_b = { 'branch' },
      -- 		lualine_c = { 'filename' },
      -- 		lualine_x = {},
      -- 		lualine_y = {},
      -- 		lualine_z = {}
      -- 	},
      -- 	sections = { lualine_c = { 'lsp_progress' }, lualine_x = { 'tabnine' } }
      -- })
    end,
  },

  -- TabNine plugin for hrsh7th/nvim-cmp
  {
    "tzachar/cmp-tabnine",
    build = "./install.sh",
    dependencies = {
      { "hrsh7th/nvim-cmp" },
    },
    event = "InsertEnter",
    opts = {
      max_lines = 1000,
      max_num_results = 20,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = '..',
      ignored_file_types = {
        -- default is not to ignore
        -- uncomment to ignore in lua:
        -- lua = true
      },
      show_prediction_strength = false
    },
    -- config = function(_, opts)
    --   local tabnine = require('cmp_tabnine.config')
    --   tabnine:setup(opts)
    -- end
  },

}
