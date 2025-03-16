return {
  {
    "zbirenbaum/copilot.lua",
    cond = vim.g.ai == "copilot",
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      -- It is recommended to disable copilot.lua's suggestion and panel modules,
      -- as they can interfere with completions properly appearing in blink-cmp-copilot.
      suggestion = {
        enabled = false,
        auto_trigger = true,
        hide_during_completion = true,
        keymap = {
          accept = false, -- handled by nvim-cmp / blink.cmp
          next = "<M-]>",
          prev = "<M-[>",
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
      },
    },
  },
  {
    -- Free, ultrafast Copilot alternative for Vim and Neovim
    "Exafunction/codeium.nvim",
    cond = vim.g.ai == "codeium",
    event = { "InsertEnter" },

    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    build = ":Codeium Auth",
    -- event = { "InsertEnter" },
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
    -- {} struct enable to call defaut config function
    opts = {},
    -- config = function(_, opts)
    -- require("codeium").setup(opts)

    -- It's ok to setup the sources for blink and nvim-cmp here,
    -- but prefer to setup in their own config
    -- if vim.g.completion == "blink" then
    --   vim.print("setup source for blink")
    -- elseif vim.g.completion == "nvim-cmp" then
    --   -- appdend codeium to cmp-sources
    --   local cmp = require("cmp")
    --   local config = cmp.get_config()
    --   table.insert(config.sources, {
    --     name = "codeium",
    --     group_index = 1,
    --     priority = 700,
    --   })
    --   cmp.setup(config)
    -- end
    -- end,
  },

  -- for nvim-cmp
  {
    -- Ref https://www.lazyvim.org/extras/coding/copilot#copilot-cmp
    -- AI pair programmer
    -- Make sure to run :Lazy load copilot-cmp followed by
    -- :Copilot auth
    -- once the plugin is installed to start the authentication process.
    "zbirenbaum/copilot-cmp",
    cond = vim.g.completion == "nvim-cmp" and vim.g.ai == "copilot",

    event = { "InsertEnter" },
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {},
  },

  {
    -- appdend codeium or copilot to cmp-sources
    "hrsh7th/nvim-cmp",
    optional = true,
    cond = vim.g.completion == "nvim-cmp",
    -- dependencies = { "codeium.nvim" },
    opts = function(_, opts)
      if vim.g.ai == "codeium" then
        table.insert(opts.sources, 1, {
          name = "codeium",
          group_index = 1,
          priority = 800,
        })
      elseif vim.g.ai == "copilot" then
        table.insert(opts.sources, 1, {
          name = "copilot",
          group_index = 1,
          priority = 800,
        })
      end
      return opts
    end,
  },

  -- for blink, ai.lua should in the extra directory which after dev directory.
  {
    "saghen/blink.cmp",
    cond = vim.g.completion == "blink",
    optional = true,
    dependencies = {
      --   -- Compatibility layer for using nvim-cmp sources on blink.cmp
      {
        "saghen/blink.compat",
        cond = vim.g.ai == "codeium",
      },
      {
        "giuxtaposition/blink-cmp-copilot",
        cond = vim.g.ai == "copilot",
      },
    },
    opts = function(_, opts)
      -- make sure opts has been set on main part of blink.cmp opts config(run first)
      if vim.g.ai == "codeium" then
        opts = vim.tbl_deep_extend("keep", opts or {}, {
          sources = {
            providers = {
              codeium = {
                name = "codeium",
                module = "blink.compat.source",
                -- score_offset = 100,
                async = true,
                opts = {
                  -- some plugins lazily register their completion source when nvim-cmp is
                  -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
                  -- most plugins don't do this, so this option should rarely be needed
                  -- only has effect when using lazy.nvim plugin manager
                  impersonate_nvim_cmp = true,

                  -- print some debug information. Might be useful for troubleshooting
                  -- debug = false,
                },
              },
            },
            -- default = {},  -- DON'T override default
          },
        })
        vim.list_extend(opts.sources.default, { "codeium" })
      elseif vim.g.ai == "copilot" then
        opts = vim.tbl_deep_extend("keep", opts or {}, {
          sources = {
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                -- score_offset = 100,
                async = true,
              },
            },
            -- default = {},
          },
        })
        vim.list_extend(opts.sources.default, { "copilot" })
      end
      return opts
    end,
  },
}