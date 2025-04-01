-- Disable builtin keybinds or mapping arrow keys to something more useful.
vim.keymap.set("n", ",", "<Nop>", { silent = true })
vim.keymap.set("n", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { silent = true })

vim.keymap.set("n", "\\", ",", { silent = true })
-- Buffers and augument list -----------------------------------
-- vim.keymap.set("n", "<leader>%", "<cmd>lcd %:p:h<cr>", { desc = "CWD" })
vim.keymap.set("n", "<leader>n", "<cmd>ene | startinsert<cr>", { desc = "New" })
vim.keymap.set("n", "<leader>e", "<cmd>e <C-r>=expand('%:p:h') . '/' <cr>", { desc = "Open" })
vim.keymap.set("n", "<leader>w", vim.cmd.write, { silent = true, desc = "Save" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<cr>", { silent = true, desc = "Save(no formatting)" })
vim.keymap.set("n", "<Leader>x", vim.cmd.bdelete, { silent = true, desc = "Unload" })
-- Like :bdelete, but really delete the buffer.  Everything(marks, options...) related to the buffer is lost.  Don't use this
-- vim.keymap.set("n", "<leader>X", vim.cmd.bwipeout, { silent = true, desc = "wipeout" })

vim.keymap.set("n", "]b", vim.cmd.bnext, { silent = true, desc = "Next buffer" })
vim.keymap.set("n", "[b", vim.cmd.bprevious, { silent = true, desc = "Previous buffer" })
vim.keymap.set("n", "]B", vim.cmd.blast, { silent = true, desc = "Last buffer" })
vim.keymap.set("n", "[B", vim.cmd.bfirst, { silent = true, desc = "First buffer" })
-- alternate(Alt key) / ultimate file /
-- <C-^>/<C-6>, or :buf #<cr>

-- argument list(vim's command args, vim multi-files) usage
-- :args {pattern}
-- :[range]argdo[!] {cmd}
-- vim.keymap.set("n", "]a", vim.cmd.next, { silent = true, desc = "Next argument" })
-- vim.keymap.set("n", "[a", vim.cmd.previous, { silent = true, desc = "Previous argument" })
-- vim.keymap.set("n", "]A", vim.cmd.last, { silent = true, desc = "Last argument" })
-- vim.keymap.set("n", "[A", vim.cmd.first, { silent = true, desc = "First argument" })

-- Window(Ventana) and tabpage commands
-- vim.keymap.set("n", "<leader>v", "<c-w>", { desc = "Window", remap = true })

vim.keymap.set({ "n", "t" }, "<leader>q", vim.cmd.quit, { silent = true, desc = "Quit" })
vim.keymap.set({ "n", "t" }, "<leader>Q", vim.cmd.only, { silent = true, desc = "Only" })

vim.keymap.set("n", "<leader><Bar>", vim.cmd.vsplit, { silent = true, desc = "Vsplit window" })
vim.keymap.set("n", "<leader>-", vim.cmd.split, { silent = true, desc = "Split window" })

-- window navigation
-- Use builtin <C-w>hjkl keybinds to jump between windows
-- Should disable ^<-, ^->, ^↑, ^↓ in MissionControl shortcuts (macos)
-- local wincmd = function(cmd)
--   return function()
--     vim.cmd.wincmd(cmd)
--   end
-- end

-- vim.keymap.set({ "n", "t", "i" }, "<A-h>", wincmd("h"), { silent = true, desc = "left window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-j>", wincmd("j"), { silent = true, desc = "lower window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-k>", wincmd("k"), { silent = true, desc = "upper window" })
-- vim.keymap.set({ "n", "t", "i" }, "<A-l>", wincmd("l"), { silent = true, desc = "right window" })

-- <A-6>/<A-^> alternate window, vs. <C-6>/<C-^> for alternate buffer
vim.keymap.set({ "n", "i", "t" }, "<A-6>", function()
  vim.cmd.wincmd("p")
end, { silent = true, desc = "Recent window" })
vim.keymap.set({ "n", "i", "t" }, "<A-^>", function()
  vim.cmd.wincmd("p")
end, { silent = true, desc = "Recent window" })
-- windows resize
vim.keymap.set("n", "<A-Up>", "<cmd>resize +2<cr>", { silent = true, desc = "Window height ++" })
vim.keymap.set("n", "<A-Down>", "<cmd>resize -2<cr>", { silent = true, desc = "Window height --" })
vim.keymap.set("n", "<A-Left>", "<cmd>vertical resize -5<cr>", { silent = true, desc = "Window width --" })
vim.keymap.set("n", "<A-Right>", "<cmd>vertical resize +5<cr>", { silent = true, desc = "Window width ++" })

vim.keymap.set("i", "<A-Up>", "<Esc><cmd>resize +2<cr>gi", { silent = true, desc = "win height ++" })
vim.keymap.set("i", "<A-Down>", "<Esc><cmd>resize -2<cr>gi", { silent = true, desc = "win height --" })
vim.keymap.set("i", "<A-Left>", "<Esc><cmd>vertical resize -5<cr>gi", { silent = true, desc = "win width --" })
vim.keymap.set("i", "<A-Right>", "<Esc><cmd>vertical resize +5<cr>gi", { silent = true, desc = "win width ++" })

vim.keymap.set("t", "<A-Up>", "<C-\\><C-n><cmd>resize +2<cr>a", { silent = true, desc = "Window height ++" })
vim.keymap.set("t", "<A-Down>", "<C-\\><C-n><cmd>resize -2<cr>a", { silent = true, desc = "Window height --" })
vim.keymap.set("t", "<A-Left>", "<C-\\><C-n><cmd>vertical resize -5<cr>a", { silent = true, desc = "Window width --" })
vim.keymap.set("t", "<A-Right>", "<C-\\><C-n><cmd>vertical resize +5<cr>a", { silent = true, desc = "Window width ++" })

-- Tag-pages
-- use built-in gt/gT for :tabnext/tabprev or Ex-commands directly,
-- OR use (better) tmux to arrange workspaces

-- Tags
vim.keymap.set("n", "]t", vim.cmd.tnext, { desc = "Next tag" })
vim.keymap.set("n", "[t", vim.cmd.tprevious, { desc = "Previous tag" })
vim.keymap.set("n", "]T", vim.cmd.tlast, { desc = "Last tag" })
vim.keymap.set("n", "[T", vim.cmd.tfirst, { desc = "First tag" })

-- quickfix list and location list
-- toggle(alternate) quickfix
vim.keymap.set("n", "<leader><leader>q", function()
  if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
    vim.cmd.cclose()
  else
    vim.cmd.copen()
  end
end, { silent = true, desc = "Display error" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { silent = true, desc = "Next error(qf)" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { silent = true, desc = "Previous error(qf)" })
vim.keymap.set("n", "]Q", vim.cmd.clast, { silent = true, desc = "Last error(qf)" })
vim.keymap.set("n", "[Q", vim.cmd.cfirst, { silent = true, desc = "First error(qf)" })

-- vim.keymap.set("n", "<leader><leader>Q", function()
--   toggle_qf_loc_list("location")
-- end, { silent = true, desc = "loclist" })
vim.keymap.set("n", "]l", vim.cmd.lnext, { silent = true, desc = "Next error(loc)" })
vim.keymap.set("n", "[l", vim.cmd.lprevious, { silent = true, desc = "Previous error(loc)" })
vim.keymap.set("n", "]L", vim.cmd.llast, { silent = true, desc = "Last error(loc)" })
vim.keymap.set("n", "[L", vim.cmd.lfirst, { silent = true, desc = "First error(loc)" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
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

-- better up/down
-- vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
-- vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc>:m .+1<cr>gi", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc>:m .-2<cr>gi", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move up" })

-- better paste
-- Better paste. With P, the unnamed register not changed, v_P is
-- repeatable.(ref :h v_p and v_P)
-- vim.keymap.set("n", "<leader>p", '"+gP', { desc = "Paste" })
-- paste over visual selection
vim.keymap.set("v", "p", "P")

-- repeat search
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next match" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next match" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous match" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous match" })

-- search for the current 'selection' in Visual mode using * and #
-- similar to * and # for searching the 'word' under current cursor in Normal mode.
vim.keymap.set(
  "x",
  "*",
  [[:lua vset_search()<cr>/<C-R>=@/<cr><cr>]],
  { desc = "Search for selection", noremap = true, silent = true }
)
vim.keymap.set(
  "x",
  "#",
  [[:lua vset_search()<cr>?<C-R>=@/<cr><cr>]],
  { desc = "Search for selection", noremap = true, silent = true }
)

-- repeat last substitution with flags
vim.keymap.set("n", "&", "<cmd>&&<cr>", { desc = "Last substitute" })
vim.keymap.set("x", "&", "<cmd>'<,'>&&<cr><Esc>", { desc = "Last substitute" })

-- clean highlight / diff update
vim.keymap.set("n", "<C-l>", function()
  vim.cmd.nohlsearch()
  if vim.api.nvim_get_option_value("diff", { win = 0 }) then
    vim.cmd.diffupdate()
  end
end, { silent = true, desc = "Clean highlight/Diff update" })

-- :Inspect
vim.keymap.set("n", "<C-k>", "<cmd>Inspect<cr>", { desc = "Inspect" }) -- vim.show_pos

-- Run make command, depend on language
-- vim.keymap.set("n", "<leader>B", "<cmd>make<cr>", { desc = "make/compile" })

vim.cmd([[
cnoreabbrev <expr> grep getcmdtype() == ':' && getcmdline() =~# '^grep' ? 'silent grep' : 'grep'
cnoreabbrev <expr> lgrep getcmdtype() == ':' && getcmdline() =~# '^lgrep' ? 'silent lgrep' : 'lgrep'
]])

if vim.fn.has("nvim-0.8") == 1 then
  vim.keymap.set("n", "<C-1>", "<cmd>horizontal terminal<cr>", { desc = "Horizontal terminal", silent = true })
  vim.keymap.set("n", "<C-2>", "<cmd>vertical terminal<cr>", { desc = "Vertical terminal", silent = true })
end

-- terminal mode
-- <Esc> switch terminal mode to normal mode (Not good idea, DON'T use <Esc> to
-- exit terminal mode, which change the behavior of <Esc> in shell)
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Normal Mode" })
-- <A-[> or <C-v><Esc> send <ESC> to the program running inside the terminal buffer
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
-- vim.keymap.set("n", "<leader>ob", function()
--   vim.opt.background = vim.opt.background:get() == "dark" and "light" or "dark"
-- end, { desc = "Background" })

-- vim.keymap.set("n", "<leader>oc", function()
--   vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 3 or 0
-- end, { desc = "Conceal" })

-- vim.keymap.set("n", "<leader>od", function()
--   vim.diagnostic.enable(not vim.diagnostic.is_enabled())
-- end, { desc = "Diagnostic" })

-- if vim.lsp.inlay_hint then
--   vim.keymap.set("n", "<leader>oi", function()
--     vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = 0 }), { bufnr = 0 })
--   end, { desc = "Inlay hints" })
-- end

-- vim.keymap.set("n", "<leader>on", function()
--   local nb = vim.opt_local.number:get()
--   vim.opt_local.number = not nb
--   vim.opt_local.relativenumber = not nb
-- end, { desc = "Number", buffer = 0 })

-- vim.keymap.set("n", "<leader>op", function()
--   vim.api.nvim_set_option_value("paste", not vim.opt_local.paste:get(), { scope = "local" })
-- end, { desc = "Paste", buffer = 0 })

-- vim.keymap.set("n", "<leader>ot", function()
--   vim.b.ts_highlight = not vim.b.ts_highlight
--   if vim.b.ts_highlight then
--     vim.treesitter.start()
--   else
--     vim.treesitter.stop()
--   end
-- end, { desc = "Treesitter", buffer = 0 })

vim.keymap.set("n", "<leader>zz", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>zh", "<cmd>checkhealth<cr>", { desc = "Check health", silent = true })
vim.keymap.set(
  "n",
  "<leader>zl",
  -- vim.cmd.edit(vim.env.NVIM_LOG_FILE),
  "<cmd>edit $NVIM_LOG_FILE<cr>",
  { desc = "Log(Neovim)", silent = true }
)

-- command-line and command window
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true, desc = "Command window" })
-- vim.keymap.set("c", "<C-j>", "<Down>", { silent = false, desc = "next command" }) -- silent must be false
-- vim.keymap.set("c", "<C-k>", "<Up>", { silent = false, desc = "previous command" })

-- %% expands to the directory of the active buffer, like :w %% or :e %%
vim.keymap.set("c", "%%", function()
  return vim.fn.getcmdtype() == "<cmd>" and vim.fn.expand("%:p:h") .. "/" or "%%"
end, { expr = true, desc = "Expand directory" })

-- command-line abbreviations
vim.cmd.cnoreabbrev("W! w!")
vim.cmd.cnoreabbrev("Q! q!")
vim.cmd.cnoreabbrev("Qall! qall!")
vim.cmd.cnoreabbrev("Wq wq")
vim.cmd.cnoreabbrev("Wa wa")
vim.cmd.cnoreabbrev("wQ wq")
vim.cmd.cnoreabbrev("WQ wq")

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
function vset_search()
  -- Save the current contents of the 's' register
  local temp = vim.fn.getreg("s")

  -- Visually select the previously selected text and copy it to the 's' register
  vim.cmd('normal! gv"sy')

  -- Escape special characters and set the search register
  local search = vim.fn.escape(vim.fn.getreg("s"), "/\\")
  search = vim.fn.substitute(search, "\n", "\\n", "g")
  vim.fn.setreg("/", "\\V" .. search)

  -- Restore the original contents of the 's' register
  vim.fn.setreg("s", temp)
end

function quickfix_filenames()
  local buffer_numbers = {}
  for _, quickfix_item in ipairs(vim.fn.getqflist()) do
    buffer_numbers[quickfix_item.bufnr] = vim.fn.bufname(quickfix_item.bufnr)
  end
  return table.concat(vim.tbl_map(vim.fn.fnameescape, vim.tbl_values(buffer_numbers)))
end