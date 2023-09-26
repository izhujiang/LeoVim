-- This file is automatically loaded by plugins.core

vim.g.mapleader = ","
vim.g.maplocalleader = ","

-- mapping the reverse character search command to another key.
vim.cmd([[noremap \ ,]])

if vim.env.SHELL == "" then
  vim.env.SHELL = "/bin/sh"
end

-- use neo-tree instead, disable netrw at the very start of init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- vim.g.everforest_background = "soft"
-- vim.g.everforest_better_performance = 1

-- vim.opt.autoindent = true
-- vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.modifiable = true
-- vim.opt.background = "dark"
vim.opt.backspace = "eol,start,indent"
-- vim.opt.backup = false -- creates a backup file
vim.opt.clipboard:append("unnamedplus") -- allows neovim to access the system clipboard
vim.opt.cmdheight = 2 -- more space in the neovim command line for displaying messages
-- vim.opt.colorcolumn = ""
vim.opt.complete:append("i,k")
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
-- vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
-- vim.opt.conceallevel = 3 										-- Hide * markup for bold and italic
vim.opt.confirm = true -- Confirm to save changes before exiting modified buffer
vim.opt.cursorline = true -- highlight the current line
-- vim.g.editorconfig = false  -- Nvim supports EditorConfig, enabled by default.
vim.opt.encoding = "utf-8"
-- vim.opt.expandtab = false -- don't convert tabs to spaces
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.fileformats = "unix,mac,dos"
-- vim.opt.fillchars.eob = " " -- show empty lines at the end of a buffer as ` ` {default ``}
vim.opt.foldlevel = 10
-- When setting 'foldmethod' to a value other than "manual", all folds are deleted and new ones created.  Switching to the "manual" method doesn't remove the existing folds.
vim.opt.foldmethod = "syntax" -- "manual", "indent", "expr", "syntax", "diff", "marker",
vim.opt.foldnestmax = 10
-- vim.opt.foldenable = false
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.formatoptions = "jtcrqlnwmp"
-- 							default: tcqj,
-- 							o -- Automatically insert the current comment leader after hitting 'o' or 'O' in Normal mode.
-- 							a -- Automatic formatting of paragraphs.
-- 							r -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.grepprg = "rg --vimgrep"
vim.opt.guifont = "monospace:h17" -- the font used in graphical neovim applications
-- vim.opt.helplang = "cn"
-- vim.opt.hidden = true
vim.opt.history = 2000
-- vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.ignorecase = true -- ignore case in search patterns
-- vim.opt.inccommand = "nosplit" 							-- default: nosplit. split: preview incremental substitute
-- vim.opt.incsearch = true
vim.opt.infercase = true
vim.opt.iskeyword:append("-") -- treats words with `-` as single words
-- vim.opt.laststatus = 0,  										-- 3, only the last window will always have a status line
-- vim.opt.lazyredraw = true
-- vim.opt.linebreak = true
-- vim.opt.list = true -- Show some invisible characters (tabs...
vim.opt.listchars = "tab:>~,space:_"
-- vim.opt.magic = true
-- vim.opt.modeline = true
vim.opt.mouse = "" -- disable mouse
vim.opt.number = true
-- vim.opt.numberwidth = 4 											-- minimal number of columns to use for the line number {default 4}
-- vim.opt.paste = false
vim.opt.path:append("**") -- set sub-directories for search (gf, :find) command
-- vim.opt.pumblend = 0 -- Popup blend, enables pseudo-transparency for the |popup-menu| (completion menu ...)
vim.opt.pumheight = 10 -- Maximum number of entries in a popup
vim.opt.relativenumber = true
-- vim.opt.ruler = true -- hide the line and column number of the cursor position
vim.opt.scrolloff = 8 -- minimal number of screen lines to keep above and below the cursor
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.shiftround = true -- Round indent
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.shortmess = "aT"
vim.opt.showcmd = false -- hide (partial) command in the last line of the screen (for performance)
vim.opt.showmatch = true
vim.opt.showmode = false -- Dont show mode since we have a statusline
-- vim.opt.showtabline = 1 -- always show tabs
vim.opt.sidescrolloff = 8 -- minimal number of screen columns to keep to the left and right of the cursor if wrap is `false`
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.smartcase = true -- Don't ignore case with capitals
vim.opt.smartindent = true -- make indenting smarter again, insert indents automatically
-- vim.opt.smarttab = true
-- vim.opt.spell = false
-- vim.opt.spelllang = { "en" }
-- vim.opt.splitkeep = "screen"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.statusline = "%F%m%r%h%w%=(%{&ff}/%Y)\\ (line\\ %l\\/%L,\\ col\\ %c)\\"
vim.opt.swapfile = false
vim.opt.switchbuf = "uselast,useopen"
vim.opt.tabstop = 2 -- Number of spaces tabs count for
vim.opt.termguicolors = true -- True color support, most terminals support feature
vim.opt.timeout = true
vim.opt.timeoutlen = 700 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.title = true
vim.opt.titleold = "Terminal"
vim.opt.titlestring = "%F"
vim.opt.undofile = true -- enable persistent undo
vim.opt.undolevels = 2000
vim.opt.updatetime = 20000 -- faster completion (4000ms default), idle time for swapfile being written to disk
vim.opt.whichwrap:append("<,>,[,],h,l") -- keys allowed to move to the previous/next line when the beginning/end of line is reached
vim.opt.wildignore:append("*.o,*.obj,*.rbc,*.pyc,__pycache__,*.sqlite,*.db")
vim.opt.wildignore:append("*/tmp/*,*.so,*.swp,*.zip")
vim.opt.wildignore:append(".git/*,.hg/*,.svn/*")
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:longest,list:full" -- Command-line completion mode
vim.opt.winminwidth = 5 -- Minimum window width
vim.opt.wrap = false