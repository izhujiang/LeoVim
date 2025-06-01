-- Run :options, pop up the option window
--      - get a list of options with a one-line explanation and grouped by subjuect.
--      - navigate around and change the value of an option under the cursor.

vim.g.mapleader = ","
vim.g.maplocalleader = "-"

-- disable builtin plugins under $VIMRUNTIME/plugin and $VIMRUNTIME/macros
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disable perl and ruby provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
-- vim.g.loaded_python3_provider = 0
-- vim.g.loaded_node_provider = 0

-- log_level for lsp, vim.notify() and others
-- vim.g.log_level = vim.log.levels.ERROR
vim.g.log_level = vim.log.levels.WARN

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- To appropriately highlight codefences returned from denols
vim.g.markdown_fenced_languages = { "ts=typescript" }

vim.g.colorscheme = "everforest"
vim.g.explorer = "neo-tree" -- "neo-tree" | "nvim-tree"
vim.g.completion = "blink" -- "blink" | "nvim-cmp"
-- vim.g.ai_provider = "copilot" -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | "codeium" | string
vim.g.ai_provider = "codeium" -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | "codeium" | string
-- vim.g.ai_ui = "avante" -- "avante" | "copilotchat" (only valid for copilot)

vim.g.non_essential_filetypes = {
  "dashboard",
  "help",
  "gitcommit",
  "NvimTree",
  "neo-tree",
  "neotest-output-panel",
  "neotest-summary",
  "qf",
  "toggleterm",
  "trouble",
  "Avante",
  "AvanteSelectedFiles",
  "AvanteInput",
  "dapui_watches",
  "dapui_stacks",
  "dapui_breakpoints",
  "dapui_scopes",
  "dapui_console",
  "dap-repl",
}

-- vim.opt.shell has been set if $SHELL exists during the process (step 1) of initialization start
-- if vim.env.SHELL == "" then
--   -- for unix/linux
--   vim.opt.shell = "/bin/sh"
-- end

-- Running "git commit" in :terminal, reuse current nvim (via nvr), avoid nested nvim
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
vim.opt.autowrite = true
vim.opt.clipboard = vim.env.SSH_TTY and ""
  or (vim.fn.has("unnamedplus") and { "unnamed", "unnamedplus" } or { "unnamed" }) -- sync with system clipboard
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.complete:append("i")
vim.opt.completeopt = { "menuone" } -- DON'T show up extra information in popup window, a bit distracting. DON'T use longest, which only insert the longest common text of the matches.
vim.opt.dictionary:prepend({ "/usr/share/dict/words" })
vim.opt.concealcursor = "nc" -- conceal only in normal and command-line mode
vim.opt.conceallevel = 2 -- so that `` is visible in markdown files, 3 -- Concealed text is completely hidden.
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- highlight the current line
-- vim.opt.fillchars = { horiz = "-", vert = "|", foldopen = "", foldclose = "", fold = "-", diff = "-", eob = "~" }
vim.opt.fillchars = { horiz = "-", vert = "|", foldopen = "", foldclose = "", fold = "-", diff = "-", eob = " " }
vim.opt.fixendofline = true
vim.opt.foldlevel = 10
vim.opt.foldmethod = "expr" -- "manual", "indent", "expr", "syntax", "diff", "marker",
vim.opt.foldnestmax = 10
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

vim.opt.formatoptions = "jtcrqlnwmp" -- don't add t or a to wrap automatically
if vim.fn.executable("rg") then
  vim.opt.grepprg = "rg --column --line-number --no-heading --smart-case"
  vim.opt.grepformat = "%f:%l:%c:%m,%f:%l:%m"
end
vim.opt.history = 2000
vim.opt.ignorecase = true -- ignore case in search patterns
vim.opt.smartcase = true
vim.opt.infercase = true -- 'ignorecase' is also on, the case of the match is adjusted depending on the typed text.
vim.opt.jumpoptions = "view"
vim.opt.laststatus = 3 -- 3, only the last window will always have a status line
-- vim.opt.list = true      -- Show some invisible characters (tabs...
vim.opt.listchars = { space = "_", tab = ">~" }
vim.opt.mouse = "" -- disable mouse
vim.opt.nrformats:append({ "octal", "alpha" })
vim.opt.number = true
vim.opt.relativenumber = true
-- vim.opt.numberwidth = 4  -- minimal number of columns to use for the line number {default 4}
vim.opt.path:append("**") -- set sub-directories for search (gf, :find) command
vim.opt.pumblend = 10 -- Popup blend, enables pseudo-transparency for the popup-menu.
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.ruler = true -- hide the line and column number of the cursor position
vim.opt.scrolloff = 2 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "globals" }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 4 -- the number of spaces inserted for each indentation
vim.opt.shortmess = "aT"
vim.opt.showmatch = true
vim.opt.showtabline = 0 -- Never show tabpages, use tmux instead tabpages
vim.opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.smartindent = true
-- vim.opt.spell = false
-- vim.opt.spelllang = { "en" }
vim.opt.spelloptions:append("noplainbuffer")
vim.opt.statusline = "%F%m%r%h%w%=%{&ff}/%y [L:%l/%L(%P), C:%c]"
vim.opt.swapfile = false
vim.opt.switchbuf = { "uselast", "useopen" }
vim.opt.termguicolors = true -- true color support, most terminals support feature
vim.opt.tildeop = true -- tilde command "~" behaves like an operator.
vim.opt.timeoutlen = 700 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.ttimeoutlen = 100 -- time waited for a key code or mapped key sequence to complete.
vim.opt.title = true
vim.opt.titlestring = "%F"
vim.opt.undolevels = 2000
vim.opt.updatetime = 10000 -- faster completion (4000ms default), idle time for swapfile being written to disk
vim.opt.wildignore:append({ "*.o", "*.obj", "*.rbc", "*.pyc", "__pycache__", "*.sqlite", "*.db" })
vim.opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip" })
vim.opt.wildignore:append({ ".git/*", ".hg/*", ".svn/*", ".DS_Store" })
vim.opt.wildignorecase = true
vim.opt.wildmode = { "longest:full", "full" } -- Command-line completion mode
vim.opt.winminwidth = 4 -- Minimum window width
vim.opt.wrap = false
-- vim.opt.shada="50,<1000,s100,:0,n~/nvim/shada"