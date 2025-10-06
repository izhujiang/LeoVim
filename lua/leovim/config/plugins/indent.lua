return {
  opts = {
    debounce = 500,
    indent = {
      char = "┊",
      tab_char = "╎",
    },
    whitespace = {
      remove_blankline_trail = false,
    },
    scope = {
      show_start = false,
      show_end = false,
    },
    exclude = {
      buftypes = { "help", "quickfix", "terminal", "prompt" },
      filetypes = vim.g.non_essential_filetypes,
    },
  },
}
