local augroup_buffer = vim.api.nvim_create_augroup("leovim_buffer", { clear = true })
local augroup_window = vim.api.nvim_create_augroup("leovim_window", { clear = true })
local augroup_ft = vim.api.nvim_create_augroup("leovim_ft", { clear = true })
local augroup_edit = vim.api.nvim_create_augroup("leovim_edit", { clear = true })

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup_buffer,
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      local win = vim.api.nvim_get_current_win()
      pcall(vim.api.nvim_win_set_cursor, win, mark)
    end
  end,
})
-- TODO: call functions to format before saving (like ale does)
-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup_buffer,
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
  group = augroup_buffer,
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup_buffer,
  command = "checktime",
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup_ft,
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
    "fugitive",
    "Trouble",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup_ft,
  pattern = { "gitcommit", "gitrebase", "gitconfig" },
  command = "set bufhidden=delete",
})

-- more plain file types
vim.api.nvim_create_autocmd("FileType", {
  group = augroup_ft,
  pattern = { "gitcommit", "markdown", "text", "plaintex", "typst" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = augroup_ft,
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- resize splits if window got resized, maybe not good idea
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup_window,
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})
-- close_if_last_window: close all non-normal windows when the last normal window is closed
-- When using `:quit`, `:wq` or `:qall`, before deciding whether it closes the current window or quits Vim.
-- For `:wq` the buffer is written before QuitPre is triggered.
-- Can be used to close any non-essential window (quickfix, neo-tree, fugitive, spectre ...) if the current window is the last ordinary window.
vim.api.nvim_create_autocmd({ "QuitPre" }, {
  group = augroup_window,
  callback = function()
    local non_essential_filetypes = require("leovim.config.defaults").non_essential_filetypes

    local win_id = vim.api.nvim_get_current_win()
    local tabid = vim.api.nvim_get_current_tabpage()
    local wins = vim.api.nvim_tabpage_list_wins(tabid)

    local is_essential_win = function(win)
      local bufnr = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
      return not vim.tbl_contains(non_essential_filetypes, ft)
    end

    local essential_wins = vim.tbl_filter(is_essential_win, wins)
    local win_count = #essential_wins

    if win_count == 1 and is_essential_win(win_id) then
      -- close nonessential windows except current window which is closing
      for _, win in ipairs(wins) do
        if win ~= win_id then
          vim.api.nvim_win_close(win, true)
        end
      end
    end
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup_edit,
  callback = function()
    vim.highlight.on_yank()
  end,
})