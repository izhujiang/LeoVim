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
      { "<leader>zit", "<cmd>TSInstallInfo<cr>", desc = "treesitter(install)" },
      { "<leader>ziT", "<cmd>TSConfigInfo<cr>", desc = "treesitter(config)" },
    },
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
    },
    opts = {
      -- Automatically install missing parsers when entering buffer,
      -- set to false if you don't have `tree-sitter` CLI installed locally
      auto_install = true,
      -- install other language parsers manually when necessary
      ensure_installed = {
        "comment",
        "bash",
        "c",
        "cpp",
        "go",
        "html",
        "javascript",
        "typescript",
        "lua",
        "python",
        "regex",
        "rust",
        "markdown",
        "markdown_inline",
      },
      -- -- List of parsers to ignore installing
      -- ignore_install = {},

      -- modules:
      -- roadmap of nvim-treesitter(https://github.com/nvim-treesitter/nvim-treesitter/issues/4767)
      -- nvim-treesitter will completely drop the module framework, plugins will instead handle setup and attaching themselves.
      -- the bundled modules(indent, incremental_selection, highlight, folding) should be removed:
      highlight = {
        enable = true, -- Enable Tree-sitter-based highlighting
        -- disable = { "c", "rust" },

        -- Disable traditional `syntax on`
        additional_vim_regex_highlighting = false,
        -- For most users and most languages, just using Tree-sitter without syntax on is the recommended approach.
        -- You might use both Tree-sitter and syntax on if you’re working with a language that Tree-sitter doesn’t fully support yet.
        -- In that case, you can enable additional_vim_regex_highlighting = true for that specific language.
      },

      incremental_selection = {
        enable = true,
        -- disable = { "yaml" },
        keymaps = {
          init_selection = "<S-space>",
          node_incremental = "<S-space>",
          -- <Ctrl-Shift-space>
          scope_incremental = "<C-S-space>",
          node_decremental = "<S-bs>",
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
    init = function()
      -- disable syntax highlight
      vim.cmd("syntax off")

      -- disable traditional indentation and enable treesitter indentation
      vim.opt.autoindent = false -- Disable automatic indentation
      vim.opt.smartindent = false -- Disable smart indentation
      vim.opt.cindent = false -- Disable C-like indentation
      vim.cmd("filetype indent off")

      -- Enable Tree-sitter-based folding in Neovim
      vim.opt.foldmethod = "expr" -- Use an expression for folding
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- Use Tree-sitter for folds
      -- Optional: Set folding options
      vim.opt.foldlevel = 99 -- Start with all folds open
      vim.opt.foldenable = false -- Disable folding by default
    end,
    config = function(_, opts)
      -- avoid running in headless mode since it's harder to detect failures
      if #vim.api.nvim_list_uis() == 0 then
        vim.notify("headless mode detected, skipping running setup for treesitter")
        return
      end

      require("nvim-treesitter.configs").setup(opts)
    end,
  },

  {
    -- plugin that shows the context of the currently visible buffer contents When scroll out of a function,
    -- class, or other block, the context will be displayed at the top of the screen.
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
        "<leader>uc",
        "<cmd>TSContextToggle<cr>",
        desc = "ts_context",
      },
    },
    opts = {
      enable = false, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = "-",
    },
  },

  {
    -- treesitter plugin: Syntax aware text-objects, select, move, swap, and peek support.
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" }, -- Ensure it loads after nvim-treesitter
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      select = {
        enable = true,
        -- Automatically jump forward to textobj
        lookahead = true,

        keymaps = {
          ["a="] = { query = "@assignment.outer", desc = "Outer of assignment" },
          ["i="] = { query = "@assignment.inner", desc = "Inner of assignment" },
          ["l="] = { query = "@assignment.lhs", desc = "Left_hand of assignment" },
          ["r="] = { query = "@assignment.rhs", desc = "Right_hand of assignment" },

          -- i for if
          ["ai"] = { query = "@conditional.outer", desc = "Outer of conditional" },
          ["ii"] = { query = "@conditional.inner", desc = "Inner of conditional" },
          ["al"] = { query = "@loop.outer", desc = "Outer of loop" },
          ["il"] = { query = "@loop.inner", desc = "Inner of loop" },

          ["ab"] = { query = "@block.outer", desc = "Outer of block" },
          ["ib"] = { query = "@block.inner", desc = "Inner of block" },

          -- for js/ts files
          ["a:"] = { query = "@property.outer", desc = "Outer of property" },
          ["i:"] = { query = "@property.inner", desc = "Inner of property" },
          ["l:"] = { query = "@property.lhs", desc = "left of property" },
          ["r:"] = { query = "@property.rhs", desc = "right of property" },

          ["aa"] = { query = "@parameter.outer", desc = "Outer of parameter/argument" },
          ["ia"] = { query = "@parameter.inner", desc = "Inner of parameter/argument" },

          -- k for invoKe(call) a function
          ["ak"] = { query = "@call.outer", desc = "Outer of function call" },
          ["ik"] = { query = "@call.inner", desc = "Inner of function call" },
          ["af"] = { query = "@function.outer", desc = "Outer of method/function" },
          ["if"] = { query = "@function.inner", desc = "Inner of method/function" },

          ["ac"] = { query = "@class.outer", desc = "Outer of class" },
          ["ic"] = { query = "@class.inner", desc = "Inner of class" },

          -- gcc for comment
          ["ag"] = { query = "@comment.outer", desc = "Outer of comment" },
          ["ig"] = { query = "@comment.inner", desc = "Inner of comment" },

          -- ["as"] = { query = "@local.scope", query_group = "locals", desc = "Select language scope" },
        },
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        include_surrounding_whitespace = true,
      },
      -- swap the node under the cursor with the next or previous one
      swap = {
        enable = true,
        swap_next = {
          ["gsa"] = { query = "@parameter.inner", desc = "Swap with next parameter" }, -- swap parameters/argument with next
          ["gs:"] = { query = "@property.outer", desc = "Swap with next property" }, -- swap parameters/argument with next-- swap object property with next
          ["gsf"] = { query = "@function.outer", desc = "Swap with next function" }, -- swap parameters/argument with next-- swap function with next
        },
        swap_previous = {
          ["gSa"] = { query = "@parameter.inner", desc = "Swap with previous parameter" }, -- swap parameters/argument with prev
          ["gS:"] = { query = "@property.outer", desc = "Swap with previous property" }, -- swap object property with prev
          ["gSf"] = { query = "@function.outer", desc = "Swap with previous function" }, -- swap function with previous
        },
      },
      move = {
        enable = true,
        set_pjumps = true, -- whether to set jumps in the jumplist

        goto_next_start = {
          ["]k"] = { query = "@call.outer", desc = "function call start" },
          ["]f"] = { query = "@function.outer", desc = "method/function start" },
          ["]i"] = { query = "@conditional.outer", desc = "conditional start" },
          ["]l"] = { query = "@loop.outer", desc = "loop start" },

          -- or use query from `$VIMRUNTIME/queries/<lang>/<query_group>.scm file or ${lazy}/nvim-treesitter/queries/<lang>/<query_group>.scm.
          ["]s"] = { query = "@scope", query_group = "locals", desc = "scope" },
          ["]z"] = { query = "@fold", query_group = "folds", desc = "fold" },
        },
        goto_next_end = {
          ["]K"] = { query = "@call.outer", desc = "function call end" },
          ["]F"] = { query = "@function.outer", desc = "method/function end" },
          ["]I"] = { query = "@conditional.outer", desc = "conditional end" },
          ["]L"] = { query = "@loop.outer", desc = "loop end" },
        },
        goto_previous_start = {
          ["[k"] = { query = "@call.outer", desc = "function call start" },
          ["[f"] = { query = "@function.outer", desc = "method/function start" },
          ["[i"] = { query = "@conditional.outer", desc = "conditional start" },
          ["[l"] = { query = "@loop.outer", desc = "loop start" },

          ["[s"] = { query = "@scope", query_group = "locals", desc = "scope" },
          ["[z"] = { query = "@fold", query_group = "folds", desc = "fold" },
        },
        goto_previous_end = {
          ["[K"] = { query = "@call.outer", desc = "function call end" },
          ["[F"] = { query = "@function.outer", desc = "method/function end" },
          ["[I"] = { query = "@conditional.outer", desc = "conditional end" },
          ["[L"] = { query = "@loop.outer", desc = "loop end" },
        },
      },
      -- lsp_interop useless
      -- lsp_interop = {
      --   enable = true,
      --   border = "none",
      --   floating_preview_opts = {},
      --   peek_definition_code = {
      --     ["<leader>df"] = "@function.outer",
      --     ["<leader>dF"] = "@class.outer",
      --   },
      -- },
    },
    config = function(_, opts)
      require("nvim-treesitter.configs").setup({ textobjects = opts })

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
      -- vim way: ; goes to the direction you were moving.
      vim.keymap.set({ "n", "x", "o" }, "].", ts_repeat_move.repeat_last_move)
      vim.keymap.set({ "n", "x", "o" }, "[.", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
      -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
      -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
      -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
    end,
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
        c = { __default = "// %s", __multiline = "/* %s */" },
        rust = "// %s",
      },
    },
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)

      -- override the Neovim internal get_option function which is called whenever the commentstring is requested:
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
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