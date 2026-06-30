local dap = require "dap"
local dapui = require "dapui"

-- codelldb is installed by Mason; point the adapter at its binary.
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath "data" .. "/mason/bin/codelldb",
    args = { "--port", "${port}" },
  },
}

-- Debugging a Rust *test* ad-hoc (F5): build the test binaries, pick one, then
-- run the test(s) matching a filter you type. The build/parse step is shared
-- with the vim-test integration (see configs.dap_test).
dap.configurations.rust = {
  {
    name = "Debug test",
    type = "codelldb",
    request = "launch",
    program = function()
      local arts = require("configs.dap_test").build_test_artifacts()
      if #arts == 0 then
        vim.notify("No test binary built — does `cargo test` compile?", vim.log.levels.ERROR)
        return dap.ABORT
      end
      if #arts == 1 then
        return arts[1].exe
      end
      local items = { "Select test binary:" } -- multiple targets (lib + integration tests)
      for i, a in ipairs(arts) do
        items[i + 1] = i .. ". " .. vim.fn.fnamemodify(a.exe, ":t")
      end
      local idx = vim.fn.inputlist(items)
      return (arts[idx] and arts[idx].exe) or dap.ABORT
    end,
    args = function()
      local filter = vim.fn.input "Test name filter (blank = all): "
      local a = { "--nocapture", "--test-threads=1" } -- 1 thread keeps stepping deterministic
      if filter ~= "" then
        table.insert(a, 1, filter)
      end
      return a
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dapui.setup()
require("nvim-dap-virtual-text").setup()

-- Auto-open the UI when a session starts, close it when it ends.
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

-- Clearer gutter markers.
vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })
