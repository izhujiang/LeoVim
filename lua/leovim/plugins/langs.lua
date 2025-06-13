return {
  -- Clangd's off-spec features for neovim's LSP client
  -- usage:
  -- -- :ClangdSwitchSourceHeader
  -- -- :ClangdAST
  -- -- :ClangdSymbolInfo
  -- -- :ClangdTypeHierarchy
  -- -- :ClangdMemoryUsage
  "p00f/clangd_extensions.nvim",
  ft = { "c", "cpp" },
  cmd = {
    "ClangdSwitchSource",
    "ClangdAST",
    "ClangdSymbolInfo",
    "ClangdTypeHierarch",
    "ClangdMemoryUsage",
  },
  opts = {
    inlay_hints = {
      inline = false,
    },
    ast = {
      --These require codicons (https://github.com/microsoft/vscode-codicons)
      role_icons = {
        type = "",
        declaration = "",
        expression = "",
        specifier = "",
        statement = "",
        ["template argument"] = "",
      },
      kind_icons = {
        Compound = "",
        Recovery = "",
        TranslationUnit = "",
        PackExpansion = "",
        TemplateTypeParm = "",
        TemplateTemplateParm = "",
        TemplateParamObject = "",
      },
      highlights = {
        detail = "Comment",
      },
    },
    memory_usage = {
      border = "rounded",
    },
    symbol_info = {
      border = "rounded",
    },
  },

  {
    -- Prerequisites
    --  neovim >= 0.11
    --  rust-analyzer
    --  optional: dot, cargo, a debug adapter (e.g. lldb or codelldb), tree-sitter parser for Rust
    "mrcjkb/rustaceanvim",
    version = "^6", -- Recommended
    enabled = false,
  },

  {
    -- usage:
    --   "CargoBench",
    --   "CargoBuild",
    --   "CargoClean",
    --   "CargoDoc",
    --   "CargoNew",
    --   "CargoRun",
    --   "CargoRunTerm",
    --   "CargoTest",
    --   "CargoUpdate",
    --   "CargoCheck",
    --   "CargoClippy",
    --   "CargoAdd",
    --   "CargoRemove",
    --   "CargoFmt",
    --   "CargoFix",

    "nwiizo/cargo.nvim",
    build = "cargo build --release",
    opts = {
      float_window = true,
      window_width = 0.8,
      window_height = 0.8,
      border = "rounded",
      auto_close = true,
      close_timeout = 5000,
    },
    -- config = function(_, opts)
    --   require("cargo").setup(opts)
    -- end,
    ft = { "rust" },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "rust",
        callback = function()
          vim.keymap.set("n", "<leader>r", ":CargoRun<cr>", { buffer = true, desc = "Cargo run" })
          vim.keymap.set("n", "<leader>R", ":CargoRunTerm<cr>", { buffer = true, desc = "Cargo run (terminal)" })
          vim.keymap.set("n", "<leader>b", ":CargoBuild<cr>", { buffer = true, desc = "Cargo build" })
        end,
      })
    end,
  },
}