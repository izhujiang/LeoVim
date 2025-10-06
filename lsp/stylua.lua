--- https://github.com/JohnnyMorganz/StyLua
---
--- A deterministic code formatter for Lua 5.1, 5.2, 5.3, 5.4, LuaJIT, Luau and CfxLua/FiveM Lua

---@type vim.lsp.Config
return {
  cmd = { "stylua", "--lsp" },
  filetypes = { "lua" },
  root_markers = { ".stylua.toml", "stylua.toml", ".editorconfig" },

  -- configuration
  --  - stylua.toml or .stylua.toml starting from the directory of the file being formatted.
  --  - keep searching upwards until it reaches the current directory where the tool was executed.
  --  - If not found, we search for an .editorconfig file,
  --  - otherwise fall back to the default configuration.
}
