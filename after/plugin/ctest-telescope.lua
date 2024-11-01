local ct = require("ctest-telescope")

ct.setup({
  dap_config = {
    type = "codelldb",
    setupCommands = {
      {
        text = "-enable-pretty-printing",
        description = "Enable pretty printing",
        ignoreFailures = false,
      },
    },
  },
})

vim.keymap.set("n", "<C-r>", function()
  local dap = require("dap")
  if dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
    -- Only call this on C++ and C files
    ct.setup({
        build_folder = "Debug",
    })
    ct.pick_test_and_debug()
  else
    dap.continue()
  end
end, { desc = "Debug: Start/Continue" })

vim.keymap.set("n", "<C-A-r>", function()
  local dap = require("dap")
  if dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
    -- Only call this on C++ and C files
    ct.setup({
        build_folder = "Release",
    })
    ct.pick_test_and_debug()
  else
    dap.continue()
  end
end, { desc = "Debug: Start/Continue" })
