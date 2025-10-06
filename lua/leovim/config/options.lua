-- Run :options, pop up the option window
--      - get a list of options with a one-line explanation and grouped by subjuect.
--      - navigate around and change the value of an option under the cursor.

-- log_level for lsp, vim.notify() and others
-- vim.g.log_level = vim.log.levels.ERROR
vim.g.log_level = vim.log.levels.ERROR

vim.g.mapleader = ","
vim.g.maplocalleader = " "

-- disable builtin plugins under $VIMRUNTIME/plugin and $VIMRUNTIME/macros
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- enable editorconfig
-- vim.g.editorconfig = true

-- disable perl and ruby provider
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- To appropriately highlight codefences returned from denols
vim.g.markdown_fenced_languages = { "ts=typescript" }

vim.g.colorscheme = "everforest"
vim.g.explorer = "neo-tree" -- "neo-tree" | "nvim-tree"
-- vim.g.ai_provider = "copilot" -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | "codeium" | string
vim.g.ai_provider = "codeium" -- "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | "codeium" | string
-- vim.g.ai_ui = "avante" -- "avante" | "copilotchat" (only valid for copilot)

-- config and enabled via vim.lsp.config
vim.g.enabled_lsp_servers = {
  -- "astro",
  "bashls",
  "biome",
  "clangd",
  -- "cmake",
  -- With emmet, typing div<Tab> will expand to <div></div> with cursor positioned between tags.
  "emmet_ls",
  "gopls",
  -- "html", -- use emmet-ls instead, html-lsp confict with blink.cmp's snippets
  -- "jsonls",
  "lua_ls",
  "stylua",
  "marksman",
  "pyright",
  -- "pyrefly", -- run fast, but not ready to replace pyright
  "ruff",
  "rust_analyzer",
  "svelte",
  -- "tailwindcss",
  "ts_ls",
}
-- lsp and tools managed by mason
vim.g.tools_ensure_installed = {
  "astro-language-server",
  "bash-language-server",
  "biome",
  "clangd",
  -- "cmake-language-server", -- python 3.12 yes, python 3.13 not supported
  "emmet-ls",
  "html-lsp",
  "gopls",
  "json-lsp",
  "lua-language-server",
  "stylua", -- A deterministic code formatter for Lua, a dedicated linter for CI/CD that's faster/lighter
  "selene", -- a blazing-fast modern Lua linter written in Rust, a command line tool for CI/CD
  "marksman",
  "pyright", -- full-featured, standards-compliant static type checker for Python, ships as both a command-line tool and a language server that provides many powerful features (completion, navigation, diagnostics...)
  -- "pyrefly",
  "ruff", -- extremely fast Python linter and code formatter
  "rust-analyzer",
  "svelte-language-server",
  "tailwindcss-language-server",
  "typescript-language-server",

  "shellcheck", -- shellcheck and shfmt are dependencies of bash-language-server
  "shfmt",

  -- "commitlint",
  -- dap
  "debugpy",
  "delve",
  "js-debug-adapter",
  "codelldb",
}

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

-- vim.opt.shell has been set if $SHELL exists during the process (step 1) of initialization start, else in case
if vim.env.SHELL == "" then
  -- for unix/linux
  vim.opt.shell = "/bin/sh"
end

-- Running "git commit" in :terminal, reuse current nvim (via nvr), avoid nested nvim
vim.env.GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
vim.opt.autowrite = true
vim.opt.writebackup = false
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
-- controls ui elements like borders, folds, and separators.
vim.opt.fillchars = { horiz = "-", vert = "|", foldopen = "", foldclose = "", fold = "-", diff = "-", eob = "~" }
vim.opt.fixendofline = true
vim.opt.foldmethod = "expr" -- "manual", "indent", "expr", "syntax", "diff", "marker",
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- default foldmethod
vim.opt.foldenable = false -- Start with folds open
-- vim.opt.foldlevel = 10
vim.opt.foldlevel = 99 -- High default so folds stay open
vim.opt.foldnestmax = 10

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
-- vim.opt.list = true -- enable to show listchars (tabs, space, eol, lead, trail ... )
vim.opt.listchars = {
  space = "_", -- usually omitted as it's too noisy
  trail = "•", -- always show trailing spaces (trail)
  tab = ">⎵",
  nbsp = "⋅", --  non-breaking spaces
  eol = "↲",
  extends = "›", -- or '»'
  precedes = "‹", -- or '«'
}
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
vim.opt.signcolumn = "yes:2" -- auto:[2], multiple sign columns, 'yes' always show the sign column, otherwise it would shift the text each time
vim.opt.smartindent = true
-- vim.opt.spell = false
-- vim.opt.spelllang = { "en" }
vim.opt.spelloptions:append("noplainbuffer")
vim.opt.statusline = "%F%m%r%h%w%=%{&ff}/%y [L:%l/%L(%P), C:%c]"
vim.opt.swapfile = false
vim.opt.switchbuf = { "uselast", "useopen" }
vim.opt.termguicolors = true -- true color support, most terminals support feature
-- Normal modes: underline cursor
-- Insert mode: vertical bar (25% width)
-- vim.opt.guicursor = "n-v-c-sm:Cursor,i-ci-ve:ver25,r-cr:hor20,o:hor50"
vim.opt.guicursor = "n-v-c-sm:hor20,i-ci-ve:ver25-blinkwait300-blinkon400-blinkoff250"
vim.opt.tildeop = true -- tilde command "~" behaves like an operator.
vim.opt.timeoutlen = 700 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.ttimeoutlen = 100 -- time waited for a key code or mapped key sequence to complete.
vim.opt.title = true
vim.opt.titlestring = "%F"
vim.opt.undolevels = 2000
vim.opt.updatetime = 300 -- faster completion (4000ms default), idle time for swapfile being written to disk and CursorHold event to fire
vim.opt.wildignore:append({ "*.o", "*.obj", "*.rbc", "*.pyc", "__pycache__", "*.sqlite", "*.db" })
vim.opt.wildignore:append({ "*/tmp/*", "*.so", "*.swp", "*.zip" })
vim.opt.wildignore:append({ ".git/*", ".hg/*", ".svn/*", ".DS_Store" })
vim.opt.wildignorecase = true
vim.opt.wildmode = { "longest:full", "full" } -- Command-line completion mode
vim.opt.winminwidth = 4 -- Minimum window width
vim.opt.winborder = "rounded" -- default border style of floating windows.
vim.opt.wrap = false
-- vim.opt.shada="50,<1000,s100,:0,n~/nvim/shada"

-- enable json lsp server (like: biome) treat json as jsonc to support coments
vim.filetype.add({
  extension = {
    json = "jsonc",
  },
})
