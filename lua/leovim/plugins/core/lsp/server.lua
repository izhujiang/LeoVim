local function make_user_default_capabilities(user_capabilities)
  -- The nvim-cmp almost supports LSP's capabilities so You should
  -- advertise it to LSP servers..
  local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  local capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    has_cmp and cmp_nvim_lsp.default_capabilities() or {}
  )

  -- !!! DON'T enable cmp_nvim_lsp snippetSupport
  capabilities.textDocument.completion.completionItem.snippetSupport = false

  -- capabilities.textDocument.completion.completionItem.snippetSupport = true
  -- capabilities.textDocument.completion.completionItem.resolveSupport = {
  --   properties = {
  --     "documentation",
  --     "detail",
  --     "additionalTextEdits",
  --   },
  -- }
  capabilities = vim.tbl_deep_extend(
    "force",
    capabilities,
    user_capabilities or {}
  )
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
        semanticTokens = false,
        -- semanticTokens = true,
      },
    },
  },

  jsonls = {
    capabilities = user_default_capabilities,
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
      }
    }
  },

  ts_ls = {
    -- DODO: change keybind
    -- keys = {
    --   { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
    --   { "<leader>cR", "<cmd>TypescriptRenameFile<CR>",      desc = "Rename File" },
    -- },

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
