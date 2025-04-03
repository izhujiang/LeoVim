return {
  opts = {
    -- Neovim (0.10) now has built-in support for commenting lines.
    -- First, disable the CursorHold autocommand of this plugin
    enable = true,
    enable_autocmd = false,

    languages = {
      c = { __default = "// %s", __multiline = "/* %s */" },
      rust = "// %s",
    },
  },
}