return {
  {
    -- git signs, Git integration for Buffers
    "lewis6991/gitsigns.nvim",
    event = { "VeryLazy" },
    keys = require("leovim.builtin.gitsigns").keys or {},
    opts = require("leovim.builtin.gitsigns").opts or {},
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
    keys = require("leovim.builtin.diffview").keys or {},
    opts = require("leovim.builtin.diffview").opts or {},

    config = function(_, opts)
      require("diffview").setup(opts)

      -- TODO: use 'q' to exit diffview
      vim.keymap.set({ "n" }, "<leader>q", function()
        if #vim.api.nvim_list_tabpages() > 1 and vim.t.is_diffview_tabpage then
          -- vim.cmd.tabclose()
          vim.cmd("DiffviewClose")
        else
          -- todo: call fallback function instead
          vim.cmd.quit()
        end
      end, { silent = true, desc = "Quit" })
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
    keys = require("leovim.builtin.neogit").keys or {},
    opts = require("leovim.builtin.neogit").opts or {},
  },
}