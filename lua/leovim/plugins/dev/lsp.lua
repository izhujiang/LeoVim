return {
  {
    -- Quickstart configs for Nvim LSP
    -- nvim-lspconfig providing basic, default Nvim LSP client configurations for various LSP servers.
    "neovim/nvim-lspconfig",
    version = false, -- last release is way too old, version must > v0.1.6
    dependencies = {
      "williamboman/mason.nvim", -- ensure lsp servers has been installed. and mason/bin directory added to $PATH
    },
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>zi", "<cmd>LspInfo<cr>", desc = "Info(LSP)" },
      {
        "<leader>zL",
        function()
          vim.cmd.edit(vim.lsp.get_log_path())
        end,
        "<cmd>LspInfo<cr>",
        desc = "Log(LSP)",
      },
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        virtual_text = false,
      },
    },

    config = function(_, opts)
      local lspconfig = require("lspconfig")
      local lsp_server = require("leovim.plugins.dev.lsp.server")

      -- TODO: config server dynamically.
      local servers = { "lua_ls", "gopls", "clangd", "pyright", "rust_analyzer", "bashls", "cmake" }
      for _, server_name in ipairs(servers) do
        -- hook_setup_before()
        local lsp_server_conf = lsp_server.make_config(server_name, {})
        lspconfig[server_name].setup(lsp_server_conf)
        -- hook_setup_after()
      end

      local lsp_client = require("leovim.plugins.dev.lsp.client")
      lsp_client.setup(opts)
    end,
  },

  -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua.
  {
    "nvimtools/none-ls.nvim",
    -- enabled = false,
    event = { "BufReadPost", "BufNewFile" },
    keys = {
      { "<leader>zn", "<cmd>NullLsInfo<cr>", desc = "Info(null_ls)" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    opts = function()
      return require("leovim.plugins.dev.lsp.server")["null-ls"]()
    end,
  },

  -- The Refactoring library based off the Refactoring book by Martin Fowler
  -- Refactoring Features, Support for various common refactoring operations: Extract/Inline Function/Variable
  -- Debug Features, useful features for debugging(Printf, Print var, Cleanup)
  -- usage:
  --   '<,'>:Refactor operation
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
  },
}