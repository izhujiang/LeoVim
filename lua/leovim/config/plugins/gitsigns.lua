return {
  opts = {
    on_attach = function(bufnr)
      local gs = require("gitsigns")
      local opts = function(user_opts)
        return vim.tbl_extend("keep", user_opts or {}, { buffer = bufnr, noremap = true, silent = true })
      end
      -- Navigation
      vim.keymap.set("n", "]h", function()
        gs.nav_hunk("next", { wrap = false })
      end, opts({ desc = "Next hunk" }))
      vim.keymap.set("n", "[h", function()
        gs.nav_hunk("prev", { wrap = false })
      end, opts({ desc = "Previous hunk" }))
      vim.keymap.set("n", "]H", function()
        gs.nav_hunk("last")
      end, opts({ desc = "Last hunk" }))
      vim.keymap.set("n", "[H", function()
        gs.nav_hunk("first")
      end, opts({ desc = "First hunk" }))

      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts({ desc = "Stage hunk" }))
      vim.keymap.set("n", "<leader>hu", gs.reset_hunk, opts({ desc = "Unstage hunk" }))
      vim.keymap.set("n", "<leader>hS", gs.stage_buffer, opts({ desc = "Stage buffer" }))
      vim.keymap.set("n", "<leader>hU", gs.reset_buffer, opts({ desc = "Unstage buffer" }))
      vim.keymap.set("v", "<leader>hs", function()
        gs.stage_hunk(vim.fn.line("v"), { vim.fn.line(".") })
      end, opts({ desc = "stage hunk" }))
      vim.keymap.set("v", "<leader>hu", function()
        gs.reset_hunk({ vim.fn.line("v"), vim.fn.line(".") })
      end, opts({ desc = "unstage hunk" }))

      vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline, opts({ desc = "Preview hunk" }))

      vim.keymap.set("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, opts({ desc = "Blame line" }))
      vim.keymap.set("n", "<leader>hB", gs.blame, opts({ desc = "Blame buffer" }))

      vim.keymap.set("n", "<leader>hd", gs.diffthis, opts({ desc = "Diff this(index)" }))
      -- diff again last commit
      vim.keymap.set("n", "<leader>hD", function()
        gs.diffthis("~")
      end, opts({ desc = "Diff this~(last commit)" }))

      vim.keymap.set("n", "<leader>hq", gs.setqflist, opts({ desc = "Quickfix(buffer)" }))
      vim.keymap.set("n", "<leader>hQ", function()
        gs.setqflist("all")
      end, opts({ desc = "Quickfix(workspace)" }))

      -- -- Show blame information for the current line in virtual text.
      vim.keymap.set("n", "<leader>ohb", gs.toggle_current_line_blame, opts({ desc = "Blame_line" }))
      vim.keymap.set("n", "<leader>ohd", gs.toggle_deleted, opts({ desc = "Deleted" }))
      vim.keymap.set("n", "<leader>ohc", gs.toggle_signs, opts({ desc = "Signs" }))
      vim.keymap.set("n", "<leader>ohn", gs.toggle_numhl, opts({ desc = "Number highlight" }))
      vim.keymap.set("n", "<leader>ohl", gs.toggle_linehl, opts({ desc = "Line highlight" }))
      vim.keymap.set("n", "<leader>ohw", gs.toggle_word_diff, opts({ desc = "Word diff" }))
      -- Text object
      vim.keymap.set({ "o", "x" }, "ih", gs.select_hunk, opts({ desc = "Select hunk" }))
    end,
  },
}
