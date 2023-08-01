return {
  -- WARN: trouble.nvim seems confix with Lazy.nvim
  -- when press U in Lazy UI, the window will lose focus which is ridiculous

  -- touble.nvim, enhanced Quickfix, better diagnostics list and others
  -- A pretty diagnostics, references, telescope results, quickfix and location list to help you solve all the troubles.
  -- usage:
  -- 		:Trouble {mode}						-- document_diagnostics| workspace_diagnostics| lsp_references | lsp_definitions | lsp_type_definitions | quickfix | loclist
  -- 		:TroubleToggle {mode}
  -- document_diagnostics: document diagnostics from the builtin LSP client
  -- workspace_diagnostics: workspace diagnostics from the builtin LSP client
  -- lsp_references: references of the word under the cursor from the builtin LSP client
  -- lsp_definitions: definitions of the word under the cursor from the builtin LSP client
  -- lsp_type_definitions: type definitions of the word under the cursor from the builtin LSP client
  -- quickfix: quickfix items
  -- loclist: items from the window's location list
  {
    "folke/trouble.nvim",
    enabled = false,
    opts = {
      -- mode = "workspace_diagnostics", 					-- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
      use_diagnostic_signs = true, -- enabling this will use the signs defined in your lsp client
      auto_open = true,            -- automatically open the list when you have diagnostics
      auto_close = true,           -- automatically close the list when you have no diagnostics

      -- action_keys = { -- key mappings for actions in the trouble list
      --      -- map to {} to remove a mapping, for example:
      --      -- close = {},
      --      close = "q", -- close the list
      --      cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
      --      refresh = "r", -- manually refresh
      --      jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
      --      open_split = { "<c-x>" }, -- open buffer in new split
      --      open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
      --      open_tab = { "<c-t>" }, -- open buffer in new tab
      --      jump_close = {"o"}, -- jump to the diagnostic and close the list
      --      toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
      --      switch_severity = "s", -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
      --      toggle_preview = "P", -- toggle auto_preview
      --      hover = "K", -- opens a small popup with the full multiline message
      --      preview = "p", -- preview the diagnostic location
      --      close_folds = {"zM", "zm"}, -- close all folds
      --      open_folds = {"zR", "zr"}, -- open all folds
      --      toggle_fold = {"zA", "za"}, -- toggle fold of current file
      --      previous = "k", -- previous item
      --      next = "j" -- next item
      -- },
      -- auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
      -- signs = {
      -- 	-- icons / text used for a diagnostic
      -- 	error = "",
      -- 	warning = "",
      -- 	hint = "",
      -- 	information = "",
      -- 	other = "",
      -- },
    },
    cmd = {
      "Trouble",
      "TroubleToggle"
    },
    keys = {
      { "<leader>tt", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document Diagnostics (Trouble)" },
      { "<leader>D",  "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
      { "<leader>L",  "<cmd>TroubleToggle loclist<cr>",               desc = "Location List (Trouble)" },
      { "<leader>Q",  "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix List (Trouble)" },
      {
        "[q",
        function()
          if require("trouble").is_open() then
            require("trouble").previous({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cprev)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Previous trouble/quickfix item",
      },
      {
        "]q",
        function()
          if require("trouble").is_open() then
            require("trouble").next({ skip_groups = true, jump = true })
          else
            local ok, err = pcall(vim.cmd.cnext)
            if not ok then
              vim.notify(err, vim.log.levels.ERROR)
            end
          end
        end,
        desc = "Next trouble/quickfix item",
      },
    },
  },
}
