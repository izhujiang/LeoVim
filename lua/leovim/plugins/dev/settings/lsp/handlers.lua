local make_server_opts = function(opts)
  -- local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- capabilities.textDocument.completion.completionItem.resolveSupport = {
  --   properties = {
  --     "documentation",
  --     "detail",
  --     "additionalTextEdits",
  --   },
  -- }

  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    {},
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {},
    opts.capabilities or {}
  )

  -- !!! DON'T enable cmp_nvim_lsp snippetSupport
  capabilities.textDocument.completion.completionItem.snippetSupport = false
  local server_opts = vim.tbl_deep_extend("force", {
    capabilities = capabilities,
  }, opts or {})

  return server_opts
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

    local opts = make_server_opts({
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
          },
          format = {
            enable = true,
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false, -- disable Luv, and Luassert prompts
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua"] = true,
              [vim.fn.stdpath("data") .. "/lazy/nvim-treesitter/lua"] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- "neovim/nvim-lspconfig" <= v0.1.6
    -- require("lspconfig").sumneko_lua.setup
    require("lspconfig").lua_ls.setup(opts)
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
  -- Ref: https://github.com/simrat39/rust-tools.nvim
  --sets up nvim-lspconfig for rust_analyzer
  -- require("rust-tools").setup({})
  -- end,

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
        -- don't convert tab/space, using editorconfig instead
        -- javascript = {
        --   format = {
        --     indentSize = vim.o.shiftwidth,
        --     convertTabsToSpaces = vim.o.expandtab,
        --     tabSize = vim.o.tabstop,
        --   },
        -- },
        -- typescript = {
        --   format = {
        --     indentSize = vim.o.shiftwidth,
        --     convertTabsToSpaces = vim.o.expandtab,
        --     tabSize = vim.o.tabstop,
        --   },
        -- },
        completions = {
          completeFunctionCalls = true,
        },
      },

      root_dir = require("lspconfig").util.root_pattern("package.json"),
      single_file_support = false,
    })

    -- TODO: config "jose-elias-alvarez/typescript.nvim" ?
    -- require("typescript").setup({ server = opts })
    require("lspconfig").tsserver.setup(opts)
  end,

  denols = function()
    local opts = make_server_opts({
      settings = {
        {
          deno = {
            enable = true,
            suggest = {
              imports = {
                hosts = {
                  ["https://crux.land"] = true,
                  ["https://deno.land"] = true,
                  ["https://x.nest.land"] = true,
                },
              },
            },
          },
        },
      },
      root_dir = require("lspconfig").util.root_pattern("deno.json", "deno.jsonc"),
    })
    require("lspconfig").denols.setup(opts)
  end,

  tailwindcss = function()
    local opts = make_server_opts({
      filetypes = {
        "astro",
        "elixir",
        "gohtml",
        "haml",
        "html",
        "php",
        "css",
        "less",
        "postcss",
        "sass",
        "scss",
        "stylus",
        "javascript",
        "javascriptreact",
        "typescript",
        "typescriptreact",
        "vue",
        "svelte",
      },
    })
    require("lspconfig").tailwindcss.setup(opts)
  end,

  cssls = function()
    local opts = make_server_opts({
      settings = {
        css = {
          validate = true,
          lint = {
            unknownAtRules = "ignore", -- disable warning: unknown at rule @tailwind
          },
        },
      },
    })
    require("lspconfig").cssls.setup(opts)
  end,
}

return lsp_handlers