require("catppuccin").setup({
    flavour = "macchiato",
    background = {
        light = "latte",
        dark = "macchiato",
    },
})
vim.cmd.colorscheme "catppuccin-macchiato"

--if os.getenv('theme') == 'dark' then
--    vim.o.background = 'dark'
--else
--    vim.o.background = 'light'
--end

require('staline').setup{}
