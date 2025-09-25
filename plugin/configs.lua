-- Line numbering
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.number = true         -- Show line numbers

-- Cursor
vim.opt.startofline = false  -- Don't go to the start of the line when moving to another file
vim.opt.smartindent = true   -- Auto-indent
vim.opt.cursorcolumn = false -- Don't highlight the current column
vim.opt.cursorline = true    -- Highlight the current line

-- Search
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true  -- Do not ignore case with capitals
vim.opt.incsearch = true  -- Incremental search

-- Formatting
vim.opt.tabstop = 4      -- Tab size
vim.opt.shiftwidth = 4   -- Size of an indent when using >, <, etc.
vim.opt.expandtab = true -- Use spaces instead of tabs

-- Sidescroll
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 3

-- status line
vim.opt.laststatus = 2  -- always show status line
vim.opt.showtabline = 0 -- always show tab line

-- mouse config
vim.opt.mouse = "a"                 -- mouse in all modes
vim.opt.mousemodel = "popup_setpos" -- use right-click as a menu

-- windows
vim.opt.winborder = "rounded"

-- Misc.
vim.opt.termguicolors = true         -- True color support
vim.opt.swapfile = false             -- Disable swap files
vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

if vim.o.background == 'dark' then
    print("dark")
    vim.cmd("colorscheme tokyonight-storm")
    -- vim.cmd("colorscheme dracula")
else
    print('light')
    vim.cmd("colorscheme tokyonight-day")
    -- vim.cmd("colorscheme gruvbox")
end

vim.api.nvim_create_autocmd({"OptionSet"}, {
    pattern = {"background"},
    callback = function(ev)
        if vim.o.background == 'dark' then
            print('late dark')
            vim.cmd("colorscheme tokyonight-storm")
            -- vim.cmd("colorscheme dracula")
        else
            print('late light')
            vim.cmd("colorscheme tokyonight-day")
            -- vim.cmd("colorscheme gruvbox")
        end
        -- force a full redraw:
        vim.cmd("mode")
    end
})
