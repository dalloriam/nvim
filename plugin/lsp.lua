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
vim.lsp.config("bashls", {})
vim.lsp.config("lua_ls", {})

