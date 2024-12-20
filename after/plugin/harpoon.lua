local harpoon = require('harpoon')
local fterm = require('FTerm')
local dap = require('dap')

harpoon.setup({
    settings = {
        save_on_toggle = true,
    },
    cmd = {
        select = function(list_item, list, option)
            fterm.scratch({cmd = list_item.value, auto_close = true})
        end
    },
})

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

vim.keymap.set("n", "<leader>u", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>i", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>o", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>p", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<C-d>", function() harpoon.ui:toggle_quick_menu(harpoon:list("cmd")) end)
vim.keymap.set("n", "<leader>n", function() harpoon:list("cmd"):select(1) end)
vim.keymap.set("n", "<leader>m", function() harpoon:list("cmd"):select(2) end)
vim.keymap.set("n", "<leader>,", function() harpoon:list("cmd"):select(3) end)
vim.keymap.set("n", "<leader>.", function() harpoon:list("cmd"):select(4) end)
