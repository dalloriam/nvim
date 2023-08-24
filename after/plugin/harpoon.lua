local harpoon = require('harpoon')

harpoon.setup({
    global_settings = {
        enter_on_sendcmd = true,
    }
})

local mark = require('harpoon.mark')
local ui = require('harpoon.ui')
local cmd_ui = require('harpoon.cmd-ui')
local term = require('harpoon.term')

local fterm = require('FTerm')
function run_cmd(idx)
    local cmd = harpoon.get_term_config().cmds[idx]
    if cmd then
        fterm.scratch({cmd = cmd, auto_close = true})
    end
end

vim.keymap.set("n", "<leader>a", mark.add_file)
vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu)
vim.keymap.set("n", "<leader>u", function() ui.nav_file(1) end)
vim.keymap.set("n", "<leader>i", function() ui.nav_file(2) end)
vim.keymap.set("n", "<leader>o", function() ui.nav_file(3) end)
vim.keymap.set("n", "<leader>p", function() ui.nav_file(4) end)

vim.keymap.set("n", "<C-d>", function() cmd_ui.toggle_quick_menu() end)
vim.keymap.set("n", "<leader>b", function() run_cmd(1) end)
vim.keymap.set("n", "<leader>n", function() run_cmd(2) end)
vim.keymap.set("n", "<leader>m", function() run_cmd(3) end)
vim.keymap.set("n", "<leader>,", function() run_cmd(4) end)
