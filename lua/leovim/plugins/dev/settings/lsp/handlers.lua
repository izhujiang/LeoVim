local make_server_opts = function(opts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      "documentation",
      "detail",
      "additionalTextEdits",
    },
  }

  local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if status_ok then
    capabilities = cmp_nvim_lsp.default_capabilities()
  end

  -- !!! DON'T enable cmp_nvim_lsp snippetSupport
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = vim.deepcopy(capabilities),
  }, opts or {})

  return server_opts
  -- return {}
end

local lsp_handlers = {
  -- default handler (The first entry, without a key) will be called for each installed server that doesn't have a dedicated handler.
  function(server_name) -- default handler (optional)
    require("lspconfig")[server_name].setup(make_server_opts({}))
  end,

  bashls = function()
    require("lspconfig").bashls.setup(make_server_opts({
      filetypes = { "zsh", "bash", "sh" },
    }))
  end,

  clangd = function()
    local opts = make_server_opts({
      {
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
    })

    -- setup clangd_extensions
    -- local clangd_ext_opts = require("leovim.util").opts("clangd_extensions.nvim")
    -- local status_ok, clangd_extensions = pcall(require, "clangd_extensions")
    -- if status_ok then
    -- clangd_extensions.setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
    -- end

    -- setup lsp server clangd
    require("lspconfig").clangd.setup(opts)
  end,

  gopls = function()
    local opts = make_server_opts({
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
          semanticTokens = false,
          -- semanticTokens = true,
        },
      },
    })

    -- workaround for gopls not supporting semanticTokensProvider
    -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
    -- require("leovim.util").on_attach(function(client, _)
    --   if client.name == "gopls" then
    --     if not client.server_capabilities.semanticTokensProvider then
    --       local semantic = client.config.capabilities.textDocument.semanticTokens
    --       client.server_capabilities.semanticTokensProvider = {
    --         full = true,
    --         legend = {
    --           tokenTypes = semantic.tokenTypes,
    --           tokenModifiers = semantic.tokenModifiers,
    --         },
    --         range = true,
    --       }
    --     end
    --   end
    -- end)

    require("lspconfig").gopls.setup(make_server_opts(opts))
  end,

  jsonls = function()
    require("lspconfig").jsonls.setup(make_server_opts({
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
    }))
  end,

  lua_ls = function()
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig lua_ls
    local status_ok, neodev = pcall(require, "neodev")
    if status_ok then
      neodev.setup({})
    end

    require("lspconfig").lua_ls.setup(make_server_opts({
      -- "neovim/nvim-lspconfig" <= v0.1.6
      -- require("lspconfig").sumneko_lua.setup(make_server_opts({
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
          },
          format = {
            enable = true,
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua"] = true,
              [vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/lua"] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    }))
  end,

  pyright = function()
    require("lspconfig").pyright.setup(make_server_opts({
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "off",
          },
        },
      },
    }))
  end,

  ruff_lsp = function()
    require("leovim.util").on_attach(function(client, _)
      if client.name == "ruff_lsp" then
        -- Disable hover in favor of Pyright
        client.server_capabilities.hoverProvider = false
      end
    end)
    require("lspconfig").ruff_lsp.setup(make_server_opts({}))
  end,

  -- ["rust_analyzer"] = function()
  --   require("rust-tools").setup {}
  -- end,
  rust_analyzer = function()
    local opts = make_server_opts({
      keys = {
        {
          "K",
          "<cmd>RustHoverActions<cr>",
          desc = "Hover Actions (Rust)",
        },
        {
          "<leader>cR",
          "<cmd>RustCodeAction<cr>",
          desc = "Code Action (Rust)",
        },
        {
          "<leader>dr",
          "<cmd>RustDebuggables<cr>",
          desc = "Run Debuggables (Rust)",
        },
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
    })

    local rust_tools_opts = require("lazyvim.util").opts("rust-tools.nvim")
    require("rust-tools").setup(vim.tbl_deep_extend("force", rust_tools_opts or {}, { server = opts }))

    require("lspconfig").rust_analyzer.setup(opts)
  end,

  taplo = function()
    require("lspconfig").taplo.setup(make_server_opts({
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
    }))
  end,

  tsserver = function()
    local opts = make_server_opts({
      keys = {
        { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
        { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
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
    })

    require("lspconfig").tsserver.setup(opts)
  end,
}

return lsp_handlers