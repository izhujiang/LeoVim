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


  -- codeium for nvim-cmp source
  {
    "nvim-cmp",
    dependencies = {
      { "Exafunction/codeium.nvim" }, -- source: codeium
    },
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "codeium",
        priority = 700,
        group_index = 1,
      })
    end,
  },

  -- Free, ultrafast Copilot alternative for Vim and Neovim
  {
    "Exafunction/codeium.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = ":Codeium Auth",
    event = { "InsertEnter" },
    -- init = function()
    -- disable the automatic triggering of completions
    -- vim.g.codeium_manual = 1

    -- Codeium's default keybindings can be disabled by setting
    -- vim.g.codeium_disable_bindings = 1

    -- disable default <Tab> binding
    -- vim.g.codeium_no_map_tab = 1

    -- disable codeium for all filetypes
    -- codeium_filetypes_disabled_by_default = 1
    -- vim.g.codeium_filetypes = {
    -- bash = false,
    -- typescript = false,
    -- disable automatic text rendering of suggestions
    -- vim.g.codeium_render = false
    -- }
    -- end,
    cmd = { "Codeium" },
  },

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
