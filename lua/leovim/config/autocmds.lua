-- Load lsp config and enable lsp client/server start automatically.
vim.api.nvim_create_autocmd("VimEnter", {
  group = vim.api.nvim_create_augroup("leovim.lsp", { clear = true }),
  callback = function()
    require("leovim.config.lsp")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = vim.api.nvim_create_augroup("leovim.buffer", { clear = true }),
  callback = function()
    -- local exclude = { "gitcommit" }
    local exclude = vim.g.non_essential_filetypes
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

-- better: run stylua in Language Server Mode
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("leovim.buffer", { clear = false }),
--   pattern = "*.lua",
--   -- stylua reads from stdin and writes to stdout
--   callback = function()
--     -- Get current buffer content
--     local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
--     local content = table.concat(lines, "\n")
--
--     -- Format with stylua
--     local result = vim.fn.system("stylua -", content)
--
--     -- Check if stylua succeeded
--     if vim.v.shell_error == 0 then
--       -- Split result back into lines
--       local formatted_lines = vim.split(result, "\n", { plain = true })
--
--       -- Remove trailing empty line if exists (stylua adds newline)
--       if formatted_lines[#formatted_lines] == "" then
--         table.remove(formatted_lines)
--       end
--
--       -- Replace buffer content with formatted version
--       vim.api.nvim_buf_set_lines(0, 0, -1, false, formatted_lines)
--     else
--       vim.notify("StyLua formatting failed: " .. result, vim.log.levels.ERROR)
--     end
--   end,
-- })

-- use selene in cmdline or CI/CD
-- vim.api.nvim_create_autocmd("BufWritePost", {
--   pattern = "*.lua",
--   callback = function()
--     local bufnr = vim.api.nvim_get_current_buf()
--     local file = vim.api.nvim_buf_get_name(bufnr)
--
--     -- Find selene.toml
--     local config = vim.fs.find({ "selene.toml" }, {
--       upward = true,
--       path = vim.fn.fnamemodify(file, ":h"),
--     })[1]
--
--     local cmd = "selene --display-style=json"
--     if config then
--       cmd = cmd .. " --config " .. vim.fn.shellescape(config)
--     end
--     cmd = cmd .. " " .. vim.fn.shellescape(file)
--
--     local output = vim.fn.system(cmd)
--
--     -- Clear previous diagnostics
--     local ns = vim.api.nvim_create_namespace("selene")
--     vim.diagnostic.reset(ns, bufnr)
--
--     if output ~= "" then
--       local diagnostics = {}
--
--       vim.print(output)
--       -- Parse NDJSON - each line is a diagnostic object
--       for line in output:gmatch("[^\r\n]+") do
--         local ok, diag = pcall(vim.json.decode, line)
--
--         if ok and diag and diag.primary_label then
--           local severity = vim.diagnostic.severity.WARN
--           if diag.severity == "Error" then
--             severity = vim.diagnostic.severity.ERROR
--           elseif diag.severity == "Warning" then
--             severity = vim.diagnostic.severity.WARN
--           end
--
--           local span = diag.primary_label.span
--
--           table.insert(diagnostics, {
--             bufnr = bufnr,
--             lnum = span.start_line - 1, -- 0-indexed
--             col = span.start_column - 1, -- 0-indexed
--             end_lnum = span.end_line - 1, -- 0-indexed
--             end_col = span.end_column - 1, -- 0-indexed
--             severity = severity,
--             source = "selene",
--             message = diag.message,
--             code = diag.code,
--           })
--         end
--       end
--
--       vim.diagnostic.set(ns, bufnr, diagnostics, {})
--     end
--   end,
-- })

vim.api.nvim_create_autocmd({ "TermOpen", "WinEnter" }, {
  group = vim.api.nvim_create_augroup("leovim.buffer", { clear = false }),
  pattern = "term://*",
  callback = function()
    if vim.bo.buftype == "terminal" then
      vim.cmd("startinsert")
    end
  end,
})

-- close buf and quit window with non-normal buffer when press q
-- specific buffers: quickfix, help, terminal, directory, scratch, buflisted
-- :close = “close this view” (like closing a tab or split).
-- set buflisted = false and bufhidden = 'wipe' (delete when close)
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("leovim_ft", { clear = true }),
  callback = function(e)
    local buf = e.buf
    local bt = vim.bo[buf].buftype
    local ft = vim.bo[buf].filetype

    if bt ~= "" or vim.api.nvim_win_get_config(0).relative ~= "" then
      vim.bo[buf].buflisted = false
      vim.bo[buf].bufhidden = "wipe"

      vim.keymap.set("n", "q", function()
        -- Handle quickfix window
        local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        if win_info.quickfix == 1 then
          if win_info.loclist == 1 then
            vim.cmd("lclose")
          else
            vim.cmd("cclose")
          end
          return
        end

        -- Handle known plugin/filetypes
        local known_fts = { "help", "man", "lspinfo", "checkhealth" }
        if vim.tbl_contains(known_fts, ft) then
          vim.cmd("quit")
        elseif vim.api.nvim_win_get_config(0).relative ~= "" then
          -- Floating window
          vim.api.nvim_win_close(0, true)
        else
          vim.cmd("close")
        end
      end, { buffer = buf, silent = true, nowait = true })
    end
  end,
})

-- vim.api.nvim_create_autocmd("FileType", {
--   group = vim.api.nvim_create_augroup("leovim_ft", { clear = false }),
--   pattern = { "gitcommit", "gitrebase", "gitconfig" },
--   command = "set bufhidden=delete",
-- })

-- more plain file types
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("leovim_ft", { clear = false }),
  pattern = { "gitcommit", "markdown", "text", "plaintex" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("leovim_ft", { clear = false }),
  pattern = { "json", "jsonc", "json5" },
  callback = function()
    vim.opt_local.conceallevel = 0
  end,
})

-- resize splits if window got resized, maybe not good idea
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("leovim.win", { clear = true }),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("leovim_edit", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
