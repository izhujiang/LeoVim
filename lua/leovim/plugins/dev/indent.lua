return {
  -- indent guides for Neovim
  "lukas-reineke/indent-blankline.nvim",
  event = { "VeryLazy" },
  main = "ibl", -- update from version 2 to version 3
  opts = {
    indent = {
      char = "╎",
    },
    scope = {
      enabled = true,
      char = "│",
      exclude = {
        language = { "rust" },
        node_type = { lua = { "block", "chunk" } },
      },
    },
    exclude = {
      buftypes = {
        "nofile",
        "prompt",
        "quickfix",
        "terminal",
      },
      filetypes = {
        "alpha",
        "checkhealth",
        "dashboard",
        "fugitive",
        "gitcommit",
        "help",
        "lazy",
        "lazyterm",
        "lspinfo",
        "man",
        "mason",
        "neo-tree",
        "notify",
        "toggleterm",
        "NvimTree",
        "Trouble",
      },
    },
  },
}