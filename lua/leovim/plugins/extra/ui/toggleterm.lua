return {
  {
    -- TODO: config and enable toggleterm later
    -- https://medium.com/@shaikzahid0713/terminal-support-in-neovim-c616923e0431
    "akinsho/toggleterm.nvim",
    event = "VimEnter",
    -- enbled = false,
    -- event = "VeryLazy",
    opts = {
      size = function(term)
        if term.direction == "horizontal" then
          return vim.fn.winheight(0) * 0.4
        elseif term.direction == "vertical" then
          return vim.fn.winwidth(0) * 0.8
        else
          return 0
        end
      end,
      open_mapping = [[<c-\>]],
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
    keys = {
      {
        "<leader>tn",
        "<cmd>lua _NODE_TOGGLE()<cr>",
        desc = "Terminal (node)",
      },
      {
        "<leader>tg",
        "<cmd>lua _LAZYGIT_TOGGLE()<cr>",
        desc = "Terminal (lazygit)",
      },
      {
        "<leader>tp",
        "<cmd>lua _PYTHON_TOGGLE()<cr>",
        desc = "Terminal (python)",
      },
      {
        "<C-1>",
        "<cmd>ToggleTerm direction=horizontal<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (horizontal)",
      },
      {
        "<C-2>",
        "<cmd>ToggleTerm direction=vertical<cr>",
        -- "<cmd>ToggleTerm =vertical<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (vertical)",
      },
      {
        "<C-3>",
        "<cmd>ToggleTerm direction=float<cr>",
        mode = { "n", "i", "t" },
        desc = "Terminal (float)",
      },
    },
    config = function(_, opts)
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
        return
      end
      toggleterm.setup(opts)

      _G.set_terminal_keymaps = function()
        vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], { noremap = true })
        vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], { noremap = true })
      end

      vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"


      local Terminal = require("toggleterm.terminal").Terminal
      local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

      function _LAZYGIT_TOGGLE()
        lazygit:toggle()
      end

      local node = Terminal:new({ cmd = "node", hidden = true })

      function _NODE_TOGGLE()
        node:toggle()
      end

      local python = Terminal:new({ cmd = "python3", hidden = true })

      function _PYTHON_TOGGLE()
        python:toggle()
      end
    end,
  }

}
