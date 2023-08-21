-- Shorthand function for creating keybinds.
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

vim.g.mapleader = ' ' -- set leader key to comma

-- telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>') -- find files
map('n', '<C-f>', '<cmd>Telescope live_grep<cr>') -- find in files
map('n', '<C-b>', '<cmd>Telescope lsp_definitions<cr>') -- go to definition

-- tab controls
map('n', 'gt', '<cmd>BufferNext<cr>') -- next tab
map('n', 'gT', '<cmd>BufferPrevious<cr>') -- previous tab

-- buffers
map('n', '<C-w>', '<cmd>Bdelete<cr>') -- close active buffer
map('n', '<C-l>', '<cmd>winc l<cr>') -- move to right window
map('n', '<C-h>', '<cmd>winc h<cr>') -- move to left window
map('n', '<C-j>', '<cmd>winc j<cr>') -- move to bottom window
map('n', '<C-k>', '<cmd>winc k<cr>') -- move to top window

-- yank
map('n', '<leader>y', '"+y') -- copy to clipboard
map('v', '<leader>y', '"+y') -- copy to clipboard
map('v', '<leader>Y', '"+Y') -- copy to clipboard

-- terminal mode
map('t', '<Esc>', '<C-\\><C-n>') -- exit terminal mode
map('n', '<leader>t', '<cmd>lua require(\'FTerm\').toggle()<cr>') -- Open terminal

-- git
map('n', '<leader>gs', '<cmd>Neogit kind=auto<cr>') -- git status

-- misc
map('n', '<C-n>', '<cmd>CHADopen<cr>') -- toggle CHADtree
map('n', ',<leader>', '<cmd>noh<cr>') -- clear search highlights
