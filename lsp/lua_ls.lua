-- The Lua Language Server(https://github.com/LuaLS/lua-language-server) uses the Language Server Protocol
-- to provide various features for Lua in your favourite code editors , making development easier, safer, and faster!
--
-- There are three kinds of configuration files that can be used:
-- 1. LSP client-specific configuration file as this lua_ls.lua:
-- This is a configuration file that usually lives in your editor, like the settings.json file from VS Code.
-- It is usually the easiest to use as the clients usually have their own tools for these.
-- 2. A .luarc.json file (recommended).
-- This file can be used between different clients/editors.
-- 3. A custom configuration file
-- A file of your choice written in either Lua or JSON.

return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = {
    ".luarc.json",
    ".luarc.jsonc",
    ".luacheckrc",
    ".stylua.toml",
    "stylua.toml",
    "selene.toml",
    "selene.yml",
    ".git",
  },
  single_file_support = true,

  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      format = {
        enable = true,
      },
      diagnostics = {
        globals = { "vim" },
        -- disable = { "mixed" } -- Disable the mixed table warning
        disable = { "mixed", "lowercase-global" },
      },
      codeLens = {
        enable = true,
      },
      workspace = {
        checkThirdParty = false, -- disable Luv, and Luassert prompts
        library = {
          vim.env.VIMRUNTIME,
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
          -- vim.fn.stdpath("data") .. "/lazy/nvim-treesitter",
          -- vim.fn.stdpath("config") .. "/lua",
          -- "${3rd}/luv/library",
          -- "${workspaceFolder}",
        },
      },
      telemetry = { enable = false },
    },
  },
}