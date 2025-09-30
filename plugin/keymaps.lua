-- Shorthand function for creating keybinds.
local function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' ' -- set leader key to spacebar

-- telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>')      -- find files
map('n', '<C-f>', '<cmd>Telescope live_grep<cr>')       -- find in files
map('n', '<C-b>', '<cmd>Telescope lsp_definitions<cr>') -- go to definition
map('n', '<C-o>', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>') -- list symbols

-- lsp
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)

-- trouble (diagnostics)
map('n', '<leader>xx', '<cmd>Trouble cascade toggle<cr>')              -- toggle trouble
map('n', '<leader>xX', '<cmd>Trouble cascade toggle filter.buf=0<cr>') -- toggle trouble (current buffer only)
map('n', '<leader>cs', '<cmd>Trouble symwide toggle focus=false<cr>')  -- Symbols
map('n', '<leader>xL', '<cmd>Trouble loclist toggle<cr>')              -- Location List
map('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>')               -- Quickfix List

-- buffers
map('n', '<leader>w', '<cmd>Bdelete<cr>') -- close active buffer
map('n', '<C-l>', '<cmd>winc l<cr>')      -- move to right window
map('n', '<C-h>', '<cmd>winc h<cr>')      -- move to left window
map('n', '<C-j>', '<cmd>winc j<cr>')      -- move to bottom window
map('n', '<C-k>', '<cmd>winc k<cr>')      -- move to top window

-- yank
map('n', '<leader>y', '"+y') -- copy to clipboard
map('v', '<leader>y', '"+y') -- copy to clipboard
map('v', '<leader>Y', '"+Y') -- copy to clipboard

-- terminal mode
map('t', '<Esc>', '<C-\\><C-n>') -- exit terminal mode

-- git
map('n', '<leader>gs', '<cmd>Neogit kind=auto<cr>') -- git status

-- misc
map('n', '<C-n>', '<cmd>CHADopen<cr>') -- toggle CHADtree
map('n', ',<leader>', '<cmd>noh<cr>')  -- clear search highlights

-- Copy/paste for neovide
if vim.g.neovide then
    vim.keymap.set('n', '<D-s>', ':w<CR>')    -- Save
    vim.keymap.set('v', '<D-c>', '"+y')       -- Copy
    vim.keymap.set('n', '<D-v>', '"+P')       -- Paste normal mode
    vim.keymap.set('v', '<D-v>', '"+P')       -- Paste visual mode
    vim.keymap.set('c', '<D-v>', '<C-R>+')    -- Paste command mode
    vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- Allow clipboard copy paste in neovim
vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })
