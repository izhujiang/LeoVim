return {
  {
    -- git signs, Git integration for Buffers
    "lewis6991/gitsigns.nvim",
    event = { "VeryLazy" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = function(user_opts)
          return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
        end
        -- Navigation
        vim.keymap.set("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, opts({ desc = "change/hunk" }))
        vim.keymap.set("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, opts({ desc = "change/hunk" }))

        -- Actions
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts({ desc = "stage hunk" }))
        vim.keymap.set("n", "<leader>hu", gs.reset_hunk, opts({ desc = "unstage hunk" }))
        vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts({ desc = "stage buffer" }))
        vim.keymap.set("n", "<leader>hU", gs.reset_buffer, opts({ desc = "unstage buffer" }))
        vim.keymap.set("v", "<leader>hs", function()
          gs.stage_hunk(vim.fn.line("v"), { vim.fn.line(".") })
        end, opts({ desc = "stage hunk" }))
        vim.keymap.set("v", "<leader>hu", function()
          gs.reset_hunk({ vim.fn.line("v"), vim.fn.line(".") })
        end, opts({ desc = "unstage hunk" }))

        vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, opts({ desc = "show(preview) hunk" }))

        vim.keymap.set("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, opts({ desc = "blame line" }))
        vim.keymap.set("n", "<leader>hB", gs.blame, opts({ desc = "blame line" }))

        -- diff again the index
        vim.keymap.set("n", "<leader>hd", gs.diffthis, opts({ desc = "diff this(index)" }))
        -- diff again last commit
        vim.keymap.set("n", "<leader>hD", function()
          gs.diffthis("~")
        end, opts({ desc = "diff this~(last commit)" }))

        vim.keymap.set("n", "<leader>hq", gs.setqflist, opts({ desc = "quickfix(buffer)" }))
        vim.keymap.set("n", "<leader>hQ", function()
          gs.setqflist("all")
        end, opts({ desc = "quickfix(workspace)" }))

        -- Show blame information for the current line in virtual text.
        vim.keymap.set("n", "<leader>ohb", gs.toggle_current_line_blame, opts({ desc = "blame_line" }))
        vim.keymap.set("n", "<leader>ohd", gs.toggle_deleted, opts({ desc = "deleted" }))
        vim.keymap.set("n", "<leader>ohc", gs.toggle_signs, opts({ desc = "signs" }))
        vim.keymap.set("n", "<leader>ohn", gs.toggle_numhl, opts({ desc = "number highlight" }))
        vim.keymap.set("n", "<leader>ohl", gs.toggle_linehl, opts({ desc = "line highlight" }))
        vim.keymap.set("n", "<leader>ohw", gs.toggle_word_diff, opts({ desc = "word diff" }))

        -- Text object
        vim.keymap.set({ "o", "x" }, "ih", gs.select_hunk, opts({ desc = "select hunk" }))
      end,
    },
  },

  {
    -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
    -- usage:
    --  1. merge tool (:h diffview-merge-tool)
    --    :DiffviewOpen [git-rev] [options] [ -- {paths...}]
    --  2. file history (:h :DiffviewFileHistory)
    --    :[range]DiffviewFileHistory [paths] [options]
    --  3. keymaps on different views and panels
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      -- lists all commits (git-log)
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "diffview" },
      -- use <leader>q :tabclose to quit diffview instead
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "diffview history(%)" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "diffview history(branch)" },
    },
    opts = {
      hooks = {
        view_opened = function()
          vim.t.is_diffview_tabpage = true
        end,
      },
    },
    config = function(_, opts)
      require("diffview").setup(opts)

      -- TODO: use 'q' to exit diffview
      vim.keymap.set({ "n" }, "<leader>q", function()
        if #vim.api.nvim_list_tabpages() > 1 and vim.t.is_diffview_tabpage then
          -- vim.cmd.tabclose()
          vim.cmd("DiffviewClose")
        else
          vim.cmd.quit()
        end
      end, { silent = true, desc = "quit" })
    end,
  },
  {
    -- An interactive and powerful Git interface for Neovim
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "sindrets/diffview.nvim", -- optional - Diff integration
      "ibhagwan/fzf-lua",
    },
    cmd = {
      "Neogit", -- opens NeogitStatus tab
      "NeogitCommit", -- Opens the commit view for the specified SHA, or HEAD if left blank
      "NeogitLogCurrent", -- Opens log buffer for any changes to the current file or a path the user has specified
      "NeogitResetState", -- Performs a full reset of saved flags for all popups
    },
    keys = {
      -- Open the status buffer in a new tab
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "neogit" },
      { "<leader>gc", "<cmd>NeogitCommit<cr>", desc = "neogit commit(HEAD)" },
      { "<leader>gl", "<cmd>NeogitLogCurrent<cr>", desc = "neogit log(%)" },
    },
    opts = {
      -- disable_hint = true,
      -- disable_context_highlighting = true,
      disable_signs = true,
      filewatcher = {
        -- interval = 1000,
        enabled = true,
      },
      integrations = {
        diffview = true,
        fzf_lua = true,
      },
      telescope_sorter = nil,
      status = {
        recent_commit_include_author_info = true,
      },
    },
  },
  {
    -- A simple terminal UI for git commands
    -- usage:
    --    https://www.youtube.com/watch?v=Ihg37znaiBo
    --    https://www.youtube.com/watch?v=CPLdltN7wgE
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    cmd = {
      "LazyGit",
      -- Opens LazyGit in the root directory of git repository and focuses on the current file
      "LazyGitCurrentFile",
      "LazyGitFilter",
      -- Opens LazyGit with a filtered view showing only the git history of the current file
      "LazyGitFilterCurrentFile",
      "LazyGitConfig",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "lazygit" },
      -- Open buffer commits
      -- { "<leader>gc", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "buffer commits" },
      -- Open project commits
      -- { "<leader>gC", "<cmd>LazyGitFilter<cr>", desc = "project commits" },
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1
    end,
  },
}