require('mason-lspconfig').setup({
    ensure_installed = {
        "bashls",
        "gopls",
        "lua_ls",
        "clangd"
    },
    automatic_enable = true
})

vim.diagnostic.config({ virtual_text = true })

local lsp = require('lspconfig')
lsp.bashls.setup({})
lsp.gopls.setup({})
lsp.lua_ls.setup({})
lsp.clangd.setup({})
