require("catppuccin").setup({
    flavour = "latte",
    background = {
        light = "latte",
        dark = "macchiato",
    },
})
vim.cmd.colorscheme "catppuccin-latte"

if os.getenv('theme') == 'dark' then
    vim.o.background = 'dark'
else
    vim.o.background = 'light'
end

require('staline').setup{}
