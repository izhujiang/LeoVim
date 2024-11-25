-- Disable builtin keybinds or mapping arrow keys to something more useful.
vim.keymap.set("n", ",", "<Nop>", { silent = true })
vim.keymap.set("n", "<Up>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Down>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Left>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Right>", "<Nop>", { silent = true })

vim.keymap.set("n", "\\", ",", { silent = true })
-- Buffers and augument list -----------------------------------
vim.keymap.set("n", "<leader>.", "<cmd>lcd %:p:h<cr>", { desc = "CWD" })
vim.keymap.set("n", "<leader>e", ":e <C-r>=expand('%:p:h') . '/' <cr>", { desc = "Edit" })
vim.keymap.set("n", "<leader>w", vim.cmd.write, { silent = true, desc = "Write" })
vim.keymap.set("n", "<leader>W", "<cmd>noautocmd w<cr>", { silent = true, desc = " Write(No Formatting)" })
vim.keymap.set("n", "<Leader>x", vim.cmd.bdelete, { silent = true, desc = "Close" })
vim.keymap.set("n", "<Leader>X", vim.cmd.bwipeout, { silent = true, desc = "Wipeout" })

vim.keymap.set("n", "]b", vim.cmd.bnext, { silent = true, desc = "Next Buffer" })
vim.keymap.set("n", "[b", vim.cmd.bprevious, { silent = true, desc = "Previous Buffer" })
vim.keymap.set("n", "]B", vim.cmd.blast, { silent = true, desc = "Last Buffer" })
vim.keymap.set("n", "[B", vim.cmd.bfirst, { silent = true, desc = "First Buffer" })
-- alternate file
-- <C-^>/<C-6>, or :buf #<cr>
vim.keymap.set("n", "<M-b>", function()
  vim.cmd.buffer("#")
end, { silent = true, desc = "Recent Buffer" })


-- argument list navigation
vim.keymap.set("n", "]a", vim.cmd.next, { silent = true, desc = "Next Argument" })
vim.keymap.set("n", "[a", vim.cmd.previous, { silent = true, desc = "Previous Argument" })
vim.keymap.set("n", "]A", vim.cmd.last, { silent = true, desc = "Last Argument" })
vim.keymap.set("n", "[A", vim.cmd.first, { silent = true, desc = "First Argument" })

-- Window(Ventana) and tabpage commands
vim.keymap.set("n", "<leader>v", "<c-w>", { desc = "Window", remap = true })

vim.keymap.set({ "n", "t" }, "<leader>q", vim.cmd.quit, { silent = true, desc = "Quit" })
vim.keymap.set({ "n", "t" }, "<leader>Q", vim.cmd.only, { silent = true, desc = "Only" })

vim.keymap.set("n", "<leader><Bar>", vim.cmd.vsplit, { silent = true, desc = "VSplit" })
vim.keymap.set("n", "<leader>-", vim.cmd.split, { silent = true, desc = "Split" })

-- window navigation
-- Use builtin <C-w>hjkl keybinds to jump between windows
-- Should disable ^<-, ^->, ^↑, ^↓ in MissionControl shortcuts (macos)
local wincmd = function(cmd)
  return function()
    vim.cmd.wincmd(cmd)
  end
end

vim.keymap.set({ "n", "t", "i" }, "<M-h>", wincmd("h"), { silent = true, desc = "Go Left" })
vim.keymap.set({ "n", "t", "i" }, "<M-j>", wincmd("j"), { silent = true, desc = "Go Lower" })
vim.keymap.set({ "n", "t", "i" }, "<M-k>", wincmd("k"), { silent = true, desc = "Go Upper" })
vim.keymap.set({ "n", "t", "i" }, "<M-l>", wincmd("l"), { silent = true, desc = "Go Right" })
vim.keymap.set({ "n", "i", "t" }, "<M-w>", wincmd("p"), { silent = true, desc = "Recent Window" })

-- windows resize
vim.keymap.set("n", "<M-Up>", "<cmd>resize +2<cr>", { silent = true, desc = "Height++" })
vim.keymap.set("n", "<M-Down>", "<cmd>resize -2<cr>", { silent = true, desc = "Height--" })
vim.keymap.set("n", "<M-Left>", "<cmd>vertical resize -5<cr>", { silent = true, desc = "Width--" })
vim.keymap.set("n", "<M-Right>", "<cmd>vertical resize +5<cr>", { silent = true, desc = "Width++" })

vim.keymap.set("i", "<M-Up>", "<Esc><cmd>resize +2<cr>gi", { silent = true, desc = "Height++" })
vim.keymap.set("i", "<M-Down>", "<Esc><cmd>resize -2<cr>gi", { silent = true, desc = "Height--" })
vim.keymap.set("i", "<M-Left>", "<Esc><cmd>vertical resize -5<cr>gi", { silent = true, desc = "Width--" })
vim.keymap.set("i", "<M-Right>", "<Esc><cmd>vertical resize +5<cr>gi", { silent = true, desc = "Width++" })

vim.keymap.set("t", "<M-Up>", "<C-Bslash><C-n><cmd>resize +2<cr>a", { silent = true, desc = "Height++" })
vim.keymap.set("t", "<M-Down>", "<C-Bslash><C-n><cmd>resize -2<cr>a", { silent = true, desc = "Height--" })
vim.keymap.set("t", "<M-Left>", "<C-Bslash><C-n><cmd>vertical resize -5<cr>a", { silent = true, desc = "Width--" })
vim.keymap.set("t", "<M-Right>", "<C-Bslash><C-n><cmd>vertical resize +5<cr>a", { silent = true, desc = "Width++" })

-- Tag-pages
-- use built-in gt/gT for :tabnext/tabprev or Ex-commands directly,
-- OR use (better) tmux to arrange workspaces
vim.keymap.set("n", "]p", vim.cmd.tabnext, { desc = "Next Tabpage" })
vim.keymap.set("n", "[p", vim.cmd.tabprev, { desc = "Previous Tabpage" })
vim.keymap.set("n", "]P", vim.cmd.tablast, { desc = "Last Tabpage" })
vim.keymap.set("n", "[P", vim.cmd.tabfirst, { desc = "First Tabpage" })

-- Tags
vim.keymap.set("n", "]t", vim.cmd.tnext, { desc = "Next Tag" })
vim.keymap.set("n", "[t", vim.cmd.tprevious, { desc = "Previous Tag" })
vim.keymap.set("n", "]T", vim.cmd.tlast, { desc = "Last Tag" })
vim.keymap.set("n", "[T", vim.cmd.tfirst, { desc = "First Tag" })

-- quickfix list and location list
vim.keymap.set("n", "<M-q>",
  function()
    toggle_qf_loc_list("Quickfix")
  end,
  { silent = true, desc = "Toogle Quickfix" })
vim.keymap.set("n", "]q", vim.cmd.cnext, { silent = true, desc = "Next Quickfix" })
vim.keymap.set("n", "[q", vim.cmd.cprevious, { silent = true, desc = "Previous Quickfix" })
vim.keymap.set("n", "]Q", vim.cmd.clast, { silent = true, desc = "Last Quickfix" })
vim.keymap.set("n", "[Q", vim.cmd.cfirst, { silent = true, desc = "First Quickfix" })

vim.keymap.set("n", "<M-Q>",
  function()
    toggle_qf_loc_list("location")
  end, { silent = true, desc = "Toggle Loclist" })
vim.keymap.set("n", "]l", vim.cmd.lnext, { silent = true, desc = "Next Loclist" })
vim.keymap.set("n", "[l", vim.cmd.lprevious, { silent = true, desc = "Previous Loclist" })
vim.keymap.set("n", "]L", vim.cmd.llast, { silent = true, desc = "Last Loclist" })
vim.keymap.set("n", "[L", vim.cmd.lfirst, { silent = true, desc = "First Loclist.F" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
-- vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Diagnostics" })
vim.keymap.set("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
vim.keymap.set("n", "[d", diagnostic_goto(false), { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
vim.keymap.set("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Previous Error" })
vim.keymap.set("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
vim.keymap.set("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Previous Warning" })

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
vim.keymap.set("n", "<C-j>", ":m .+1<cr>", { desc = "Move Down" })
vim.keymap.set("n", "<C-k>", ":m .-2<cr>", { desc = "Move Up" })
vim.keymap.set("i", "<C-j>", "<esc>:m .+1<cr>gi", { desc = "Move Down" })
vim.keymap.set("i", "<C-k>", "<esc>:m .-2<cr>gi", { desc = "Move Up" })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { desc = "Move Down" })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { desc = "Move Up" })

-- better paste
-- Better paste. With P, the unnamed register not changed, v_P is
-- repeatable.(ref :h v_p and v_P)
-- TODO:
-- vim.keymap.set("n", "<leader>p", '"+gP', { desc = "Paste" })
--
-- paste over visual selection
vim.keymap.set("v", "p", "P")

-- repeat search
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Match" })
vim.keymap.set({ "x", "o" }, "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Match" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Previous Match" })
vim.keymap.set({ "x", "o" }, "N", "'nN'[v:searchforward]", { expr = true, desc = "Previous Match" })

-- search for the current 'selection' in Visual mode using * and #
-- similar to * and # for searching the 'word' under current cursor in Normal mode.
vim.keymap.set("x", "*", [[:lua vset_search()<cr>/<C-R>=@/<cr><cr>]],
  { desc = "Search for Selection", noremap = true, silent = true })
vim.keymap.set("x", "#", [[:lua vset_search()<cr>?<C-R>=@/<cr><cr>]],
  { desc = "Search for Selection", noremap = true, silent = true })

-- repeat last substitution with flags
vim.keymap.set("n", "&", "<cmd>&&<cr>", { desc = "Last Substitute" })
vim.keymap.set("x", "&", "<cmd>'<,'>&&<cr><Esc>", { desc = "Last Substitute" })

-- clean highlight
vim.keymap.set("n", "<C-l>", vim.cmd.nohlsearch, { silent = true, desc = "Clean Highlight" })
vim.keymap.set("n", "<leader>gu",
  function()
    vim.cmd.nohlsearch()
    vim.cmd.diffupdate()
  end,
  { silent = true, desc = "Diff Update" })

-- commenting, override by Comment.nvim
vim.keymap.set("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment Below" })
vim.keymap.set("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Comment Above" })

-- TODO: usefule for noraml text file, not for program, so setup in filetype event
-- Add undo break-points (Ref: luarvim)
-- vim.keymap.set("i", ",", ",<c-g>u", {desc = "Add undo break points", silent = true, buffer = true})
-- vim.keymap.set("i", ".", ".<c-g>u", {desc = "Add undo break points", silent = true, buffer = true})
-- vim.keymap.set("i", ";", ";<c-g>u", {desc = "Add undo break points", silent = true, buffer = true})

-- :Inspect
vim.keymap.set("n", "<leader>ai", "<cmd>Inspect<cr>", { desc = "Inspect" })         -- vim.show_pos
vim.keymap.set("n", "<leader>at", "<cmd>InspectTree<cr>", { desc = "InspectTree" }) -- vim.treesitter.inspect_tree

-- Run make command
vim.keymap.set("n", "<leader>B", "<cmd>make<cr>", { desc = "Make/Compile" })

vim.cmd([[
cnoreabbrev <expr> grep getcmdtype() == ':' && getcmdline() =~# '^grep' ? 'silent grep' : 'grep'
cnoreabbrev <expr> lgrep getcmdtype() == ':' && getcmdline() =~# '^lgrep' ? 'silent lgrep' : 'lgrep'
]])

if vim.fn.has("nvim-0.8") == 1 then
  vim.keymap.set("n", "<M-1>", "<cmd>horizontal terminal<cr>", { desc = "Terminal(Horizontal)<cr>", silent = true })
  vim.keymap.set("n", "<M-2>", "<cmd>vertical terminal<cr>", { desc = "Terminal(Vertical )<cr>", silent = true })
end

-- terminal mode
-- <Esc> switch terminal mode to normal mode (Not good idea, DON'T use <Esc> to
-- exit terminal mode, which change the behavior of <Esc> in shell)
-- vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true, desc = "Normal Mode" })
-- <M-[> or <C-v><Esc> send <ESC> to the program running inside the terminal buffer
-- vim.keymap.set("t", "<M-[>", "<Esc>", { silent = true, desc = "<Esc>" })
-- vim.keymap.set("t", "<C-v><Esc>", "<Esc>", { desc = "<Esc>" })
--
-- vim.keymap.set("t", "<C-R>", [[<C-Bslash><C-N>"".nr2char(getchar())."pi"]],
-- { expr = true })
--
vim.keymap.set("t", "<C-d>", function()
  vim.cmd.bdelete({ bang = true })
end, { silent = true, desc = "Close" })

-- Toogle options
-- -------------------------------------------------------------------
vim.keymap.set("n", "<leader>ob", function()
  vim.opt.background = vim.opt.background:get() == "dark" and "light" or "dark"
end, { desc = "Background", silent = true })

vim.keymap.set("n", "<leader>oc", function()
  vim.opt.conceallevel = vim.opt.conceallevel:get() == 0 and 3 or 0
end, { desc = "Conceal", silent = true })

vim.keymap.set("n", "<leader>od", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Diagnostics", silent = true })

vim.keymap.set("n", "<leader>of", function()
  print("TODO: Toggle format")
end, { desc = "Format", silent = true, buffer = 0 })

if vim.lsp.inlay_hint then
  vim.keymap.set("n", "<leader>oh", function()
    vim.lsp.inlay_hint(0, nil)
  end, { desc = "Inlay Hints", silent = true })
end

vim.keymap.set("n", "<leader>on", function()
  local nb = vim.opt_local.number:get()
  vim.opt_local.number = not nb
  vim.opt_local.relativenumber = not nb
end, { desc = "Number", silent = true, buffer = 0 })

vim.keymap.set("n", "<leader>op", function()
  vim.api.nvim_set_option_value("paste", not vim.opt_local.paste:get(), { scope = "local" })
end, { desc = "Paste", buffer = 0 })

vim.keymap.set("n", "<leader>os", function()
  vim.api.nvim_set_option_value("spell", not vim.opt_local.spell:get(), { scope = "local" })
end, { desc = "Spell", silent = true, buffer = 0 })

vim.keymap.set("n", "<leader>ot", function()
  vim.b.ts_highlight = not vim.b.ts_highlight
  if vim.b.ts_highlight then
    vim.treesitter.start()
  else
    vim.treesitter.stop()
  end
end, { desc = "Treesitter", silent = true, buffer = 0 })

vim.keymap.set("n", "<leader>ow", function()
  vim.opt_local.wrap = not vim.opt_local.wrap:get()
end, { desc = "Wrap", silent = true, buffer = 0 })

vim.keymap.set("n", "<leader>zz", "<cmd>Lazy<cr>", { desc = "Lazy", silent = true })
vim.keymap.set("n", "<leader>zh", "<cmd>checkhealth<cr>", { desc = "Health", silent = true })
vim.keymap.set("n", "<leader>zll", "<cmd>lua vim.fn.execute('edit ' .. vim.lsp.get_log_path())<cr>",
  { desc = "Log(LSP)", silent = true })
vim.keymap.set("n", "<leader>zln", "<cmd>edit $NVIM_LOG_FILE<cr>", { desc = "Log(Neovim)", silent = true })

-- command-line and command window
vim.keymap.set("c", "<C-o>", "<C-f>", { silent = true, desc = "Command Window" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Next Command" }) -- silent must be false
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Previous Command" })

-- %% expands to the directory of the active buffer, like :w %% or :e %%
vim.keymap.set("c", "%%", function()
  return vim.fn.getcmdtype() == "<cmd>" and vim.fn.expand("%:p:h") .. "/" or "%%"
end, { expr = true, desc = "Expand Directory" })

-- command-line abbreviations
-- TODO: not working in nvim, solution: https://www.youtube.com/watch?v=u1HgODpoijc
-- vim.cmd.cnoreabbrev("W w !sudo -S tee % >/dev/null")
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
end, { desc = "Arguments From Quickfix" })
vim.api.nvim_create_user_command("SudoSave", "w !sudo tee % >/dev/null", { desc = "Sudo Save" })
vim.api.nvim_create_user_command("CTagsGen", "!ctags -R --exclude=.git", { desc = "Run !ctags Command" })

-- Helper functions -------------------------------------------------------------------
-- TODO: keep in Visual mode with last selected text
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

-- TODO: loclist not test yet.
function toggle_qf_loc_list(list_type)
  if list_type == "quickfix" then
    if vim.fn.getqflist({ winid = 1 }).winid ~= 0 then
      vim.cmd.cclose()
    else
      vim.cmd.copen()
    end
  else
    if vim.fn.getloclist(0, { winid = 1 }).winid ~= 0 then
      vim.cmd.lclose()
    elseif not vim.tbl_isempty(vim.fn.getloclist(0)) then
      vim.cmd.lopen()
    end
  end
end
