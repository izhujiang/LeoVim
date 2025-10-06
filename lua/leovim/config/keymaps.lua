-- Disable builtin keybinds or mapping arrow keys to something more useful.
vim.keymap.set("n", ",", "<Nop>", { silent = true })
vim.keymap.set("n", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { silent = true })

vim.keymap.set("n", "\\", ",", { silent = true })

-- Navigation -----------------------------------
-- builtin keys since nvim-0.11
-- [q, ]q, [Q, ]Q,    --    Quickfix
-- [l, ]l, [L, ]L,    --    Location list
-- [t, ]t, [T, ]T,    --    Tags
-- [a, ]a, [A, ]A     --    Argument list
-- [b, ]b, [B, ]B     --    Buffer list
-- gt, gT             --    Tabpages
-- [s, ]s             --    Spell
-- [c, ]c             --    Diff/change

-- :close vs. :quit
--   - :close command is specifically for closing windows when you have multiple windows in a split layout,
--      Vim requires at least one window to be open in each tab, so it prevent the last one to close.
--   - while :quit is for closing windows/tabs/Vim itself.
--   - close the buffer but keep window open: :bdelete or :bd

-- Buffers and augument list -----------------------------------
vim.keymap.set("n", "<leader>%", "<Cmd>lcd %:p:h<CR>", { desc = "CWD" })
vim.keymap.set("n", "<leader>n", "<Cmd>ene | startinsert<CR>", { desc = "New file" })
vim.keymap.set("n", "<leader>e", ":e <C-r>=expand('%:p:h') . '/'<CR>", { desc = "Open file" })
vim.keymap.set("n", "<leader>w", vim.cmd.write, { silent = true, desc = "Save" })
vim.keymap.set("n", "<leader>W", vim.cmd.wall, { silent = true, desc = "Save all" })
vim.keymap.set("n", "<Leader>c", vim.cmd.bdelete, { silent = true, desc = "Close" })
-- :bwipeout like :bdelete, but really delete the buffer.
-- Everything(marks, options...) related to the buffer is lost. Don't use this.
-- vim.keymap.set("n", "<leader>C", vim.cmd.bwipeout, { silent = true, desc = "Close" })

-- alternate(Alt key) file /
-- <C-^>/<C-6>, or :buf #<CR>

-- argument list(vim's command args, vim multi-files) usage
-- :args {pattern}
-- :[range]argdo[!] {cmd}

-- Window(Ventana) commands
-- vim.keymap.set("n", "<leader>v", "<c-w>", { desc = "Window", remap = true })
-- vim.keymap.set({ "n", "t" }, "<leader>q", vim.cmd.quit, { silent = true, desc = "Quit" })
-- vim.keymap.set({ "n", "t" }, "<leader>Q", vim.cmd.only, { silent = true, desc = "Only" })

vim.keymap.set("n", "<leader><Bar>", vim.cmd.vsplit, { silent = true, desc = "Vsplit window" })
vim.keymap.set("n", "<leader>-", vim.cmd.split, { silent = true, desc = "Split window" })

-- window navigation
-- Use builtin <C-w>hjkl keybinds to jump between windows
-- Should disable ^<-, ^->, ^↑, ^↓ in MissionControl shortcuts (macos)
local wincmd = function(cmd)
  return function()
    vim.cmd.wincmd(cmd)
  end
end

-- vim.keymap.set({ "n", "t", "i" }, "<A-h>", wincmd("h"), { silent = true, desc = "left window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-j>", wincmd("j"), { silent = true, desc = "lower window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-k>", wincmd("k"), { silent = true, desc = "upper window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-l>", wincmd("l"), { silent = true, desc = "right window" })

-- how terminal emulators and terminal protocols handle keyboard input.
-- Why <C-6> and <C-^> work:
-- These are actually the same keybind (Ctrl+6 produces the ^ character in ASCII).
-- This combination happens to be representable in the traditional terminal protocol and gets passed through to Vim correctly.
-- Also: <C-2> (sometimes, may act like <C-@>)
-- Also: <C-$ or other characters> work.
-- Why <C-other numbers> don't work:
-- Most Ctrl+number combinations don't produce distinct, recognizable sequences in the terminal protocol.
-- The terminal either doesn't send anything meaningful to Vim, or sends the same sequence as another key, so Vim can't distinguish them.
--
-- <A-6>/<A-^> or <C-$> to alternate window, vs. <C-6>/<C-^> to alternate buffer
vim.keymap.set({ "n", "i", "t" }, "<A-6>", wincmd("p"), { silent = true, desc = "Recent window" })
vim.keymap.set({ "n", "i", "t" }, "<A-^>", wincmd("p"), { silent = true, desc = "Recent window" })
vim.keymap.set({ "n", "i", "t" }, "<C-$>", wincmd("p"), { silent = true, desc = "Recent window" })

-- windows resize
vim.keymap.set("n", "<A-Up>", "<Cmd>resize +2<CR>", { silent = true, desc = "Window height ++" })
vim.keymap.set("n", "<A-Down>", "<Cmd>resize -2<CR>", { silent = true, desc = "Window height --" })
vim.keymap.set("n", "<A-Left>", "<Cmd>vertical resize -5<CR>", { silent = true, desc = "Window width --" })
vim.keymap.set("n", "<A-Right>", "<Cmd>vertical resize +5<CR>", { silent = true, desc = "Window width ++" })

vim.keymap.set("i", "<A-Up>", "<Esc><Cmd>resize +2<CR>gi", { silent = true, desc = "win height ++" })
vim.keymap.set("i", "<A-Down>", "<Esc><Cmd>resize -2<CR>gi", { silent = true, desc = "win height --" })
vim.keymap.set("i", "<A-Left>", "<Esc><Cmd>vertical resize -5<CR>gi", { silent = true, desc = "win width --" })
vim.keymap.set("i", "<A-Right>", "<Esc><Cmd>vertical resize +5<CR>gi", { silent = true, desc = "win width ++" })

vim.keymap.set("t", "<A-Up>", "<C-\\><C-n><Cmd>resize +2<CR>a", { silent = true, desc = "Window height ++" })
vim.keymap.set("t", "<A-Down>", "<C-\\><C-n><Cmd>resize -2<CR>a", { silent = true, desc = "Window height --" })
vim.keymap.set("t", "<A-Left>", "<C-\\><C-n><Cmd>vertical resize -5<CR>a", { silent = true, desc = "Window width --" })
vim.keymap.set("t", "<A-Right>", "<C-\\><C-n><Cmd>vertical resize +5<CR>a", { silent = true, desc = "Window width ++" })

-- Tag-pages
-- use built-in gt/gT for :tabnext/tabprev or Ex-commands directly,
-- OR use (better) tmux to arrange workspaces

-- toggle(alternate) quickfix
vim.keymap.set("n", "<A-q>", function()
  if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { silent = true, desc = "Toggle quickfix" })

-- ? mapping to <A-l>
vim.keymap.set("n", "<A-Q>", function()
  if vim.fn.getloclist(0).winid ~= 0 then
    vim.cmd.lclose()
  else
    vim.cmd.lopen()
  end
end, { silent = true, desc = "Toggle loclist" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = vim.diagnostic.jump
  local count = next and 1 or -1
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ count = count, float = true, severity = severity })
  end
end
-- go and open diagnostic window (float window)
vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float, { desc = "Show diagnostic" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Previous diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Previous warning" })

-- traversal through change list
--    g;  -- Go to [count] older position in change list.
--    g,  -- Go to [count] newer position in change list.

-- diff
--    ]c   -- Jump forwards to the next start of a change.
--    [c   -- Jump backwards to the previous start of a change.
--    do (diff obtain) for :diffget (modify the current buffer to undo difference with another buffer)
--    dp (diff put) for :diffput (modify another buffer to undo difference with the current buffer)

-- move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<CR>", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<CR>gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<CR>gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- better paste
-- Better paste. With P, the unnamed register not changed, v_P is
-- repeatable.(ref :h v_p and v_P)
-- vim.keymap.set("n", "<leader>p", '"+gP', { desc = "Paste" })
-- paste over visual selection, not good for snippets completion
-- vim.keymap.set("v", "p", "P")

-- repeat search
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next match" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next match" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous match" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous match" })

-- repeat last substitution with flags
vim.keymap.set("n", "&", "<Cmd>&&<CR>", { desc = "Last substitute" })
vim.keymap.set("x", "&", "<Cmd>'<,'>&&<CR><Esc>", { desc = "Last substitute" })

-- clean highlight / diff update
vim.keymap.set("n", "<C-l>", function()
  vim.cmd.nohlsearch()
  if vim.api.nvim_get_option_value("diff", { win = 0 }) then
    vim.cmd.diffupdate()
  end
end, { silent = true, desc = "Clean highlight/Diff update" })

-- :Inspect, print out a human-readable representation of the given object.
vim.keymap.set("n", "<C-p>", "<Cmd>Inspect<CR>", { desc = "Inspect" }) -- vim.show_pos

-- Run make command, depend on language
-- vim.keymap.set("n", "<leader>B", "<Cmd>make<CR>", { desc = "make/compile" })

vim.cmd([[
cnoreabbrev <expr> grep getcmdtype() == ':' && getcmdline() =~# '^grep' ? 'silent grep' : 'grep'
cnoreabbrev <expr> lgrep getcmdtype() == ':' && getcmdline() =~# '^lgrep' ? 'silent lgrep' : 'lgrep'
]])

if vim.version().major == 0 and vim.version().minor >= 8 then
  vim.keymap.set("n", "<C-1>", "<Cmd>horizontal terminal<CR>", { desc = "Horizontal terminal", silent = true })
  vim.keymap.set("n", "<C-2>", "<Cmd>vertical terminal<CR>", { desc = "Vertical terminal", silent = true })
end

-- terminal mode
-- <Esc> switch terminal mode to normal mode (Not good idea, DON'T use <Esc> to
-- exit terminal mode, which change the behavior of <Esc> in shell)
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Normal Mode" })
-- <A-[> or <C-v><Esc> send <Esc> to the program running inside the terminal buffer
-- vim.keymap.set("t", "<A-[>", "<Esc>", { silent = true, desc = "<Esc>" })
-- vim.keymap.set("t", "<C-v><Esc>", "<Esc>", { desc = "<Esc>" })
--
-- vim.keymap.set("t", "<C-R>", [[<C-Bslash><C-N>"".nr2char(getchar())."pi"]],
-- { expr = true })
--
vim.keymap.set("t", "<C-d>", function()
  vim.cmd.bdelete({ bang = true })
end, { silent = true, desc = "Close" })

-- options
-- -------------------------------------------------------------------
vim.keymap.set("n", "<leader>ob", function()
  vim.opt.background = vim.opt.background:get() == "dark" and "light" or "dark"
end, { desc = "background" })

vim.keymap.set("n", "<leader>oc", function()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 3 or 0
end, { desc = "conceal" })

vim.keymap.set("n", "<leader>od", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "diagnostic" })

if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>oi", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
  end, { desc = "inlay hints" })
end

vim.keymap.set("n", "<leader>ol", function()
  vim.o.list = not vim.list
end, { desc = "listchars" })

vim.keymap.set("n", "<leader>on", function()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = "number" })

vim.keymap.set("n", "<leader>op", function()
  vim.api.nvim_set_option_value("paste", not vim.opt_local.paste:get(), { scope = "local" })
end, { desc = "paste", buffer = 0 })

vim.keymap.set("n", "<leader>ot", function()
  vim.b.ts_highlight = not vim.b.ts_highlight
  if vim.b.ts_highlight then
    vim.treesitter.start()
  else
    vim.treesitter.stop()
  end
end, { desc = "Treesitter", buffer = 0 })

vim.keymap.set("n", "<leader>ow", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "wrap" })

vim.keymap.set("n", "<leader>zz", "<Cmd>Lazy<CR>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>zh", "<Cmd>checkhealth<CR>", { desc = "Check health", silent = true })
vim.keymap.set("n", "<leader>zi", "<Cmd>checkhealth vim.lsp<CR>", { desc = "Info(LSP)", silent = true })
vim.keymap.set("n", "<leader>zl", "<Cmd>edit $NVIM_LOG_FILE<CR>", { desc = "Log(Neovim)", silent = true })
vim.keymap.set("n", "<leader>zn", require("leovim.utils").neovim_news, { desc = "Neovim News", silent = true })

-- command-line and command window
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true, desc = "Command window" })
vim.keymap.set("c", "<C-j>", "<Down>", { silent = false, desc = "next command" }) -- silent must be false
vim.keymap.set("c", "<C-k>", "<Up>", { silent = false, desc = "previous command" })
-- %% expands to the directory of the active buffer, like :w %% or :e %%
vim.keymap.set("c", "%%", function()
  return vim.fn.getcmdtype() == "<Cmd>" and vim.fn.expand("%:p:h") .. "/" or "%%"
end, { expr = true, desc = "Expand directory" })

-- command-line abbreviations
vim.cmd.cnoreabbrev("W! w!")
vim.cmd.cnoreabbrev("Q! q!")
vim.cmd.cnoreabbrev("Qall! qall!")
vim.cmd.cnoreabbrev("Wq wq")
vim.cmd.cnoreabbrev("Wa wa")
vim.cmd.cnoreabbrev("wQ wq")
vim.cmd.cnoreabbrev("WQ wq")
-- ++p to ensure its parent directory is created
vim.cmd.cnoreabbrev("w w ++p")

-- misc -------------------------------------------------------------------
-- Abbreviations, used in Insert mode, Replace mode and Command-line mode.
--    (1) save typing for often used long words.
--    (2) automatically correct obvious spelling errors.
vim.cmd([[
  iabbrev adn and
  iabbrev waht what
]])
vim.cmd.iabbrev("@@ m.zhujiang@gmail.com")
vim.cmd.iabbrev("ccopy Copyright {...}, all rights reserved.")

-- Populate argument list with quickfix filenames
vim.api.nvim_create_user_command("Qargs", function()
  vim.cmd("args " .. quickfix_filenames())
end, { desc = "Arguments from quickfix" })

-- not working in nvim, solution: https://www.youtube.com/watch?v=u1HgODpoijc
-- vim.api.nvim_create_user_command("WSudo", "w !sudo tee % >/dev/null", { desc = "Sudo Save" })

vim.api.nvim_create_user_command("CTagsGen", "!ctags -R --exclude=.git", { desc = "Run !ctags" })

-- Helper functions -------------------------------------------------------------------
function quickfix_filenames()
  local buffer_numbers = {}
  for _, quickfix_item in ipairs(vim.fn.getqflist()) do
    buffer_numbers[quickfix_item.bufnr] = vim.fn.bufname(quickfix_item.bufnr)
  end
  return table.concat(vim.tbl_map(vim.fn.fnameescape, vim.tbl_values(buffer_numbers)))
end
