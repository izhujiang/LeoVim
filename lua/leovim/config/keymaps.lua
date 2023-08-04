-- This file is automatically loaded by leovim.config.init

local Util = require("leovim.util")

vim.keymap.set("", ",", "<Nop>", { silent = true })
vim.keymap.set("", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("", "<Right>", "<Nop>", { silent = true })

-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Windows
vim.keymap.set("n", "<leader>|", vim.cmd.vsplit, { desc = "Split window vertically", remap = false })
vim.keymap.set("n", "<leader>-", vim.cmd.split, { desc = "Split windows", remap = false })
-- TODO: close or quit window
vim.keymap.set("n", "<leader>q", vim.cmd.exit, { desc = "Close window", remap = false })
-- vim.keymap.set("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
-- vim.keymap.set("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })

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
vim.keymap.set("n", "<leader>w", vim.cmd.write, { desc = "Write buffer" })
-- better to use cmd instead of shortcut
-- vim.keymap.set("n", "<leader>sw", "<Cmd>w !sudo tee >/dev/null %<CR>", { desc = "Sudo write readonly file" })
-- TODO: fix it
vim.api.nvim_create_user_command("SudoWrite", function(_) -- opts
  vim.cmd("w !sudo tee >/dev/null %")
end, { desc = "Sudo write readonly file" })

vim.keymap.set("n", "[`", "<Cmd>e #<CR>", { desc = "Switch to Other Buffer" })
-- new file
-- vim.keymap.set("n", "<C-n>", vim.cmd.enew, { desc = "New File" })
vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

vim.keymap.set("n", "<S-h>", vim.cmd.bprevious, { desc = "Prev buffer" })
vim.keymap.set("n", "<S-l>", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "[b", vim.cmd.bprevious, { desc = "Prev buffer" })
vim.keymap.set("n", "]b", vim.cmd.bnext, { desc = "Next buffer" })
vim.keymap.set("n", "[B", vim.cmd.first, { desc = "First buffer" })
vim.keymap.set("n", "]B", vim.cmd.last, { desc = "Last buffer" })

-- tabs
-- vim.keymap.set("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- vim.keymap.set("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
vim.keymap.set("n", "]t", "<Cmd>tabnext<CR>", { desc = "Next Tab" })
vim.keymap.set("n", "[t", "<Cmd>tabprevious<CR>", { desc = "Previous Tab" })
vim.keymap.set("n", "]T", "<Cmd>tablast<CR>", { desc = "Last Tab" })
vim.keymap.set("n", "[T", "<Cmd>tabfirst<CR>", { desc = "First Tab" })

-- Quickfix and Loclist
vim.keymap.set("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { desc = "Prev quickfix" })
vim.keymap.set("n", "]Q", vim.cmd.clast, { desc = "Last quickfix" })
vim.keymap.set("n", "[Q", vim.cmd.cfirst, { desc = "First quickfix" })

vim.keymap.set("n", "]l", vim.cmd.lnext, { desc = "Next loclist" })
vim.keymap.set("n", "[l", vim.cmd.lprevious, { desc = "Prev loclist" })
vim.keymap.set("n", "]L", vim.cmd.llast, { desc = "Last loclist" })
vim.keymap.set("n", "[L", vim.cmd.lfirst, { desc = "First loclist" })

-- Check if QuickFix or Location list window is open
-- BUG: getqflist({winid =0 }) return nil when QuickFix is oppend by other cammnd vim.lsp.buf.references <leader>gr
local function isListWindowOpen(winname)
  local win_id = -1
  if winname == "quickfix" then
    win_id = vim.fn.getqflist({ winid = 0 }).winid
  else
    win_id = vim.fn.getloclist(0).winid
  end
  if win_id ~= 0 then
    return true
  else
    return false
  end
end

local toggle_window = function(name)
  if name == "quickfix" then
    return function()
      if isListWindowOpen("quickfix") then
        vim.cmd.cclose()
      else
        vim.cmd.copen()
      end
    end
  elseif name == "loclist" then
    return function()
      if isListWindowOpen("loclist") then
        vim.cmd.lclose()
      else
        vim.cmd.lopen()
      end
    end
  else
    return function()
      print("Invalid: not quickfix or loclist window.")
    end
  end
end
vim.keymap.set("n", "<leader>Q", toggle_window("quickfix"), { desc = "Quickfix List" })
vim.keymap.set("n", "<leader>L", toggle_window("loclist"), { desc = "Location List" })

-- Search and substitute
vim.keymap.set({ "n" }, "<Esc>", vim.cmd.nohlsearch, { desc = "Escape and clear hlsearch" })
vim.keymap.set({ "n", "x" }, "&", "<Cmd>&&<CR>", { desc = "Execute last substitute" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
vim.keymap.set(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
vim.keymap.set("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
vim.keymap.set("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

vim.keymap.set("n", "<leader>b", vim.cmd.make, { silent = false })

-- TODO: usefule for noraml text file, not for program
-- Ref: luarvim
-- Add undo break-points
-- vim.keymap.set("i", ",", ",<c-g>u")
-- vim.keymap.set("i", ".", ".<c-g>u")
-- vim.keymap.set("i", ";", ";<c-g>u")

-- Insert Mode
-- Press jk fast to enter
-- vim.keymap.set("i", "jk", "<ESC>")

-- Visual mode
-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
-- Better paste
vim.keymap.set("v", "p", "P")

-- Command mode
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true })
vim.keymap.set("c", "<C-k>", "<Up>", { silent = true })
vim.keymap.set("c", "<C-j>", "<Down>", { silent = true })
vim.keymap.set("c", "%%", "getcmdtype() == ':' ? expand('%:p:h').'/' : '%%'", { expr = true, silent = false })

-- toggle options (un-)
-- TODO: add others options (parse...)
vim.keymap.set("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
vim.keymap.set("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
vim.keymap.set("n", "<leader>ul", function()
  Util.toggle("relativenumber", true)
  Util.toggle("number")
end, { desc = "Toggle Line Numbers" })
vim.keymap.set("n", "<leader>ud", Util.toggle_diagnostics, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
vim.keymap.set("n", "<leader>uc", function() Util.toggle("conceallevel", false, { 0, conceallevel }) end,
  { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

-- floating terminal
local floatTerm = function() Util.float_term(nil, { cwd = Util.get_root() }) end
vim.keymap.set("n", "<c-/>", floatTerm, { desc = "Terminal (root dir)" })
vim.keymap.set("n", "<c-_>", floatTerm, { desc = "which_key_ignore" })
vim.keymap.set("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

-- lazygit
vim.keymap.set("n", "<leader>gg",
  function() Util.float_term({ "lazygit" }, { cwd = Util.get_root(), esc_esc = false, ctrl_hjkl = false }) end,
  { desc = "Lazygit (root dir)" })
vim.keymap.set("n", "<leader>gG", function() Util.float_term({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false }) end,
  { desc = "Lazygit (cwd)" })


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
