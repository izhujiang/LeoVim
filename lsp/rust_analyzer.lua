return {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  single_file_support = true,

  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = "all", -- Optional: Enable all features in Cargo.toml
      },
      check = {
        command = "clippy", -- Optional: Use Clippy for linting on save
      },
      completion = {
        fullFunctionSignatures = { enable = true },
        -- limit = 10,
      },
      diagnostics = {
        styleLints = { enable = true }, -- additional style lints.
        -- experimental = { enable = true },
      },
      hover = {
        actions = {
          references = {
            enable = true,
          },
        },
      },
      lens = {
        references = {
          adt = { enable = true },
          method = { enable = true },
          trait = { enable = true },
        },
      },
      semanticHighlighting = {
        punctuation = {
          enable = true,
          separate = { macro = { bang = true } },
        },
      },
      -- No need to explicitly set rustfmt, it uses rustfmt by default
      -- rust-analyzer doesn’t have a dedicated formatter, but it can
      -- delegate formatting tasks to external tools like rustfmt.
    },
  },
}