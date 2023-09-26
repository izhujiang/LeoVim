return {
  {
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = {
      "TSConfigInfo",
      "TSInstall",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSInstallInfo",
      "TSInstallSync",
      "TSInstallFromGrammar",
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter-textobjects" }, -- treesitter plugin: Syntax aware text-objects, select, move, swap, and peek support.
      { "JoosepAlviste/nvim-ts-context-commentstring" }, -- treesitter plugin for setting the commentstring based on the cursor location.
    },
    opts = {
      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      ensure_installed = {
        "bash",
        "c",
        "cmake",
        "comment",
        "cpp",
        "css",
        "diff",
        "dockerfile",
        "dot",
        "gitcommit",
        "go",
        "gomod",
        "gosum",
        "gowork",
        "html",
        "javascript",
        "json",
        "json5",
        "jsonc",
        "latex",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "rust",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },

      sync_install = false, -- Install parsers synchronously (only applied to `ensure_installed`)

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      -- List of parsers to ignore installing (for "all")
      ignore_install = {},

      modules = {},

      -- TODO: config modules carefully which might conflict with other functionalities.
      -- Available modules: Highlight, Increment Selection, Indentation, Folding
      matchup = {
        enable = true, -- mandatory, false will disable the whole extension
        -- disable = { "c", "ruby" },  -- optional, list of language that will be disabled
      },
      highlight = {
        enable = true,
        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        -- disable = { "c", "rust" },
        disable = function(lang, buf)
          if vim.tbl_contains({ "latex" }, lang) then
            return true
          end

          local status_ok, big_file_detected = pcall(vim.api.nvim_buf_get_var, buf, "bigfile_disable_treesitter")
          return status_ok and big_file_detected
        end,

        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = { "python", "css", "yaml" },
      },
      incremental_selection = {
        enable = false,
        -- keymaps = {
        -- init_selection = "<C-space>",
        -- node_incremental = "<C-space>",
        -- scope_incremental = false,
        -- node_decremental = "<bs>",
        -- },
      },
      autopairs = {
        enable = true,
      },
      -- config nvim-ts-context-commentstring plugin
      context_commentstring = {
        enable = true,
        enable_autocmd = false,
        config = {
          -- Languages that have a single comment style
          go = "// %s",
          c = "// %s",
          cpp = "// %s",
          java = "// %s",
          lua = "-- %s",
          python = "# %s",
          sh = "# %s",
          ruby = "# %s",
          rust = "// %s",
          vim = '" %s',
          typescript = "// %s",
          css = "/* %s */",
          scss = "/* %s */",
          html = "<!-- %s -->",
          svelte = "<!-- %s -->",
          vue = "<!-- %s -->",
          json = "",
        },
      },
      autotag = {
        enable = false, -- autotag will be enabled by nvim-ts-autotag automatically
      },

      -- nvim-treesitter-textobjects(https://github.com/nvim-treesitter/nvim-treesitter-textobjects)
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = { query = "@function.outer", desc = "Outer of function" },
            ["if"] = { query = "@function.inner", desc = "Inner of function" },
            ["ac"] = { query = "@class.outer", desc = "Outer of class" },
            ["ic"] = { query = "@class.inner", desc = "Inner of class" },
            -- You can also use captures from other query groups like `locals.scm`
            ["as"] = { query = "@scope", query_group = "locals", desc = "Language scope" },
          },
          selection_modes = {
            ["@parameter.outer"] = "v", -- charwise
            ["@function.outer"] = "V", -- linewise
            ["@class.outer"] = "<c-v>", -- blockwise
          },
          include_surrounding_whitespace = false,
        },

        -- swap the node under the cursor with the next or previous one
        swap = {
          enable = true,
          swap_next = {
            ["<leader>ap"] = { query = "@parameter.inner", desc = "Swap next parameter" },
          },
          swap_previous = {
            ["<leader>aP"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
          },
        },

        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]m"] = { query = "@function.outer", desc = "Next function(start)" },
            -- ["]]"] = { query = "@class.outer", desc = "Next class(start)" },
            --
            -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
            ["]o"] = { query = "@loop.*", desc = "Next loop" },
            -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
            --
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            ["]M"] = { query = "@function.outer", desc = "Next function(end)" },
            -- ["]["] = { query = "@class.outer", desc = "Next class(end)" },
          },
          goto_previous_start = {
            ["[m"] = { query = "@function.outer", desc = "Previous function(start)" },
            -- ["[["] = { query = "@class.outer", desc = "Previous class(start)" },
          },
          goto_previous_end = {
            ["[M"] = { query = "@function.outer", desc = "Previous function(end)" },
            -- ["[]"] = { query = "@class.outer", desc = "Previous class(end)" },
          },
          -- Below will go to either the start or the end(more granular movements), whichever is closer.
          -- goto_next = {
          --   ["]d"] = "@conditional.outer",
          -- },
          -- goto_previous = {
          --   ["[d"] = "@conditional.outer",
          -- }
        },
        lsp_interop = {
          enable = false,
        },
      },
      textsubjects = {
        enable = false,
        keymaps = { ["."] = "textsubjects-smart", [";"] = "textsubjects-big" },
      },

      rainbow = {
        enable = false,
        extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
        max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
      },
    },
    ---@param opts TSConfig
    config = function(_, opts)
      -- avoid running in headless mode since it's harder to detect failures
      if #vim.api.nvim_list_uis() == 0 then
        vim.notify("headless mode detected, skipping running setup for treesitter")
        return
      end

      vim.cmd.syntax("off") -- tree-sitter highlight enabled along with syntax on

      if type(opts.ensure_installed) == "table" then
        ---@type table<string, boolean>
        local added = {}
        opts.ensure_installed = vim.tbl_filter(function(lang)
          if added[lang] then
            return false
          end
          added[lang] = true
          return true
        end, opts.ensure_installed)
      end

      require("nvim-treesitter.configs").setup(opts)

      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = true

      -- Bad idea!!!
      -- DON'T map ';', ',' with ts_repeat_move which disable the builtin last find(f/F)
      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      -- local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      -- vim.keymap.set({ "n", "x", "o" }, "\\", ts_repeat_move.repeat_last_move_previous)

      -- DON'T map f/t with ts_repeat_move which disable the builtin f/F, and disable the builtin last change '.'
      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end,
  },

  {
    -- Use treesitter to autoclose and autorename html tag
    "windwp/nvim-ts-autotag",
    ft = {
      "javascript",
      "typescript",
      "jsx",
      "tsx",
      "html",
      "xml",
      "astro",
    },
    config = function()
      require("nvim-ts-autotag").setup({
        -- filetypes = { "html", "xml" },
      })
    end,
  },
}