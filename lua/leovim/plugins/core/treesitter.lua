return {
  {
    -- Nvim Treesitter configurations and abstraction layer
    "nvim-treesitter/nvim-treesitter",
    version = false, -- last release is way too old and doesn't work on Windows
    build = ":TSUpdate",
    event = { "VeryLazy" },
    cmd = {
      "TSInstall",
      "TSUninstall",
      "TSUpdateSync",
      "TSUpdate",
      "TSInstallSync",
      "TSInstallFromGrammar",
      "TSInstallInfo",
      "TSConfigInfo",
    },
    keys = {
      { "<leader>zt", "<cmd>TSConfigInfo<cr>",  desc = "Treesitter ConfigInfo" },
      { "<leader>zT", "<cmd>TSInstallInfo<cr>", desc = "Treesitter InstallInfo" },
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    opts = {
      -- -- Automatically install missing parsers when entering buffer, set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,

      -- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
      -- install other language parsers manually when necessary
      ensure_installed = {
        "comment",
        "bash",
        "c", "cpp",
        "go",
        "html",
        "javascript", "typescript",
        "lua",
        "python",
        "regex",
        "rust",
        "markdown", "markdown_inline",
      },

      -- -- List of parsers to ignore installing
      -- ignore_install = {},

      -- roadmap of nvim-treesitter,
      -- https://github.com/nvim-treesitter/nvim-treesitter/issues/4767
      -- TODO: nvim-treesitter will completely drop the module framework, plugins will instead handle setup and attaching themselves.
      -- the bundled modules(indent, incremental_selection, highlight, folding) should be removed:

      highlight = {
        enable = true,                             -- Enable Tree-sitter-based highlighting
        additional_vim_regex_highlighting = false, -- Disable traditional `syntax on`
        -- For most users and most languages, just using Tree-sitter without syntax on is the recommended approach.
        -- You might use both Tree-sitter and syntax on if you’re working with a language that Tree-sitter doesn’t fully support yet.
        -- In that case, you can enable additional_vim_regex_highlighting = true for that specific language.

        -- disable = { "c", "rust" },
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
      indent = {
        -- Import: Neovim’s will automatically use Tree-sitter for indentation if it is enabled.
        -- 1) Tree-sitter uses a real-time parser to handle indentation as you type,
        -- 2) Tree-sitter Integration with = Command (== v{motion}= gg=G) when you trigger the = command (for re-indentation).
        -- By default, Neovim uses the = command to re-indent code according to the traditional indentation rules.
        enable = true,
        -- disable = { "python", "css", "yaml" },

        -- Tree-sitter Indentation and  lsp.buf.format (LSP-based Formatting) can work together to provide a better overall development experience:
        -- •	Tree-sitter keeps indentation correct as you write and edit code.
        -- •	LSP formatting is called occasionally (manually or on save) to fully reformat your code according to a language’s style guide.
      },

    },
    config = function(_, opts)
      -- avoid running in headless mode since it's harder to detect failures
      if #vim.api.nvim_list_uis() == 0 then
        vim.notify("headless mode detected, skipping running setup for treesitter")
        return
      end

      -- disable syntax highlight
      vim.cmd("syntax off")

      -- disable traditional indentation and enable treesitter indentation
      vim.opt.autoindent = false  -- Disable automatic indentation
      vim.opt.smartindent = false -- Disable smart indentation
      vim.opt.cindent = false     -- Disable C-like indentation
      vim.cmd('filetype indent off')

      -- Enable Tree-sitter-based folding in Neovim
      vim.opt.foldmethod = "expr"                     -- Use an expression for folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Tree-sitter for folds
      -- Optional: Set folding options
      vim.opt.foldlevel = 99                          -- Start with all folds open
      vim.opt.foldenable = false                      -- Disable folding by default

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    -- plugin that shows the context of the currently visible buffer contents
    -- When scroll out of a function, class, or other block, the context will
    -- be displayed at the top of the screen.
    -- useful for long files or deeply nested code, providing immediate context about the surrounding structure.
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure it loads after nvim-treesitter
    cmd = {
      "TSContextToggle",
      "TSContextEnable",
      "TSContextDisable",
    },
    keys = {
      {
        "<M-t>",
        "<cmd>TSContextToggle<cr>",
        desc = "Toggle TSContext",
      },
    },
    opts = {
      enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
      -- max_lines = 0,        -- How many lines the window should span. Values <= 0 mean no limit.
      -- min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      -- line_numbers = true,   -- Relative number between content and context.
      -- multiline_threshold = 20, -- Maximum number of lines to show for a single context
      -- trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      -- mode = 'cursor',      -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- -- Separator between context and content. Should be a single character string, like '-'.
      -- -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = '-',
      -- zindex = 20, -- The Z-index of the context window
      -- on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    }
  },

  {
    -- treesitter plugin: Syntax aware text-objects, select, move, swap, and peek support.
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure it loads after nvim-treesitter
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- enable = true,
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
          ["@function.outer"] = "V",  -- linewise
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
          ["]]"] = { query = "@class.outer", desc = "Next class(start)" },

          -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queries.
          ["]o"] = { query = "@loop.*", desc = "Next loop" },
          -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }

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
    config = function(_, opts)
      require('nvim-treesitter.configs').setup({ textobjects = opts })
    end
  },

  {
    -- treesitter plugin: setting 'commentstring' option based on the cursor's location.
    -- TODO: unable to set /* %s */ for c/c++ code block, guess it's bug, wait...
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- Neovim (0.10) now has built-in support for commenting lines.
      -- First, disable the CursorHold autocommand of this plugin
      enable = true,
      enable_autocmd = false,

      languages = {
        c = { __default = '// %s', __multiline = '/* %s */' },
        rust = "// %s",
      },
    },
    config = function(_, opts)
      require('ts_context_commentstring').setup(opts)

      -- override the Neovim internal get_option function which is called whenever the commentstring is requested:
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
      end
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
  },
}