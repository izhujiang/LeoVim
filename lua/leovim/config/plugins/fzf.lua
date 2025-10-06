return {
  opts = {
    -- use the "hide" profile
    "hide",
    -- MISC GLOBAL SETUP OPTIONS
    winopts = { -- UI Options
      -- BUG: require("treesitter-context.render").close_leaked_contexts() is called in fzf-lua(fzf-lua/lua/fzf-lua/previewer/builtin.lua:92),
      -- which has been removed, guess that is replaced with function M.close_contexts(exclude_winids)
      treesitter = false, -- Disable treesitter context integration,
    },
    -- keymap = { ...  },      -- Neovim keymaps / fzf binds
    -- actions = { ...  },     -- Fzf "accept" binds
    -- fzf_opts = { ...  },    -- Fzf CLI flags
    -- fzf_colors = { ...  },  -- Fzf `--color` specification
    -- hls = { ...  },         -- Highlights
    -- previewers = { ...  },  -- Previewers options
    -- SPECIFIC COMMAND/PICKER OPTIONS, SEE BELOW
    -- files = {
    --    -- fd/rg ignores patterns from .gitignore, by default.
    --    -- both fd and rg rely on the same ignore logic as Git,
    --    -- which means fd/rg must run in the directory under .git repository. TRY:
    --    -- git rev-parse --show-toplevel
    -- fd_opts = [[--olor
    --   -- no_ignore = false,
    -- },
  },

  keys = {
    --  /                       -- builtin search forward for pattern
    --  <leader>/ blines        -- line (search with pattern) in the current buffer
    --  <leader>s lines         -- lines (search with pattern) in loaded buffers
    --  <leader>S live_grep     -- live grep current project
    --                             rg search result; relaunch ripgrep on every keystroke

    { "<leader>/", "<cmd>FzfLua blines<cr>", desc = "Search (current buffer lines)" },
    { "<leader>s", "<cmd>FzfLua lines<cr>", desc = "Search (loaded buffer lines)" },
    { "<leader>S", "<cmd>FzfLua live_grep<cr>", desc = "Search (live grep)" },

    -- pattern: <leader>f{target} desc="{target}"
    --
    -- repeat last find
    { "<leader>f.", "<cmd>FzfLua resume<cr>", desc = "Last find" },
    { "<leader>f:", "<cmd>FzfLua command_history<cr>", desc = "Command(:) history" },
    { "<leader>f/", "<cmd>FzfLua search_history<cr>", desc = "Search(/) history" },
    { "<leader>f'", "<cmd>FzfLua marks<cr>", desc = "Mark" },
    { '<leader>f"', "<cmd>FzfLua registers<cr>", desc = "Register" },

    { "<leader>fa", "<cmd>FzfLua autocmds<cr>", desc = "Autocmd" }, -- autocmd list
    { "<leader>fb", "<cmd>FzfLua buffers<cr>", desc = "Buffer" },
    { "<leader>fc", "<cmd>FzfLua commands<cr>", desc = "ExCommand" },
    { "<leader>fC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme" },
    -- diagnostics
    { "<leader>fd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Diagnostic(buffer)" },
    { "<leader>fD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Diagnostic(workspace)" },
    {
      "<leader>fe",
      function()
        require("fzf-lua").files()
      end,
      desc = "File(cwd)",
    },
    {
      "<leader>ff",
      function()
        local root = require("leovim.utils").get_root()
        require("fzf-lua").files({ cwd = root })
      end,
      desc = "File(root)",
    },
    -- git
    { "<leader>fgb", "<cmd>FzfLua git_blame<cr>", desc = "git blame" },
    { "<leader>fgB", "<cmd>FzfLua git_branches<cr>", desc = "git branchs" },
    { "<leader>fgc", "<cmd>FzfLua git_bcommits<cr>", desc = "git commits(buffer)" },
    { "<leader>fgC", "<cmd>FzfLua git_commits<cr>", desc = "git commits" },
    { "<leader>fgd", "<cmd>FzfLua git_diff<cr>", desc = "git diff" },
    { "<leader>fgf", "<cmd>FzfLua git_files<cr>", desc = "git files" },
    { "<leader>fgh", "<cmd>FzfLua git_hunks<cr>", desc = "git hunks" },
    { "<leader>fgs", "<cmd>FzfLua git_status<cr>", desc = "git status" },
    { "<leader>fgw", "<cmd>FzfLua git_worktrees<cr>", desc = "git worktrees" }, -- replace git_stash
    { "<leader>fgt", "<cmd>FzfLua git_tags<cr>", desc = "git tags" },

    { "<leader>fh", "<cmd>FzfLua helptags<cr>", desc = "Helptag" },
    { "<leader>fk", "<cmd>FzfLua keymaps<cr>", desc = "Keymap" },
    { "<leader>fj", "<cmd>FzfLua jumps<cr>", desc = "Jump" },

    { "<leader>fla", "<cmd>FzfLua lsp_code_actions<cr>", desc = "Code action" },
    { "<leader>flc", "<cmd>FzfLua lsp_incoming_calls<cr>", desc = "Incoming call" },
    { "<leader>flC", "<cmd>FzfLua lsp_outgoing_calls<cr>", desc = "Outgoing call" },
    { "<leader>fld", "<cmd>FzfLua lsp_definitions<cr>", desc = "Definition" },
    { "<leader>flD", "<cmd>FzfLua lsp_declarations<cr>", desc = "Declaration" },
    { "<leader>fll", "<cmd>FzfLua lsp_finder<cr>", desc = "LSP finder" },
    { "<leader>fli", "<cmd>FzfLua lsp_implementations<cr>", desc = "Implementation" },
    { "<leader>flr", "<cmd>FzfLua lsp_references<cr>", desc = "Reference" },
    { "<leader>fls", "<cmd>FzfLua lsp_document_symbols<cr>", desc = "Symbol(document)" },
    -- { "<leader>flS", "<cmd>FzfLua lsp_workspace_symbols<cr>", desc = "Symbol(workspace)" },
    { "<leader>flS", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", desc = "Symbol(live workspace)" },
    { "<leader>flt", "<cmd>FzfLua lsp_typedefs<cr>", desc = "Type definition" },

    { "<leader>fm", "<cmd>FzfLua marks<cr>", desc = "Mark" },
    { "<leader>fM", "<cmd>FzfLua man_pages<cr>", desc = "Manpage" },
    { "<leader>fq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix" },
    { "<leader>fQ", "<cmd>FzfLua loclist<cr>", desc = "Loclist" },
    { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent file" },
    { "<leader>fs", "<cmd>FzfLua spell_suggest<cr>", desc = "Spell suggest" },

    -- For Intra-File Navigation: Yes, Tree-sitter can replace tags within a single file.
    -- Its real-time parsing is very useful for jumping to definitions, functions, or classes within a file.
    { "<leader>ft", "<cmd>FzfLua treesitter<cr>", desc = "Treesitter" },
    -- Cross-file navigation: Use tags or a language server for fast, project-wide symbol indexing and jumping to definitions
    { "<leader>fT", "<cmd>FzfLua tags<cr>", desc = "Tag" },

    { "<leader>fw", "<cmd>FzfLua grep_cword<cr>", desc = "Search(grep) current word" },
    -- :Fzf combine
    -- { "<leader>fz", "<cmd>FzfLua zoxide<cr>", desc = "Recent directory" }, -- zoxide

    -- TODO: DAP support
    {
      "<C-x><C-f>",
      function()
        require("fzf-lua").complete_path()
      end,
      mode = { "n", "v", "i" },
      desc = "Complete path",
    },
    {
      "<C-x><C-l>",
      function()
        require("fzf-lua").complete_line()
      end,
      mode = { "n", "v", "i" },
      desc = "Complete line",
    },
  },
}
