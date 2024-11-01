--require("catppuccin").setup({
--    flavour = "macchiato",
--    background = {
--        light = "latte",
--        dark = "macchiato",
--    },
--})
--vim.cmd.colorscheme "catppuccin-macchiato"

require("monokai-pro").setup({
})
vim.cmd.colorscheme "monokai-pro"


--if os.getenv('theme') == 'dark' then
--    vim.o.background = 'dark'
--else
--    vim.o.background = 'light'
--end

require('staline').setup{}
