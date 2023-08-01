local servers = {
  bashls = {
    filetypes = { "zsh", "bash", "sh" },
  },

  clangd = {
    keys = {
      { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
    },
    root_dir = function(...)
      -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
      return require("lspconfig.util").root_pattern(
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git"
      )(...)
    end,
    capabilities = {
      offsetEncoding = { "utf-16" },
    },
    cmd = {
      "clangd",
      "--background-index",
      "--clang-tidy",
      "--header-insertion=iwyu",
      "--completion-style=detailed",
      "--function-arg-placeholders",
      "--fallback-style=llvm",
    },
    init_options = {
      usePlaceholders = true,
      completeUnimported = true,
      clangdFileStatus = true,
    },
  },

  cssls = {},
  dockerls = {},
  gopls = {
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = true,
          compositeLiteralTypes = true,
          constantValues = true,
          functionTypeParameters = true,
          parameterNames = true,
          rangeVariableTypes = true,
        },
        analyses = {
          fieldalignment = true,
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        semanticTokens = true,
      },
    },
  },

  html = {},

  jsonls = {
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
    end,
    settings = {
      json = {
        format = {
          enable = true,
        },
        validate = { enable = true },
      },
    },
  },

  -- pyright and ruff_lsp are both for python
  pyright = {
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        },
      },
    },
  },
  -- A Language Server Protocol implementation for Ruff, an extremely fast Python linter and code transformation tool, written in Rust.
  ruff_lsp = {},

  sumneko_lua = { -- "sumneko_lua", -- NOTE: NOT "lus_ls" as documented
    settings = {
      Lua = {
        format = {
          enable = true,
        },
        diagnostics = {
          globals = { "vim", "require", "jit" },
          -- globals = { "vim" },
        },
        workspace = {
          library = {
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua"] = true,
            [vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/lua"] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
          },
        },
        telemetry = {
          enable = false,
        },
      },
    },
  },

  -- both rust_analyzer and taplo for rust
  rust_analyzer = {
    keys = {
      { "K",          "<cmd>RustHoverActions<cr>", desc = "Hover Actions (Rust)" },
      { "<leader>cR", "<cmd>RustCodeAction<cr>",   desc = "Code Action (Rust)" },
      { "<leader>dr", "<cmd>RustDebuggables<cr>",  desc = "Run Debuggables (Rust)" },
    },
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          runBuildScripts = true,
        },
        -- Add clippy lints for Rust.
        checkOnSave = {
          allFeatures = true,
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        procMacro = {
          enable = true,
          ignored = {
            ["async-trait"] = { "async_trait" },
            ["napi-derive"] = { "napi" },
            ["async-recursion"] = { "async_recursion" },
          },
        },
      },
    },
  },
  taplo = {
    keys = {
      {
        "K",
        function()
          if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
            require("crates").show_popup()
          else
            vim.lsp.buf.hover()
          end
        end,
        desc = "Show Crate Documentation",
      },
    },
  },
  -- solargraph = {}, -- ruby
  -- denols = {}, -- TODO: conflict with tsserver, should be solved later
  tsserver = {
    keys = {
      { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
      { "<leader>cR", "<cmd>TypescriptRenameFile<CR>",      desc = "Rename File" },
    },
    settings = {
      typescript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      javascript = {
        format = {
          indentSize = vim.o.shiftwidth,
          convertTabsToSpaces = vim.o.expandtab,
          tabSize = vim.o.tabstop,
        },
      },
      completions = {
        completeFunctionCalls = true,
      },
    },
  },
  yamlls = {},
  vimls = {},
}

return servers
