return {
  keys = {
    {
      -- toggle dapui
      "<leader>du",
      function()
        require("dapui").toggle()
      end,
      desc = "Toggle dapui",
    },
    {
      "<leader>dU",
      function()
        require("dapui").toggle({ reset = true })
      end,
      desc = "Reset dapui",
    },
    -- TODO: For a one time expression evaluation, you can call a hover window to show a value
    -- If an expression is not provided it will use the word under the cursor,
    -- or if in visual mode, the currently highlighted text.
    -- vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
    {
      "<C-?>",
      function()
        require("dapui").eval()
      end,
      mode = { "n", "v" },
      desc = "Eval",
    },
    {
      "<C-/>",
      function()
        require("dapui").eval(vim.fn.input("[Expression] > "))
      end,
      desc = "Eval expr",
    },
  },
  opts = function(_, _)
    local icons = require("leovim.config.icons")
    return {
      expand_lines = true,
      icons = {
        expanded = icons.dap.Expanded,
        collapsed = icons.dap.Collapsed,
        circular = icons.dap.Circular,
      },
      mappings = {
        -- Use a table to apply multiple mappings
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "left",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5, -- Floats will be treated as percentage of your screen.
        border = vim.g.border_chars, -- Border style. Can be 'single', 'double' or 'rounded'
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    }
  end,
}
