local M = {
  c = {
    {
      type = "codelldb",
      request = "launch",
      name = "Launch file",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
      end,
      cwd = "${workspaceFolder}",
    },
    {
      type = "codelldb",
      request = "attach",
      name = "Attach to process",
      processId = function()
        return require("dap.utils").pick_process
      end,
      cwd = "${workspaceFolder}",
    },

    -- {
    --   name = 'Launch',
    --   type = 'lldb',
    --   request = 'launch',
    --   program = function()
    --     return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    --   end,
    --   cwd = '${workspaceFolder}',
    --   stopOnEntry = false,
    --   args = {},
    --   -- runInTerminal = false,
    --   -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
    --   --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
    --   -- Otherwise you might get the following error:
    --   --    Error on launch: Failed to attach to the target process
    --   -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
    -- }
  },

  go = {
    {
      type = "delve",
      name = "Debug",
      request = "launch",
      program = "${file}"
    },
    {
      type = "delve",
      name = "Debug test", -- configuration for debugging test files
      request = "launch",
      mode = "test",
      program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
      type = "delve",
      name = "Debug test (go.mod)",
      request = "launch",
      mode = "test",
      program = "./${relativeFileDirname}"
    }
  },

  python = {
    {
      -- The first three options are required by nvim-dap
      type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
      request = 'launch',
      name = "Launch file",

      -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
      program = "${file}", -- This configuration will launch the current file if used.
      pythonPath = function()
        -- TODO: return different python according user's choice
        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
        local cwd = vim.fn.getcwd()
        if vim.fn.executable(cwd .. '/.pyenv/shims/python') == 1 then
          return cwd .. '/.pyenv/shims/python'
        else
          return '/usr/bin/python'
        end
      end,
    },
  },

  typescript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach",
      processId = function()
        return require("dap.utils").pick_process
      end,
      cwd = "${workspaceFolder}",
    },
  },
}

M.cpp = M.c
M.rust = M.c
M.javascript = M.typescript
return M
