local global_ts = vim.fn.system("npm root -g"):gsub("\n", "")

return {
  filetypes = {
    "astro",
  },
  cmd = { "astro-ls", "--stdio" },
  root_markers = {
    {
      "package.json",
      "tsconfig.json",
      "jsconfig.json",
      "astro.config.mjs",
    },
    ".git",
  },
  settings = {
    astro = {
      enable = true,
      diagnostics = {
        enable = true,
      },
      format = {
        enable = true,
      },
      completions = {
        enabled = true,
      },
    },
  },
  init_options = {
    typescript = {
      tsdk = global_ts .. "/typescript/lib",
    },
  },

  on_attach = function(client, _bufnr)
    -- Disable capabilities (format, lint) we want ruff to handle
    -- client.server_capabilities.documentFormattingProvider = false
    -- client.server_capabilities.documentRangeFormattingProvider = false
  end,
}