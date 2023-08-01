local function augroup(name)
  return vim.api.nvim_create_augroup("leovim_" .. name, { clear = true })
end

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local exclude = { "gitcommit" }
    local buf = vim.api.nvim_get_current_buf()
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
      return
    end
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, buf, mark)
    end
  end,
})

-- close some filetypes with <q>
-- NOTE: wonderful, register filetypes to quit with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
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
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- TODO: to close all non-normal windows when the last normal window is closed
-- close_if_last_window

-- When using `:quit`, `:wq` or `:qall`, before deciding whether it closes the current window or quits Vim.
-- For `:wq` the buffer is written before QuitPre is triggered.
-- Can be used to close any non-essential window (quickfix, neo-tree, fugitive, spectre ...) if the current window is the last ordinary window.
-- vim.api.nvim_create_autocmd({ "QuitPre" }, {
-- 	group = augroup("close_if_last_window"),
-- 	callback = function()
-- 		-- add more filetypes
-- 		local filetypes = {
-- 			"spectre_panel",
-- 			"fugitive",
-- 		}
--
-- 		local current_tabpage = vim.api.nvim_get_current_tabpage()
-- 		local window_count = vim.fn.tabpagewinnr(current_tabpage, "$")
-- 		-- FIX: vim.fn.tabpagewinnr return not 1, guess that notice create another two windows
--
-- 		-- Close Neovim if there's only one window left (the last one)
-- 		if window_count == 1 then
-- 			-- Check if the current buffer's filetype is "spectre_panel"
-- 			local current_buf = vim.api.nvim_win_get_buf(0)
-- 			local filetype = vim.api.nvim_buf_get_option(current_buf, "filetype")
--
-- 			-- for k,ft in pairs(filetypes) do
-- 				-- if ft == filetype then
-- 					-- Save any changes before closing, if necessary (optional)
-- 					-- vim.cmd("w")
--
-- 					-- Close the last window and exit Neovim
-- 					vim.cmd("qall!")
-- 				-- end
-- 			-- end
-- 		end
-- 	end,
-- })
