return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lua",
      })
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "lua-language-server",
        "stylua",
        "selene",
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
                -- path = {
                --   '?.lua',
                --   '?/init.lua',
                --   vim.fn.expand'~/.luarocks/share/lua/5.3/?.lua',
                --   vim.fn.expand'~/.luarocks/share/lua/5.3/?/init.lua',
                -- }
              },
              format = {
                enable = false,
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
        },
      },
      setup = {
        lua_ls = function(_, _)
          -- IMPORTANT: make sure to setup neodev BEFORE lspconfig lua_ls (opts' setup is called before require("lspconfig")[server].setup(server_opts))
          local status_ok, neodev = pcall(require, "neodev")
          if status_ok then
            neodev.setup({})
          end
        end,
      },
    },
  },

  -- TODO:
  -- Neovim setup for init.lua and plugin development with full signature help, docs and completion for the nvim lua API.
  {
    "folke/neodev.nvim",
    ft = { "lua" },
    -- config = function()
    --   -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    --   require("neodev").setup({
    --     -- add any options here, or leave empty to use the default settings
    --   })
    -- end,
  },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      if type(opts.sources) == "table" then
        local null_ls = require("null-ls")
        local formatting = null_ls.builtins.formatting
        local diagnostics = null_ls.builtins.diagnostics

        vim.list_extend(opts.sources, {
          -- The CLI looks for stylua.toml or .stylua.toml in the directory where the tool was executed.
          -- If not found, we search for an .editorconfig file, otherwise fall back to the default configuration.
          -- This feature can be disabled using --no-editorconfig
          formatting.stylua,
          -- formatting.stylua.with({
          --   condition = function(utils) -- indicating whether null-ls should register the source.
          --     return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          --   end,
          -- }),

          diagnostics.selene.with({
            condition = function(utils) -- indicating whether null-ls should register the source.
              return utils.root_has_file({ "selene.toml" })
            end,
          }),
        })
      end
    end,
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      { "jbyuki/one-small-step-for-vimkind" },
    },
    opts = {
      adapters = {
        nlua = function(callback, config)
          callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
        end,
      },
      configurations = {
        lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        },
      },
    },
  },

  -- an adapter for the Neovim lua language
  {
    "jbyuki/one-small-step-for-vimkind",
    keys = {
      {
        "<leader>daL",
        function()
          require("osv").launch({ port = 8086 })
        end,
        desc = "Adapter Lua Server",
      },
      {
        "<leader>dal",
        function()
          require("osv").run_this()
        end,
        desc = "Adapter Lua",
      },
    },
  },
}