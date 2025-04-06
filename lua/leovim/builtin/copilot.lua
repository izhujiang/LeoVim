-- "zbirenbaum/copilot.lua",
return {
  opts = {
    -- It is recommended to disable copilot.lua's suggestion and panel modules,
    -- as they can interfere with completions properly appearing in blink-cmp-copilot.
    suggestion = {
      enabled = false,
      -- auto_trigger = true,
      auto_trigger = false,
      hide_during_completion = true,
      keymap = {
        accept = false, -- handled by nvim-cmp / blink.cmp
        next = "<M-]>",
        prev = "<M-[>",
      },
    },
    panel = {
      enabled = false,
      auto_refresh = false,
      -- keymap = {
      --   jump_prev = "[[",
      --   jump_next = "]]",
      --   accept = "<CR>",
      --   refresh = "gr",
      --   open = "<M-CR>"
      -- },
      layout = {
        position = "right", -- | top | left | right | horizontal | vertical
        ratio = 0.4,
      },
    },
    -- filetypes = {
    --   markdown = true,
    -- },
    server_opts_overrides = {
      -- trace = "verbose",
      trace = "off",
      settings = {
        advanced = {
          listCount = 10, -- #completions for panel
          inlineSuggestCount = 3, -- #completions for getCompletions
          debugLogging = false,
        },
        telemetry = {
          telemetryLevel = "off",
        },
      },
    },
  },
}