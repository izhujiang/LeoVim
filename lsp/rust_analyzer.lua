return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = { "Cargo.toml", ".git" },
  single_file_support = true,

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = {
        command = "clippy", -- Optional: Use Clippy for linting on save
      },
      -- No need to explicitly set rustfmt, it uses rustfmt by default
      -- rust-analyzer doesn’t have a dedicated formatter, but it can
      -- delegate formatting tasks to external tools like rustfmt.
    },
  },
}
