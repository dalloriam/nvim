require('neotest').setup {
    adapters = {
      require('rustaceanvim.neotest')
    },
}

-- run test
vim.keymap.set("n", "<leader>bt", function()
  require('neotest').run.run()
end)

-- run tests in file
vim.keymap.set("n", "<leader>bf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end)

-- debug test
vim.keymap.set("n", "<leader>dt", function()
  require("neotest").run.run({strategy = "dap"})
end)
