-- Make sure telescope is loaded
local builtin = require('telescope.builtin')

local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
    file_ignore_patterns = {
        "vcpkg/.*"
    },
    pickers = {
        buffers = {
          sort_lastused = true,
          ignore_current_buffer = true,
          attach_mappings = function(_, map)
            map('i', '<C-d>', actions.delete_buffer)
            map('n', '<C-d>', actions.delete_buffer)
            return true
          end,
        },
    },
})

-- Keymap example: <leader>b to list all open buffers
vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = '[B]uffers' })
