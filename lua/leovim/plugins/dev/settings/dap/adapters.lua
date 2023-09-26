local M = {
  -- nlua = function(callback, config)
  --   callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
  -- end,

  ["pwa-node"] = function ()
    local adapter_root = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
    return {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          adapter_root .. "/js-debug/src/dapDebugServer.js",
          "${port}"
        }
      },
    }
  end
}


return M