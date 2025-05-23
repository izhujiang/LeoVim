return {
  opts = {
    disable_filetype = vim.g.non_essential_filetypes,
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

    -- use treesitter to check for a pair
    check_ts = true,
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
}