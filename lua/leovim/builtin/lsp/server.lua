local function make_user_default_capabilities(user_capabilities)
  -- The nvim-cmp almost supports LSP's capabilities so You should
  -- advertise it to LSP servers..

  local has_cmp, cmp_nvim_lsp
  local capabilities
  if vim.g.completion == "blink" then
    has_cmp, cmp_nvim_lsp = pcall(require, "blink.cmp")
    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.get_lsp_capabilities() or {}
    )
  elseif vim.g.completion == "nvim-cmp" then
    has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
    capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      has_cmp and cmp_nvim_lsp.default_capabilities() or {}
    )
  else
    capabilities = vim.lsp.protocol.make_client_capabilities()
  end

  -- !!! DON'T enable cmp_nvim_lsp snippetSupport, already got cmp_luasnip or
  -- other snippet engines' support
  -- Some LSP servers support auto-snippets for functions, so they insert arguments inside brackets.
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  capabilities = vim.tbl_deep_extend("force", capabilities, user_capabilities or {})
  return capabilities
end

local user_default_capabilities = make_user_default_capabilities({})

local M = {
  mt = {
    __index = function(_, _) -- default server option
      return {
        capabilities = user_default_capabilities,
      }
    end,
  },

  bashls = {
    filetypes = { "zsh", "bash", "sh" },
    capabilities = user_default_capabilities,
  },

  clangd = {
    -- TODO: change the keybind
    -- keys = {
    --   { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
    -- },

    -- root_dir = function(...)
    --   -- using a root .clang-format or .clang-tidy file messes up projects, so remove them
    --   return require("lspconfig.util").root_pattern(
    --     "compile_commands.json",
    --     "compile_flags.txt",
    --     "configure.ac",
    --     ".git"
    --   )(...)
    -- end,
    -- capabilities = {
    --   offsetEncoding = { "utf-16" },
    -- },
    --
    capabilities = user_default_capabilities,
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

  denols = {
    capabilities = user_default_capabilities,
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
  },

  gopls = {
    capabilities = user_default_capabilities,
    settings = {
      gopls = {
        -- Enable goimports-style formatting
        gofumpt = true, -- Use gofumpt to enforce stricter formatting
        experimentalPostfixCompletions = true, -- Optional, for postfix completions
        directoryFilters = {
          "-**/node_modules", -- Exclude all `node_modules` directories
          "-**/.git", -- Exclude all `.git` directories
          "-**/vendor", -- Exclude Go `vendor` directories
          "-**/tmp", -- Exclude temporary files
          "-**/build", -- Exclude build artifacts
        },
        codelenses = {
          -- important! To enable CodeLens, the go workspace or go module must be validate and clear
          gc_details = true, -- Enable GC optimization details
          generate = true, -- Enable "go generate" CodeLens
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true, -- Enable CodeLens for running tests
          tidy = true, -- Enable "go mod tidy" CodeLens
          upgrade_dependency = true, -- Enable dependency upgrade suggestions
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
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true, -- Enable placeholders for function parameters
        completeUnimported = true,
        staticcheck = true, -- Enable static analysis
        semanticTokens = false,
        -- semanticTokens = true,
      },
    },
  },

  jsonls = {
    capabilities = user_default_capabilities,
    -- lazy-load schemastore when needed
    on_new_config = function(new_config)
      vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas())
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
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

  lua_ls = {
    capabilities = user_default_capabilities,
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
            -- vim.fn.stdpath("data") .. "/lazy/lazy.nvim",
            -- vim.fn.stdpath("data") .. "/lazy/nvim-treesitter",
            -- vim.fn.stdpath("config") .. "/lua",
          },
        },
      },
    },
  },

  pyright = {
    capabilities = user_default_capabilities,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "off",
        },
      },
    },
  },

  rust_analyzer = {
    capabilities = user_default_capabilities,
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
  },

  ts_ls = {
    capabilities = user_default_capabilities,
    settings = {
      completions = {
        completeFunctionCalls = true,
      },
    },
  },
  -- taplo, a versatile, feature-rich TOML toolkit.
  -- taplo = {
  -- capabilities = user_default_capabilities,
  -- keys = {
  --   {
  --     "K",
  --     function()
  --       if vim.fn.expand("%:t") == "Cargo.toml" and require("crates").popup_available() then
  --         require("crates").show_popup()
  --       else
  --         vim.lsp.buf.hover()
  --       end
  --     end,
  --     desc = "Show Crate Documentation",
  --   },
  -- },
  -- },
  --
  ["null-ls"] = function()
    local null_ls = require("null-ls")
    local code_actions = null_ls.builtins.code_actions
    -- local completion = null_ls.builtins.completion
    local formatting = null_ls.builtins.formatting
    local diagnostics = null_ls.builtins.diagnostics

    local methods = null_ls.methods
    return {
      -- debug = true,
      --   -- root_dir(function) Determines the root of the null-ls server.
      --   -- On startup, null-ls will call root_dir with the full path to the first file that null-ls attaches to.
      --   -- root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
      sources = {
        -- Code Actions
        code_actions.gitrebase, -- { "gitrebase" }
        code_actions.gomodifytags, -- Go tool to modify struct field tags
        code_actions.impl, -- implementing an interface (go)
        code_actions.refactoring, -- { "go", "javascript", "lua", "python", "typescript" }

        -- Completion
        -- completion.spell, -- Spell suggestions, sounds good for plain text
        -- completion.luasnip,     -- DON'T use luasnip and tags, which have been sources of nvim-cmp.
        -- completion.tags,

        -- Diagnostics
        -- diagnostics.actionlint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                         -- GitHub Actions workflow files.
        -- diagnostics.buf,         -- Filetypes: { "proto" }
        -- diagnostics.checkmake.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                         -- Filetypes: { "make" }
        -- diagnostics.checkstyle.with({ extra_args = { "-c",
        -- "/google_checks.xml" }, }),   -- Filetypes: { "java" }
        diagnostics.cmake_lint, -- Filetypes: { "cmake" }
        -- diagnostics.codespell.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                           -- common misspellings in text files
        diagnostics.commitlint, -- conventional commit format.
        -- diagnostics.cppcheck,      -- fast static analysis of C/C++ code
        -- diagnostics.dotenv_linter, -- Lightning-fast linter for .env files.
        -- diagnostics.editorconfig_checker.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- .editorconfig
        diagnostics.golangci_lint, -- Go linter aggregator.
        -- diagnostics.hadolint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- Filetypes: { "dockerfile" }
        diagnostics.markdownlint.with({
          method = methods.DIAGNOSTICS_ON_SAVE,
        }), -- Markdown style and syntax checker.

        -- FIXME: implementing utils
        diagnostics.selene.with({
          condition = function(utils)
            return utils.root_has_file({ "selene.toml" })
          end,
          method = methods.DIAGNOSTICS_ON_SAVE,
        }), -- Lua code linter. Filetypes: { "lua", "luau" }
        -- diagnostics.staticcheck,   -- Advanced Go linter.
        diagnostics.todo_comments, -- comments
        -- diagnostics.vint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- Linter for Vimscript.
        -- diagnostics.yamllint.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- A linter for YAML files.
        -- diagnostics.zsh.with({
        --   method = methods.DIAGNOSTICS_ON_SAVE,
        -- }),                        -- zsh linter

        -- Formatting
        -- Formatter, linter, bundler, and more for JavaScript, TypeScript,
        -- JSON, HTML, Markdown, CSS and GraphQL.
        formatting.biome,
        formatting.buf, -- Protocol Buffers
        formatting.cmake_format,
        formatting.black, -- Python code linter
        -- By default, gopls uses gofmt for formatting Go code.
        formatting.gofumpt, -- A stricter version of gofmt with more stylistic rules.
        formatting.goimports, -- A superset of gofmt that also manages imports.
        -- formatting.google_java_format,
        -- formatting.markdownlint, -- A Node.js style checker and lint tool for Markdown files
        -- formatting.pg_format,     -- PostgreSQL SQL syntax beautifier
        formatting.prettier, -- an opinionated code formatter.(web files, json, markdown, GraphQL ...)
        -- formatting.prisma_format, -- Filetypes: { "prisma" }
        -- formatting.remark,        --  extensive and complex Markdown formatter/prettifier
        -- formatting.rustywind,     -- organizing Tailwind CSS classes
        formatting.shfmt, -- A shell parser, formatter, and interpreter with bash support.
        formatting.stylua, -- Filetypes: { "lua", "luau" }
        -- formatting.yamlfmt,

        -- Golang:
        -- gopls, provides IDE-like features such as autocompletion, linting,
        -- and formatting for Go code. It integrates with editors (like
        -- VSCode, Neovim, etc.) to offer real-time support for Go
        -- developers. It typically uses gofmt as the default formatter but
        -- can also be configured to use goimports or gofumpt.
        -- gofmt, the “standard” for Go code formatting, formats Go code according to a canonical style.
        -- goimports, a superset of gofmt that also manages imports.
        -- gofumpt, a stricter version of gofmt with more stylistic rules.

        -- lua:
        -- •	lua_ls: Real-time code intelligence and basic formatting, often integrated into editors.
        -- •	selene: A static analyzer and linter to check for code quality issues.
        -- •	stylua: A code formatter that enforces a consistent style across your Lua codebase.
      },
    }
  end,
}
setmetatable(M, M.mt)

-- The global defaults for all servers can be overridden by extending the
-- `default_config` table.
function M.update_global_default(user_default_conf)
  local lspconfig = require("lspconfig")
  lspconfig.util.default_config = vim.tbl_extend(
    "force",
    lspconfig.util.default_config,
    user_default_conf
    -- {
    --   autostart = true,
    --   handlers = {
    --     -- ["window/showMessage"] = function(err, method, params, client_id)
    --     --     if params and params.type <= vim.lsp.protocol.MessageType.Warning.Error then
    --     --       vim.lsp.handlers["window/showMessage"](err, method, params, client_id)
    --     --     end
    --     --   end,
    --   }
    -- }
  )
end

-- local function hook_setup_before()
--     -- setup clangd_extensions
--     -- local clangd_ext_opts = require("leovim.plugins.util").opts("clangd_extensions.nvim")
--     -- local status_ok, clangd_extensions = pcall(require, "clangd_extensions")
--     -- if status_ok then
--     -- clangd_extensions.setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
--     -- end
-- end
--
-- local function hook_setup_after()
--
-- end

function M.make_config(server_name, opts)
  return vim.tbl_deep_extend("keep", M[server_name], opts or {})
end

return M