return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, {
          "c",
          "cpp",
        })
      end
    end,
  },

  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "clangd",   -- lsp
        "codelldb", -- debugger adapter
      })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
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
      },

      setup = {
        -- setup clangd_extensions
        -- local clangd_ext_opts = require("leovim.util").opts("clangd_extensions.nvim")
        -- local status_ok, clangd_extensions = pcall(require, "clangd_extensions")
        -- if status_ok then
        -- clangd_extensions.setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
        -- end
        -- clangd = function(_, _)
        -- end,
      },
    },
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
    ft = { "c", "cpp" },
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

  {
    "mfussenegger/nvim-dap",
    opts = function()
      local conf = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          processId = function()
            return require("dap.utils").pick_process
          end,
          cwd = "${workspaceFolder}",
        },

        -- {
        --   name = 'Launch',
        --   type = 'lldb',
        --   request = 'launch',
        --   program = function()
        --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        --   end,
        --   cwd = '${workspaceFolder}',
        --   stopOnEntry = false,
        --   args = {},
        --   -- runInTerminal = false,
        --   -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --   --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --   -- Otherwise you might get the following error:
        --   --    Error on launch: Failed to attach to the target process
        --   -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        -- }
      }

      return {
        adapters = {
          codelldb = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "codelldb",
              args = {
                "--port",
                "${port}",
              },
            },
          },
        },
        configurations = {
          c = conf,
          cpp = conf,
          rust =_conf

        },
      }
    end,
  }

}
