local M = {}

function M.build(target_pattern)
    local fterm = require("FTerm")
    fterm.scratch({
        cmd = "buck2 build " .. target_pattern,
    })
end

function M.test(target_pattern)
    local fterm = require("FTerm")
    fterm.scratch({
        cmd = "buck2 test " .. target_pattern,
    })
end

function M.setup()
    vim.api.nvim_create_user_command("BuckBuild", function(opts) M.build(opts.fargs[1]) end, {nargs = 1})
    vim.api.nvim_create_user_command("BuckTest", function(opts) M.test(opts.fargs[1]) end, {nargs = 1})
end

return M
