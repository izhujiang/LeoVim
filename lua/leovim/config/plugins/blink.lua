local M = {
  opts = {
    keymap = { -- Insert mdoe
      -- 'default' for mappings similar to built-in completion
      -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
      preset = "super-tab",

      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<Up>"] = {},
      ["<Down>"] = {},
      -- ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      -- ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },

    appearance = {
      nerd_font_variant = "normal",
    },

    completion = {
      trigger = {
        prefetch_on_insert = false,
        show_on_backspace_in_keyword = true,
        -- show_in_snippet = true,
      },
      menu = {
        draw = {
          treesitter = { "lsp" },
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "source_name" },
          },

          -- colorful-menu.nvim combines label and label_description together
          -- columns = { { "kind_icon" }, { "label", gap = 1 } },
          -- components = {
          --   label = {
          --     text = function(ctx)
          --       return require("colorful-menu").blink_components_text(ctx)
          --     end,
          --     highlight = function(ctx)
          --       return require("colorful-menu").blink_components_highlight(ctx)
          --     end,
          --   },
          -- },
        },
      },
      -- Show documentation when selecting a completion item
      -- By default, the documentation window will only show when triggered by the show_documentation keymap command.
      -- showing documentation automatically is pretty distracted
      -- documentation = {
      --   auto_show = true,
      --   auto_show_delay_ms = 800,
      -- },

      -- Display a preview of the selected item on the current line
      ghost_text = { enabled = true },

      -- 'prefix', 'full', example: 'foo_|_bar' will match 'foo_' for 'prefix' and 'foo__bar' for 'full'
      keyword = { range = "full" },

      accept = {
        -- auto-insert brackets for functions
        auto_brackets = {
          -- blink.cmp determines whether to insert brackets based on LSP's response.
          enabled = true,
          -- default_brackets = { "(", ")" },

          -- some LSPs may add auto brackets themselves anyway.
          -- Synchronously use the kind of the item to determine if brackets should be added
          -- kind_resolution = {
          --   enabled = true,
          --   blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
          -- },
          -- Asynchronously use semantic token to determine if brackets should be added
          -- semantic_token_resolution = {
          --   enabled = true,
          --   blocked_filetypes = { "java" },
          --   -- How long to wait for semantic tokens to return before assuming no brackets should be added
          --   timeout_ms = 400,
          -- },

          -- Memo:
          -- For JavaScript (which lacks static typing), the LSP needs type information to know that a method (Typescript or JsDoc) returns a function, and therefore needs brackets.
        },
      },

      -- list = { selection = { preselect = true, auto_insert = true } },
    },

    signature = {
      enabled = true,
      -- window = {
      --   -- Disable if you run into performance issues
      --   treesitter_highlighting = true,
      --   show_documentation = true,
      -- },
    },
    snippets = {
      -- preset = "default" | "luasnip" | "mini_snippets",
      expand = function(snippet)
        -- Try native expansion first
        local ok = pcall(vim.snippet.expand, snippet)

        if not ok then
          -- Fallback: strip snippet syntax and insert as plain text
          local plain = snippet:gsub("%$%b{}", ""):gsub("%$%d+", ""):gsub("%$0", "")
          vim.api.nvim_put({ plain }, "c", false, true)
        end
      end,
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" }, -- "git"
      -- define providers per filetype
      per_filetype = {
        -- optionally inherit from the `default` sources
        vim = { inherit_defaults = true, "cmdline" },
        gitcommit = { inherit_defaults = true, "git" },
        gitrebase = { inherit_defaults = true, "git" },
        -- lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        -- `lsp`, `buffer`, `snippets`, `path` and `omni` are built-in (blink.cmp/lua/blink/cmp/sources),
        -- no need to define them in `sources.providers` unless with non-default properties
        lsp = {
          async = true,
          score_offset = 5, -- Boost/penalize the score of the items
          -- fallbacks = { "buffer" }, -- default, the buffer source will only show when the LSP source is disabled or returns no items.
          -- fallbacks = {}, -- always show the buffer source along with lsp
        },
        buffer = {
          opts = {
            -- only all loaded 'normal' buffers
            get_bufnrs = function()
              return vim.tbl_filter(function(bufnr)
                return vim.bo[bufnr].buftype == ""
              end, vim.api.nvim_list_bufs())
            end,
          },
        },
        snippets = {
          -- name = "snippets",
          -- module = "blink.cmp.sources.snippets",
          opts = {
            friendly_snippets = true,
            -- Set to '+' to use the system clipboard, or '"' to use the unnamed register
            clipboard_register = "+",
          },
        },
        git = {
          name = "Git",
          module = "blink-cmp-git",
          opts = {},
        },
        -- lazydev = {
        --   name = "LazyDev",
        --   module = "lazydev.integrations.blink",
        --   -- make lazydev completions top priority (see `:h blink.cmp`)
        --   score_offset = 10,
        -- },
      },
    },

    -- optional, separate cmdline and terminal keymaps
    -- set configurations for cmdline and terminal (override the default configuration)
    cmdline = {
      enabled = true,
      -- By default, cmdline completions are enabled (cmdline.enabled = true),
      -- matching the behavior of the built-in cmdline completion, which is quiet good:
      --    - Menu will not show automatically (cmdline.completion.menu.auto_show = false)
      --    - Pressing <Tab> will show the completion menu and insert the first item
      --    - Subsequent <Tab>s will select the next item, <S-Tab> for previous item
      --    - <C-n> for next item, <C-p> for previous item
      --    - <C-y> accepts the current item
      --    - <C-e> cancels the completion
      --    - When noice.nvim is detected, ghost text will be shown, otherwise it will not work

      -- OR
      -- keymap = {
      --   ["<Tab>"] = { "accept" },
      --   ["<CR>"] = { "accept_and_enter", "fallback" },
      -- },
      -- completion = {
      --   menu = {
      --     -- auto_show = true,
      --     auto_show = function(ctx)
      --       return vim.fn.getcmdtype() == ':'
      --       -- enable for inputs as well, with:
      --       -- or vim.fn.getcmdtype() == '@'
      --     end,
      --   }
      -- },
      -- sources = {
      --   providers = {
      --     cmdline = {
      --       min_keyword_length = function(ctx)
      --         if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
      --           local cmd_type = vim.fn.getcmdtype()
      --           if cmd_type == "/" or cmd_type == "?" then
      --             return 2
      --           end
      --           -- Commands
      --           if cmd_type == ":" or cmd_type == "@" then
      --             return 3
      --           end
      --         end
      --         -- enable lsp to trigger when pressing '.' key
      --         return 0
      --       end,
      --     }
      --   }
      -- }
    },

    -- guress term completion not ready.
    -- term = {
    --   -- terminal completions are 0.11+ only. TODO: no idea to trigger completion in :terminal
    --   enabled = false,
    --   sources = {
    --     default = { "cmdline", "path" },
    --   },
    -- },
  },
}

if vim.g.ai_provider == "codeium" then
  M.opts = vim.tbl_deep_extend("keep", M.opts or {}, {
    sources = {
      providers = {
        codeium = {
          name = "codeium",
          module = "blink.compat.source",
          score_offset = 5,
          async = true,
          opts = {
            -- impersonate_nvim_cmp = true,
          },
        },
      },
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
