local path = require("plenary.path")

require("neotest").setup({
    adapters = {
        require("neotest-ctest").setup({
            is_test_file = function(file)
                local name = path.new(file):make_relative(vim.loop.cwd())
                name = name:match("([^/\\]+)$") -- get basename
                return name:match("_test%.cc$") 
                    or name:match("_test%.cpp$") 
                    or name:match("^test_.*%.cc$") 
                    or name:match("^test_.*%.cpp$")
                    end,
        }),
        require('rustaceanvim.neotest'),
        require('neotest-golang')({
            go_test_args = {"-v"}
        })
    },
})

require("ctest-telescope").setup({
    dap_config = {
        type = "codelldb",
        setupCommands = {
            {
                text = '-enable-pretty-printing',
                description =  'enable pretty printing',
                ignoreFailures = false
            }
        }
    }
})

vim.keymap.set("n", "<leader>rtt", function()
    require("neotest").run.run()
end, { desc = "Run nearest test" })

vim.keymap.set("n", "<leader>rtf", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run tests in file" })

vim.keymap.set("n", "<leader>dt", function()
    local dap = require("dap")
    if dap.session() == nil and (vim.bo.filetype == "cpp" or vim.bo.filetype == "c") then
        -- Only call this on C++ and C files, the neotest ctest adapter doesnt support debugging
        require("ctest-telescope").pick_test_and_debug()
    else
        require("neotest").run.run({ strategy = "dap" })
    end
end, { desc = "Debug nearest test" })
