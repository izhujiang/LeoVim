return {
  filetypes = { "svelte" },
  cmd = { "svelteserver", "--stdio" },
  root_markers = {
    "package.json",
    "svelte.config.js",
    "svelte.config.cjs",
    "svelte.config.ts",
  },
  settings = {
    svelte = {
      plugin = {
        -- Disable TypeScript diagnostics in svelte_ls (but keep other features)
        typescript = {
          diagnostics = {
            enable = false,
          },
        },

        html = {
          completions = {
            enable = true,
            emmet = true, -- enables emmet abbreviations
          },
        },
      },
    },
  },
}