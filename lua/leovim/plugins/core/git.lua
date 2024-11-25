return {
  -- git signs, Git integration for Buffers
  {
    "lewis6991/gitsigns.nvim",
    event = { "VeryLazy" },
    opts = {
      on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = function(user_opts)
          return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
        end

        vim.keymap.set("n", "]c",
          function()
            if vim.wo.diff then
              vim.cmd.normal({ ']c', bang = true })
            else
              -- vim.schedule(function()
              --   gs.next_hunk()
              -- end)
              gs.next_hunk({ navigation_message = false })
            end
          end,
          opts({ desc = "Next Hunk/Change" }))
        vim.keymap.set("n", "[c",
          function()
            if vim.wo.diff then
              vim.cmd.normal({ '[c', bang = true })
            else
              gs.prev_hunk({ navigation_message = false })
              -- vim.schedule(function()
              --   gs.prev_hunk()
              -- end)
            end
          end,
          opts({ desc = "Previous Hunk/Change" }))
        vim.keymap.set("n", "<leader>hb",
          function() gs.blame_line({ full = true }) end,
          opts({ desc = "Blame line" }))
        vim.keymap.set("n", "<leader>hB",
          gs.toggle_current_line_blame,
          opts({ desc = "Toggle Blameline" }))

        vim.keymap.set("n", "<leader>hd", gs.diffthis, opts({ desc = "Diff This" })) -- diff again the index
        vim.keymap.set("n", "<leader>hD",
          function() gs.diffthis("~") end,
          opts({ desc = "Diff This ~(Last Commit)" })) -- diff again last commit

        -- h for didden
        vim.keymap.set("n", "<leader>hh", gs.toggle_deleted, opts({ desc = "Toggle Deleted/Hidden" }))
        vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts({ desc = "Preview Hunk" }))

        vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts({ desc = "Reset Hunk" }))
        vim.keymap.set("v", "<leader>hr",
          function() gs.reset_hunk({ vim.fn.line("v"), vim.fn.line(".") }) end,
          opts({ desc = "Reset Hunk" }))
        vim.keymap.set("n", "<leader>hR", gs.reset_buffer, opts({ desc = "Reset Buffer" }))
        vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts({ desc = "Stage Hunk" }))
        vim.keymap.set("v", "<leader>hs",
          function() gs.stage_hunk(vim.fn.line("v"), { vim.fn.line(".") }) end,
          opts({ desc = "Stage hunk" }))
        vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts({ desc = "Stage Buffer" }))
        vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk, opts({ desc = "Undo Stage Hunk" }))

        vim.keymap.set("n", "<leader>hc", gs.toggle_signs, opts({ desc = "Toggle Signs" }))
        vim.keymap.set("n", "<leader>hn", gs.toggle_numhl, opts({ desc = "Toggle Numhl" }))
        vim.keymap.set("n", "<leader>hl", gs.toggle_linehl, opts({ desc = "Toggle Linehl" }))
        vim.keymap.set("n", "<leader>hw", gs.toggle_word_diff, opts({ desc = "Toggle WordDiff" }))

        -- Text object
        -- vim.keymap.set({ "o", "x" }, "ih", gs.select_hunk, opts({ desc = "Select Hunk" }))
        vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", opts({ desc = "Gitsigns select hunk" }))
      end,
    },
  },

  -- Single tabpage interface for easily cycling through diffs for all modified files for any git rev.
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",        desc = "DiffviewOpen" },
      { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "DiffviewFileHistory" },
    }
  },

  -- An interactive and powerful Git interface for Neovim
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- optional - Diff integration
      "nvim-telescope/telescope.nvim", -- optional
    },
    cmd = {
      "Neogit",
      "NeogitCommit",
      "NeogitLogCurrent",
      "NeogitResetState"
    },
    keys = {
      { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" }
    },
    opts = {
      disable_hint = true,
      disable_context_highlighting = true,
      disable_signs = true,
      filewatcher = {
        -- interval = 1000,
        enabled = false,
      },
      integrations = {
        telescope = true,
        diffview = true,
      }
    },
    config = true,
  },

  -- A simple terminal UI for git commands
  -- usage:
  --    https://www.youtube.com/watch?v=Ihg37znaiBo
  --    https://www.youtube.com/watch?v=CPLdltN7wgE
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "nvim-telescope/telescope.nvim",
    },
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>",                  desc = "LazyGit" },
      { "<leader>gG", "<cmd>LazyGitCurrentFile<cr>",       desc = "LazyGit(root)" },
      { "<leader>gc", "<cmd>LazyGitFilter<cr>",            desc = "LazyGit Filter" },
      { "<leader>gC", "<cmd>LazyGitFilterCurrentFile<cr>", desc = "LazyGit Filter(Buffer)" },
      {
        -- Telescope plugin, track all git repository visited in one nvim session.
        "<leader>fgg",
        function()
          -- load telescope and load_extension lazygit until keys
          if vim.g.lazygit_loaded == nil then
            require("telescope").load_extension("lazygit")
            vim.g.lazygit_loaded = true
          end

          require("telescope").extensions.lazygit.lazygit()
        end,
        desc = "Git Repositories(LazyGit)"
      }
    },
    init = function()
      vim.g.lazygit_floating_window_scaling_factor = 1

      -- Lazy loading lazygit.nvim for telescope functionality is not supported.
      -- By default the paths of each repo is stored only when lazygit is triggered.
      -- So update the paths of repositories on BufEnter event
      vim.api.nvim_create_autocmd("BufReadPost", {
        group = vim.api.nvim_create_augroup("leovim_lazygit", { clear = true }),
        pattern = "*",
        callback = function()
          require('lazygit.utils').project_root_dir()
        end,
      })
    end,
    -- config = function()
    -- The Telescope plugin is used to track all git repository visited in one nvim session.
    -- If don't want load telescope at this time, then require telescope and
    -- load_extension lazygit when lazygit is triggered by fgg keys pressed.

    -- require("telescope").load_extension("lazygit")
    -- end
  }
}
