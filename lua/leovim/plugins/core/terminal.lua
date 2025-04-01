return {
  -- easily manage multiple terminal windows: persist and
  -- toggle multiple terminals during an editing session
  "akinsho/toggleterm.nvim",
  keys = {
    -- override <C-1>, <C-2> in keymaps.lua
    {
      "<C-1>",
      "<cmd>ToggleTerm direction=horizontal<cr>",
      mode = { "n", "i", "t" },
      desc = "Horizontal terminal",
    },
    {
      "<C-2>",
      "<cmd>ToggleTerm direction=vertical<cr>",
      -- "<cmd>ToggleTerm =vertical<cr>",
      mode = { "n", "i", "t" },
      desc = "Hertical terminal",
    },
    {
      "<C-3>",
      "<cmd>ToggleTerm direction=float<cr>",
      mode = { "n", "i", "t" },
      desc = "Float terminal",
    },
    {
      "<C-\\>",
      "<cmd>ToggleTerm direction=float<cr>",
      mode = { "n", "i", "t" },
      desc = "Float terminal",
    },
    {
      "<leader><leader>t",
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
    open_mapping = [[<C-\>]],
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
}