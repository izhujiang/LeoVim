return {
  keys = {
    {
      "<A-1>",
      "<cmd>ToggleTerm direction=horizontal<cr>",
      mode = { "n", "i", "t" },
      desc = "Horizontal terminal",
    },
    {
      "<A-2>",
      "<cmd>ToggleTerm direction=vertical<cr>",
      -- "<cmd>ToggleTerm =vertical<cr>",
      mode = { "n", "i", "t" },
      desc = "Hertical terminal",
    },
    {
      "<A-3>",
      "<cmd>ToggleTerm direction=float<cr>",
      mode = { "n", "i", "t" },
      desc = "Float terminal",
    },
    {
      "<A-t>",
      "<cmd>ToggleTerm direction=float<cr>",
      mode = { "n", "i", "t" },
      desc = "Float terminal",
    },
    {
      "<A-\\>",
      "<cmd>ToggleTerm direction=float<cr>",
      mode = { "n", "i", "t" },
      desc = "Float terminal",
    },
  },
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return vim.o.lines * 0.4
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      else
        return 0
      end
    end,
    open_mapping = [[<A-\>]],
    hide_numbers = true,
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true, -- open_mapping = [[<c-\>]], is also applied in insert and terminal mode
    terminal_mappings = true,
    persist_size = true,
    persist_mode = true,
    direction = "float",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
      highlights = {
        border = "Normal",
        background = "Normal",
      },
    },
  },
}