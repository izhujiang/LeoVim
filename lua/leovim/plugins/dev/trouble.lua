return {
  -- trouble.nvim (enhanced QuicKfix or C(K)ompass ), better diagnostics list and others
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the troubles.
  -- usage:
  --  :Trouble [mode] [action] [options]
  -- 		-- document_diagnostics| workspace_diagnostics| lsp_references | lsp_definitions | lsp_type_definitions | quickfix | loclist

  "folke/trouble.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  cmd = {
    "Trouble",
  },
  keys = {
    {
      "<leader>kd",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "diagnostics(document)",
    },
    {
      "<leader>kD",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "diagnostics(workspace)",
    },
    {
      "<leader>kl",
      "<cmd>Trouble lsp toggle<cr>",
      desc = "lsp",
    },
    {
      "<leader>kr",
      "<cmd>Trouble lsp_references toggle<cr>",
      desc = "references",
    },
    {
      "<leader>kq",
      "<cmd>Trouble quickfix toggle<cr>",
      desc = "quickfix",
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
      desc = "trouble/quickfix",
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
      desc = "trouble/quickfix",
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
      desc = "trouble/quickfix",
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
      desc = "trouble/quickfix",
    },
  },
  opts = {
    modes = {
      lsp = {
        win = { position = "right" },
      },
    },
  },
  config = function(_, opts)
    require("trouble").setup(opts)

    -- When you open fzf-lua, you can now hit <c-t> to open the results in Trouble
    local config = require("fzf-lua.config")
    local actions = require("trouble.sources.fzf").actions
    config.defaults.actions.files["ctrl-t"] = actions.open
    -- config.defaults.actions.files["ctrl-k"] = actions.open
  end,
}