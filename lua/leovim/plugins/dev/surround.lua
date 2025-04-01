return {
  -- Nvim-Surround (Manipulating SurrOundings)
  -- usage:
  -- 	y[sS]{motion}{char} or yss[SS]{char}, char: " ' { [ ( t }  Examples: ys$"
  -- 	cs{s1}{s2}
  -- 	ds{s1}
  -- 	Use a single character as an alias for several text-object,
  -- 	  q for nearest quote(', ", or `),
  -- 	  t for tag,
  -- 	  b for bracket,
  -- 	  f for function
  "kylechui/nvim-surround",
  event = { "VeryLazy" },
  opts = {
    -- keymaps = {
    --   insert = "<C-g>s",
    --   insert_line = "<C-g>s",
    --   normal = "ys",
    --   normal_cur = "yss",
    --   normal_line = "yS",
    --   normal_cur_line = "ySS",
    --   visual = "S",
    --   visual_line = "gS",
    --   delete = "ds",
    --   change = "cs",
    -- },
  },
}