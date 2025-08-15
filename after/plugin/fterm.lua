local fterm = require('FTerm')
fterm.setup {}

-- Just task runner support
function run_just(opts)
    fterm.scratch({ cmd = { "just", unpack(opts.fargs) }, auto_close = true })
end

-- Create a command that runs a given just task
vim.api.nvim_create_user_command('Just', run_just, { nargs = "+" })

-- Terminal Keymaps
vim.keymap.set("n", "<leader>t", function() fterm.toggle() end) -- Open/Close terminal
