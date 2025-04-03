return {
  keys = {
    {
      "<leader>kd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble diagnostics(document)",
    },
    {
      "<leader>kD",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Trouble diagnostics(workspace)",
    },
    {
      "<leader>kl",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "Trouble LSP",
    },
    {
      "<leader>kr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "Trouble references",
    },
    {
      "<leader>kq",
      "<cmd>Trouble quickfix toggle<cr>",
      desc = "Trouble quickfix",
    },
    {
      "]q",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.next({ skip_groups = true, jump = true })
        else
          vim.cmd.cnext()
        end
      end,
      desc = "Next trouble/quickfix",
    },
    {
      "[q",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.prev({ skip_groups = true, jump = true })
        else
          vim.cmd.cprevious()
        end
      end,
      desc = "Previous trouble/quickfix",
    },
    {
      "]Q",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.last({ skip_groups = true, jump = true })
        else
          vim.cmd.clast()
        end
      end,
      desc = "Last trouble/quickfix",
    },
    {
      "[Q",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.first({ skip_groups = true, jump = true })
        else
          vim.cmd.cfirst()
        end
      end,
      desc = "First trouble/quickfix",
    },
  },

  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
}