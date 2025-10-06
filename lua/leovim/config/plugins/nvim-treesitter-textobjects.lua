return {
  opts = {
    enable = true, -- Globally enable textobjects
    -- disable = function(_, buf)
    --   local disabled_filetypes = { "markdown", "text", "json" } -- List of disabled filetypes
    --   return vim.tbl_contains(disabled_filetypes, vim.bo[buf].filetype)
    -- end,
    -- or
    disable = function(_, buf)
      local enabled_filetypes = {
        "astro",
        "bash",
        "c",
        "cpp",
        "c_sharp",
        "cmake",
        "css",
        "cuda",
        "dockerfile",
        "go",
        "haskell",
        "html",
        "java",
        "javascript",
        "julia",
        "kotlin",
        "latex",
        "lua",
        "perl",
        "php",
        "python",
        "ruby",
        "rust",
        "svelte",
        "swift",
        "tsx",
        "typescript",
        "vim",
        "wgsl",
        "yaml",
        "zig",
      } -- List of allowed filetypes
      return not vim.tbl_contains(enabled_filetypes, vim.bo[buf].filetype)
    end,
    select = {
      enable = true,
      -- Automatically jump forward to textobj
      lookahead = true,

      keymaps = {
        ["a="] = { query = "@assignment.outer", desc = "Outer assignment" },
        ["i="] = { query = "@assignment.inner", desc = "Inner assignment" },
        ["l="] = { query = "@assignment.lhs", desc = "Left_hand assignment" },
        ["r="] = { query = "@assignment.rhs", desc = "Right_hand assignment" },

        -- i for if, conflict with the i in snacks' scope
        ["ai"] = { query = "@conditional.outer", desc = "Outer conditional" },
        ["ii"] = { query = "@conditional.inner", desc = "Inner conditional" },
        ["al"] = { query = "@loop.outer", desc = "Outer loop" },
        ["il"] = { query = "@loop.inner", desc = "Inner loop" },

        -- replace nvim builtin ab/ib that b alias (), ref :h ib
        ["ab"] = { query = "@block.outer", desc = "Outer block" },
        ["ib"] = { query = "@block.inner", desc = "Inner block" },

        -- for js/ts files
        ["a:"] = { query = "@property.outer", desc = "Outer property" },
        ["i:"] = { query = "@property.inner", desc = "Inner property" },
        ["l:"] = { query = "@property.lhs", desc = "Left property" },
        ["r:"] = { query = "@property.rhs", desc = "Right property" },

        ["aa"] = { query = "@parameter.outer", desc = "Outer parameter" },
        ["ia"] = { query = "@parameter.inner", desc = "Inner parameter" },

        -- k for invoKe(call) a function
        ["ak"] = { query = "@call.outer", desc = "Outer call" },
        ["ik"] = { query = "@call.inner", desc = "Inner call" },
        -- bug: call daf in last function will remove previous }. it is wrong that af move cursor to previous } (see yaf)
        ["af"] = { query = "@function.outer", desc = "Outer function" },
        ["if"] = { query = "@function.inner", desc = "Inner function" },

        ["ac"] = { query = "@class.outer", desc = "Outer class" },
        ["ic"] = { query = "@class.inner", desc = "Inner class" },

        -- gcc for comment
        ["ag"] = { query = "@comment.outer", desc = "Outer comment" },
        ["ig"] = { query = "@comment.inner", desc = "Inner comment" },

        -- builtin as for sentence, override it
        -- TODO: scope.inner(is) scope.outer(as) not available yet
        ["as"] = { query = "@local.scope", query_group = "locals", desc = "Language scope" },
        ["az"] = { query = "@fold", query_group = "folds", desc = "Fold" },
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
        ["gsa"] = { query = "@parameter.inner", desc = "Next parameter" }, -- swap parameters/argument with next
        ["gs:"] = { query = "@property.outer", desc = "Next property" }, -- swap parameters/argument with next-- swap object property with next
        ["gsf"] = { query = "@function.outer", desc = "Next function" }, -- swap parameters/argument with next-- swap function with next
      },
      swap_previous = {
        ["gSa"] = { query = "@parameter.inner", desc = "Previous parameter" }, -- swap parameters/argument with prev
        ["gS:"] = { query = "@property.outer", desc = "Previous property" }, -- swap object property with prev
        ["gSf"] = { query = "@function.outer", desc = "Previous function" }, -- swap function with previous
      },
    },
    move = {
      enable = true,
      set_pjumps = true, -- whether to set jumps in the jumplist

      goto_next_start = {
        ["]k"] = { query = "@call.outer", desc = "Next call start" },
        ["]f"] = { query = "@function.outer", desc = "Next function start" },
        ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
        ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

        -- or use query from `$VIMRUNTIME/queries/<lang>/<query_group>.scm file or ${lazy}/nvim-treesitter/queries/<lang>/<query_group>.scm.
        -- ]s [s override spell?
        ["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next language scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]K"] = { query = "@call.outer", desc = "Next call end" },
        ["]F"] = { query = "@function.outer", desc = "Next function end" },
        ["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
        ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
      },
      goto_previous_start = {
        ["[k"] = { query = "@call.outer", desc = "Previous call start" },
        ["[f"] = { query = "@function.outer", desc = "Previous function start" },
        ["[i"] = { query = "@conditional.outer", desc = "Previous conditional start" },
        ["[l"] = { query = "@loop.outer", desc = "Previous loop start" },

        ["[s"] = { query = "@local.scope", query_group = "locals", desc = "Previous language scope" },
        ["[z"] = { query = "@fold", query_group = "folds", desc = "Previous fold" },
      },
      goto_previous_end = {
        ["[K"] = { query = "@call.outer", desc = "Previous call end" },
        ["[F"] = { query = "@function.outer", desc = "Previous function end" },
        ["[I"] = { query = "@conditional.outer", desc = "Previous conditional end" },
        ["[L"] = { query = "@loop.outer", desc = "Previous loop end" },
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
}
