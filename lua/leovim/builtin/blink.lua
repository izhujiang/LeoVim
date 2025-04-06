local M = {
  opts = {
    -- Insert mdoe keymaps
    keymap = {
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
      --
      -- show: Shows the completion menu
      -- show_documentation: Shows the documentation for the currently selected item
      -- show_signature: Shows the signature help window
      preset = "super-tab",

      ["<Up>"] = {},
      ["<Down>"] = {},
      -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

      -- ? decide later
      ["<C-y>"] = { "select_and_accept", "fallback" },
      -- <C-e> hide defined in "super-tab" preset
      -- ["<C-e>"] = { "hide", "fallback" },

      -- ? or leave <CR> alone
      -- ["<CR>"] = { "select_and_accept", "fallback" },
      -- ["<CR>"] = { "select_accept_and_enter", "fallback" },
    },

    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
    },

    completion = {
      trigger = {
        show_in_snippet = false,
      },
      menu = {
        draw = {
          -- padding = 0,
          -- Use treesitter to highlight the label text for the given list of sources
          treesitter = { "lsp" },
          -- Components to render, grouped by column
          columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "source_name" } },
        },
        border = "single",
      },
      -- Show documentation when selecting a completion item
      documentation = {
        -- By default, the documentation window will only show when triggered by the show_documentation keymap command.
        -- showing documentation automatically is pretty distracted
        auto_show = true,
        auto_show_delay_ms = 800,
        -- treesitter_highlighting = true,
        window = { border = "single" },
      },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = false },

      -- 'prefix' will fuzzy match on the text before the cursor
      -- 'full' will fuzzy match on the text before *and* after the cursor
      -- example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      -- keyword = { range = "full" },

      -- Disable auto brackets, some LSPs may add auto brackets themselves anyway
      accept = {
        auto_brackets = {
          enabled = false,
        },
      },

      list = {
        selection = {
          preselect = true,
          auto_insert = true,

          -- or set either per mode via a function
          -- preselect = function(ctx)
          --   return ctx.mode ~= "cmdline"
          -- end,
          -- auto_insert = function(ctx)
          --   return ctx.mode ~= "cmdline"
          -- end,
        },
      },
    },

    sources = {
      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      default = { "lsp", "path", "snippets", "buffer", "git" },
      -- default = function(ctx)
      --   local success, node = pcall(vim.treesitter.get_node)
      --   -- if vim.bo.filetype == "lua" then
      --   --   return { "lsp", "path" }
      --   if success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
      --     return { "buffer" }
      --   else
      --     -- "omni"
      --     return { "lsp", "codeium", "path", "snippets", "buffer", "cmdline" }
      --   end
      -- end,
      providers = {
        lsp = {
          async = true,
        },
        buffer = {
          opts = {
            -- all open buffers: "normal" buffers including invisible buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
        snippets = {
          opts = {
            -- Set to '+' to use the system clipboard, or '"' to use the unnamed register
            clipboard_register = "+",
          },
        },
        git = {
          module = "blink-cmp-git",
          name = "Git",
          opts = {
            async = true,
          },
        },
      },
      -- min_keyword_length = 1,
      min_keyword_length = function(ctx)
        -- if vim.bo.filetype == 'markdown' return 2 end
        -- only applies when typing a command, doesn't apply to arguments
        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
          local type = vim.fn.getcmdtype()
          if type == "/" or type == "?" then
            return 2
          end
          -- Commands
          if type == ":" or type == "@" then
            return 3
          end
        end
        -- enable lsp to trigger when pressing '.' key
        return 0
      end,
    },

    -- snippets = { preset = "default" | "luasnip" | "mini_snippets" },

    -- Experimental signature help support
    signature = {
      enabled = true,
      -- trigger = { },
      window = {
        show_documentation = true,
        border = "single",
      },
    },

    -- optionally, separate cmdline and terminal keymaps
    -- set configurations for cmdline and terminal (override the default configuration)
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },

        list = {
          selection = {
            preselect = false,
            -- preselect = function()
            --   local type = vim.fn.getcmdtype()
            --
            --   if type == "/" or type == "?" then
            --     return false
            --   end
            --   return true
            -- end,
          },
        },
      },
      keymap = {
        ["<CR>"] = {
          function(cmp)
            local type = vim.fn.getcmdtype()
            if type == ":" or type == "@" then
              if cmp.is_visible() then
                return cmp.accept_and_enter() -- accept_and_enter or skip the next(fallback) command/function
              end
            end
          end,
          "fallback",
        },
      },
      sources = function()
        local type = vim.fn.getcmdtype()
        if type == "/" or type == "?" then
          -- Search forward and backward
          return { "buffer" }
        elseif type == ":" or type == "@" then
          -- Commands, don't add "buffer" to sources
          return { "cmdline" }
        else
          return {}
        end
      end,
    },

    term = {
      -- wait nvim v0.11
      enabled = false,
      keymap = nil, -- Inherits from top level `keymap` config when not set
      sources = {},
    },
  },
}

if vim.g.ai_provider == "codeium" then
  M.opts = vim.tbl_deep_extend("keep", M.opts or {}, {
    sources = {
      providers = {
        codeium = {
          name = "codeium",
          module = "blink.compat.source",
          -- score_offset = 100,
          async = true,
          opts = {
            -- some plugins lazily register their completion source when nvim-cmp is
            -- loaded, so pretend that we are nvim-cmp, and that nvim-cmp is loaded.
            -- most plugins don't do this, so this option should rarely be needed
            -- only has effect when using lazy.nvim plugin manager
            impersonate_nvim_cmp = true,

            -- print some debug information. Might be useful for troubleshooting
            -- debug = false,
          },
        },
      },
      -- default = {},  -- DON'T override default
    },
  })
  vim.list_extend(M.opts.sources.default, { "codeium" })
elseif vim.g.ai_provider == "copilot" then
  M.opts = vim.tbl_deep_extend("keep", M.opts or {}, {
    sources = {
      -- for zbirenbaum/copilot.lua
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          -- score_offset = 100, -- Boost/penalize the score of the items
          async = true,
        },
      },
      -- -- for github/copilot.vim
      -- providers = {
      --   copilot = {
      --     name = "copilot",
      --     module = "blink-copilot",
      --     score_offset = 100,
      --     async = true,
      --   },
      -- },
    },
  })
  vim.list_extend(M.opts.sources.default, { "copilot" })

  -- only available on avante panel(bo.filetype == "AvanteInput"),
  -- @ trigger the mention(files, quickfix) completion.
  -- / trigger the command completion.
  if vim.g.ai_ui == "avante" then
    M.opts = vim.tbl_deep_extend("keep", M.opts or {}, {
      sources = {
        providers = {
          avante = {
            module = "blink-cmp-avante",
            name = "Avante",
            opts = {
              -- options for blink-cmp-avante
            },
          },
        },
      },
    })
    vim.list_extend(M.opts.sources.default, { "avante" })
  end
end

return M