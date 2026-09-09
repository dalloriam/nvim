-- Just task runner support
local mux = require('multiplexer')

local function run_ai(runner, opts)
    local cmd = { runner }
    vim.list_extend(cmd, opts.fargs or {})
    mux.spawn(cmd)
end

local function claude(opts)
    run_ai("claude", opts)
end

local function codex(opts)
    run_ai("codex", opts)
end

vim.api.nvim_create_user_command("Claude", claude, { nargs = "*" })
vim.api.nvim_create_user_command("Codex", codex, { nargs = "*" })
