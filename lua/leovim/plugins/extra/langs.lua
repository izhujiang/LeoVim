return {
  {
    -- autoclose and autorename html tag
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "jsx", "tsx" },
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },

  -- Python vertual environment Selector
  {
    "linux-cultist/venv-selector.nvim",
    enabled = false,
    dependencies = {
      "neovim/nvim-lspconfig",
      "mfussenegger/nvim-dap-python"
    },
    opts = {
      dap_enabled = true,
    },
    cmd = "VenvSelect",
    keys = { { "<leader>pv", "<cmd>:VenvSelect<cr>", desc = "Select VirtualEnv" } },
  },

  -- Clangd's off-spec features for neovim's LSP client
  {
    "p00f/clangd_extensions.nvim",
    enabled = false, -- don't forget to uncomment "hrsh7th/nvim-cmp" in clangd when enabled = true.
    dependencies = {
      {
        -- "hrsh7th/nvim-cmp",
        -- optional = true,
        -- opts = function(_, opts)
        --   -- table.insert(opts.sorting.comparators, 1, require("clangd_extensions.cmp_scores"))
        -- end,
      },
    },
    ft = { "c", "c++" },
    opts = {
      extensions = {
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
        },
      },
    },
    config = function(_, opts)
      require("clangd_extensions").setup(opts)
    end,
  },


  -- TODO:config for rust-tools and cmp are not ready.
  -- Tools for better development in rust using neovim's builtin lsp
  {
    "simrat39/rust-tools.nvim",
    enabled = false, -- don't forget uncomment "hrsh7th/nvim-cmp" in rust when rust-tools enabled = true
    lazy = true,
    opts = function()
      local ok, mason_registry = pcall(require, "mason-registry")
      local adapter ---@type any
      if ok then
        -- rust tools configuration for debugging support
        local codelldb = mason_registry.get_package("codelldb")
        local extension_path = codelldb:get_install_path() .. "/extension/"
        local codelldb_path = extension_path .. "adapter/codelldb"
        local liblldb_path = vim.fn.has("mac") == 1 and extension_path .. "lldb/lib/liblldb.dylib"
            or extension_path .. "lldb/lib/liblldb.so"
        adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path)
      end
      return {
        dap = {
          adapter = adapter,
        },
        tools = {
          on_initialized = function()
            vim.cmd([[
              augroup RustLSP
                autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
              augroup END
            ]])
          end,
        },
      }
    end,
  },
  -- Extend auto completion for rust
  -- {
  --   "hrsh7th/nvim-cmp",
  --   enabled = false,
  --   optional = true,
  --   dependencies = {
  --     {
  --       "Saecki/crates.nvim",
  --       event = { "BufRead Cargo.toml" },
  --       config = true,
  --     },
  --   },
  --   opts = function(_, opts)
  --     local cmp = require("cmp")
  --     opts.sources = cmp.config.sources(vim.list_extend(opts.sources, {
  --       { name = "crates" },
  --     }))
  --   end,
  -- },
}
