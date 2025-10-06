-- Toolchain of the web. https://biomejs.dev
-- Formatter & analyzer(Linter, code actions)

--- `biome` supports monorepos by default. It will automatically find the `biome.json` corresponding to the package you are working on, as described in the [documentation](https://biomejs.dev/guides/big-projects/#monorepo). This works without the need of spawning multiple instances of `biome`, saving memory.

---@type vim.lsp.Config
return {
  -- cmd = function(dispatchers, config)
  --   local cmd = "biome"
  --   local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/biome"
  --   if local_cmd and vim.fn.executable(local_cmd) == 1 then
  --     cmd = local_cmd
  --   end
  --   return vim.lsp.rpc.start({ cmd, "lsp-proxy" }, dispatchers)
  -- end,
  cmd = {
    "biome",
    "lsp-proxy",
  },
  filetypes = {
    "html",
    "css",
    "astro",
    "graphql",
    "javascript",
    "javascriptreact",
    "json",
    "jsonc",
    -- "svelte",
    "typescript",
    "typescript.tsx",
    "typescriptreact",
  },
  root_markers = {
    {
      "biome.json",
      "biome.jsonc",
      "package.json",
      "yarn.lock",
      "pnpm-lock.yaml",
      "bun.lockb",
      "bun.lock",
    },
    ".git",
  },
  -- Biome’s LSP server currently exposes only a very small subset of LSP features.
  --  - diagnostics
  --  - code actions
  --  - organize imports
  --  - fixes
  --  - formatting limit (html)

  -- settings = {
  -- Biome settings here if supported
  -- for html, not supported by default.
  -- To enable format html, put biome.json (~/.config/nvim/misc/biome.json) in the root dir of project
  --   formatter = {
  --     enabled = true,
  --     formatWithErrors = false,
  --   },
  --   html = {
  --     formatter = {
  --       enabled = true,
  --     },
  --   },
  -- },
}
