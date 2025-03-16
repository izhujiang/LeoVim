return {
  -- References highlighting
  -- automatically highlighting other uses of the word under the cursor using either LSP, Tree-sitter, or regex matching.
  -- ]r, [r, move between references
  -- :Illuminate{Pause, Resume, Toggle, PauseBuf, ResumeBuf, ToggleBuf,}
  "RRethy/vim-illuminate",
  event = { "VeryLazy" },
  keys = {
    {
      "<leader>ur",
      function()
        require("illuminate").toggle()
      end,
      desc = "references(illuminate)",
    },
    {
      "]r",
      function()
        require("illuminate").goto_next_reference(false)
      end,
      desc = "reference(illuminate)",
    },
    {
      "[r",
      function()
        require("illuminate").goto_prev_reference()
      end,
      desc = "reference(illuminate)",
    },
  },
  opts = {
    -- providers = { "lsp", "treesitter", "regex" },
    delay = 120,
    large_file_cutoff = 2000,
    -- filetype_overrides = {},
    -- large_file_overrides = {},

    filetypes_denylist = require("leovim.config.defaults").non_essential_filetypes,
    under_cursor = true,
    disable_keymaps = true,
  },
  config = function(_, opts)
    require("illuminate").configure(opts)
  end,
}