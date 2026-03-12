local dap = require('dap');
local dapui = require('dapui')
dapui.setup()

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = 'codelldb',
    args = {"--port", "${port}"},
  }
}

dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

dap.configurations.rust = {
    {
        name = "Launch",
        type = "codelldb",
        cwd = '${workspaceFolder}',
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        stopOnEntry = false,
    }
}

dap.configurations.cpp = {
    {
        name = "Launch",
        type = "codelldb",
        request = "launch",
        program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    }
}

dap.configurations.go = {
  {
    type = "go",
    name = "Debug package",
    request = "launch",
    program = '${fileDirName}',
    cwd = '${fileDirName}',
  },
}

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

-- dap shortcuts
vim.keymap.set("n", "<leader>db", function()
    dap.toggle_breakpoint()
end, { desc = "Toggle Breakpoint" })
