return {
  keys = {
    {
      "<leader>xd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Trouble diagnostics(document)",
    },
    {
      "<leader>xD",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Trouble diagnostics(workspace)",
    },
    {
      "<leader>xl",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "Trouble LSP",
    },
    {
      "<leader>xr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "Trouble references",
    },
    {
      "<leader>xq",
      "<cmd>Trouble qflist toggle<cr>",
      desc = "Trouble quickfix",
    },
    {
      "]x",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.next({ skip_groups = true, jump = true })
        end
      end,
      desc = "Next trouble",
    },
    {
      "[x",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.prev({ skip_groups = true, jump = true })
        end
      end,
      desc = "Previous trouble",
    },
    {
      "]X",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.last({ skip_groups = true, jump = true })
        end
      end,
      desc = "Last trouble",
    },
    {
      "[X",
      function()
        local t = require("trouble")
        if t.is_open() then
          t.first({ skip_groups = true, jump = true })
        end
      end,
      desc = "First trouble",
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