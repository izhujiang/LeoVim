-- This file is automatically loaded by leovim.config.init

local Util = require("leovim.util")

-- Disable builtin keybinds
vim.keymap.set("", ",", "<Nop>", { silent = true })
vim.keymap.set("", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("", "<Right>", "<Nop>", { silent = true })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })

vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })

vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Windows
vim.keymap.set("n", "<leader>-", vim.cmd.split, { desc = "Split window", remap = false })
vim.keymap.set("n", "<leader>|", vim.cmd.vsplit, { desc = "VSplit window", remap = false })
vim.keymap.set("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Quit", remap = false })
vim.keymap.set("n", "<leader>aw", "<Cmd>wincmd p<CR>", { desc = "Window", remap = true })

-- Move to window using the <ctrl> hjkl keys
-- " Should disable ^<-, ^->, ^↑, ^↓ in MissionControl shortcuts (macos)
vim.keymap.set({ "n", "i", "t" }, "<C-h>", "<Cmd>wincmd h<CR>", { desc = "Go to left window", remap = false })
vim.keymap.set({ "n", "i", "t" }, "<C-j>", "<Cmd>wincmd j<CR>", { desc = "Go to lower window", remap = false })
vim.keymap.set({ "n", "i", "t" }, "<C-k>", "<Cmd>wincmd k<CR>", { desc = "Go to upper window", remap = false })
vim.keymap.set({ "n", "i", "t" }, "<C-l>", "<Cmd>wincmd l<CR>", { desc = "Go to right window", remap = false })

-- Resize window using <ctrl> arrow keys
vim.keymap.set("n", "<C-Up>", "<Cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<Cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<Cmd>vertical resize -5<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<Cmd>vertical resize +5<CR>", { desc = "Increase window width" })

-- buffers
vim.keymap.set("n", "<leader>w", vim.cmd.write, { desc = "Save" })
vim.keymap.set("n", "<leader>x", function()
  require("leovim.util.buffer").buf_kill()
end, { desc = "Close" })

vim.keymap.set("n", "[b", vim.cmd.bprevious, { desc = "Prev buffer" })
vim.keymap.set("n", "]b", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "[B", vim.cmd.first, { desc = "First buffer" })
vim.keymap.set("n", "]B", vim.cmd.last, { desc = "Last buffer" })
vim.keymap.set("n", "<leader>ab", "<Cmd>buf #<CR>", { desc = "Buffer" })

-- tabs
vim.keymap.set("n", "]t", vim.cmd.tabnext, { desc = "Next tab" })
vim.keymap.set("n", "[t", vim.cmd.tabprevious, { desc = "Previous tab" })
vim.keymap.set("n", "]T", vim.cmd.tablast, { desc = "Last tab" })
vim.keymap.set("n", "[T", vim.cmd.tabfirst, { desc = "First tab" })

-- Quickfix and Loclist (overrided by trouble.nvim)
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix item" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { desc = "Prev quickfix item" })
vim.keymap.set("n", "]Q", vim.cmd.clast, { desc = "Last quickfix item" })
vim.keymap.set("n", "[Q", vim.cmd.cfirst, { desc = "First quickfix item" })
vim.keymap.set("n", "]l", vim.cmd.lnext, { desc = "Next loclist item" })
vim.keymap.set("n", "[l", vim.cmd.lprevious, { desc = "Prev loclist item" })
vim.keymap.set("n", "]L", vim.cmd.llast, { desc = "Last loclist item" })
vim.keymap.set("n", "[L", vim.cmd.lfirst, { desc = "First loclist item" })

-- TODO: toggle quickfix and loclist by filter wininfo retruned via vim.fn.getwininfo()
-- Check if QuickFix or Location list window is open
-- vim.keymap.set("n", "<leader>Q", toggle_window("quickfix"), { desc = "Quickfix List" })
-- vim.keymap.set("n", "<leader>L", toggle_window("loclist"), { desc = "Location List" })

-- Search and substitute
-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set({ "n", "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set({ "n", "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

vim.keymap.set({ "n" }, "&", "<Cmd>&&<CR>", { desc = "Execute last substitute" })
vim.keymap.set({ "x" }, "&", "<Cmd>'<,'>&&<CR><Esc>", { desc = "Execute last substitute" })

vim.keymap.set({ "n" }, "<Esc>", vim.cmd.nohlsearch, { desc = "Escape and clear hlsearch" })
-- <leader>gu for "diff update"
vim.keymap.set("n", "<leader>gu", function()
  vim.cmd.nohlsearch()
  vim.cmd.diffupdate()
end, { desc = "Diff update" })

vim.keymap.set("n", "<leader>b", vim.cmd.make, { silent = false, desc = "Make/Compile" })

-- TODO: usefule for noraml text file, not for program
-- Ref: luarvim
-- Add undo break-points
-- vim.keymap.set("i", ",", ",<c-g>u")
-- vim.keymap.set("i", ".", ".<c-g>u")
-- vim.keymap.set("i", ";", ";<c-g>u")

-- Visual mode
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- better paste
vim.keymap.set("v", "p", "P")

-- Command mode
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true })
vim.keymap.set("c", "<C-k>", "<Up>", { silent = true })
vim.keymap.set("c", "<C-j>", "<Down>", { silent = true })
vim.keymap.set("c", "%%", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, silent = false })

-- toggle options (un-)
-- TODO: add others options (parse...)
vim.keymap.set("n", "<leader>od", Util.toggle_diagnostics, { desc = "Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>oc", function()
  Util.toggle("conceallevel", false, { 0, conceallevel })
end, { desc = "Conceal" })
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>oh", function()
    vim.lsp.inlay_hint(0, nil)
  end, { desc = "Inlay Hints" })
end
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.keymap.set("n", "<leader>os", function()
    Util.toggle("spell")
  end, { desc = "Spelling" })
  vim.keymap.set("n", "<leader>ow", function()
    Util.toggle("wrap")
  end, { desc = "Wrap" })
  vim.keymap.set("n", "<leader>ol", function()
    Util.toggle("relativenumber", true)
    Util.toggle("number")
  end, { desc = "Line Numbers" })
end

vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

vim.cmd.iabbrev("adn and")
vim.cmd.iabbrev("waht what")
vim.cmd.iabbrev("@@ m.zhujiang@gmail.com")
vim.cmd.iabbrev("ccopy Copyright 2017 Jiang Zhu, all rights reserved.")

vim.cmd.cnoreabbrev("W! w!")
vim.cmd.cnoreabbrev("Q! q!")
vim.cmd.cnoreabbrev("Qall! qall!")
vim.cmd.cnoreabbrev("Wq wq")
vim.cmd.cnoreabbrev("Wa wa")
vim.cmd.cnoreabbrev("wQ wq")
vim.cmd.cnoreabbrev("WQ wq")

vim.cmd.cnoreabbrev("<expr> make 'silent make \\| redraw!'")
-- rewrite grep command to run silently without press Enter to continue.
vim.cmd.cnoreabbrev("<expr> grep  (getcmdtype() ==# ':' && getcmdline() =~# '^grep')  ? 'silent grep': 'grep'")
vim.cmd.cnoreabbrev("<expr> lgrep (getcmdtype() ==# ':' && getcmdline() =~# '^lgrep') ? 'silent lgrep' : 'lgrep'")