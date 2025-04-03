-- render-markdown.nvim
return {
  opts = {
    file_types = { "markdown", "Avante" },
    completions = {
      lsp = { enabled = true },
      blink = { enabled = true },
    },
  }
}
