require('mason-lspconfig').setup({
    ensure_installed = {
        "bashls",
        "gopls",
        "lua_ls",
        "clangd",
        "markdown_oxide",
        "pyright",
        "ruff",
    },
    automatic_enable = true
})

vim.diagnostic.config({ virtual_text = true })

local lsp = require('lspconfig')
lsp.bashls.setup({})
lsp.lua_ls.setup({})
lsp.clangd.setup({})

