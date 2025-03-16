return {
  --A super powerful autopair plugin for Neovim that supports multiple
  --characters.
  -- usage:
  --      just type open pair like: {|
  --      fast_wrap open pair and words (|foo bar, <M-e>, <M-e>$ <M-e>q[hH]
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  opts = {
    disable_filetype = { "TelescopePrompt", "spectre_panel", "vim" },
    -- disable_in_macro = true,           -- disable when recording or executing a macro
    disable_in_visualblock = true, -- disable when insert after visual block mode
    -- disable_in_replace_mode = true,
    -- ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], "%s+", ""),
    -- enable_moveright = true,
    -- enable_afterquote = true,          -- add bracket pairs after quote
    -- enable_check_bracket_line = true, --- check bracket in same line
    -- enable_bracket_in_quote = true,
    -- enable_abbr = false,               -- trigger abbreviation
    -- break_undo = true,                 -- switch for basic rule break undo sequence
    check_ts = true, -- check treesitter
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      java = false,
    },

    -- map_cr = true,
    -- map_bs = true,   -- map the <BS> key
    map_c_h = true, -- Map the <C-h> key to delete a pair
    map_c_w = true, -- map <c-w> to delete a pair if possible

    fast_wrap = {
      -- map = "<M-e>",
      -- chars = { "{", "[", "(", '"', "'" },
      pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
      -- end_key = "$",
      before_key = "h",
      after_key = "l",
      cursor_pos_before = false,
      -- keys = "qwertyuiopzxcvbnmasdfghjkl",
      -- check_comma = true,
      -- highlight = "Search",
      -- highlight_grey = "Comment",
    },
  },
  config = function(_, opts)
    local autopairs = require("nvim-autopairs")
    autopairs.setup(opts)

    if vim.g.completion == "nvim-cmp" then
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end
  end,
}