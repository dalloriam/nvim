vim.pack.add({
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/saghen/blink.cmp",              version = vim.version.range("^1") },
    { src = "https://github.com/ms-jpq/chadtree" },
    { src = "https://github.com/mcauley-penney/techbase.nvim" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/NeogitOrg/neogit" },
    { src = "https://github.com/ThePrimeagen/harpoon",          version = "harpoon2" },
    { src = "https://github.com/github/copilot.vim" },
    { src = "https://github.com/numtostr/FTerm.nvim" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/nvim-tree/nvim-web-devicons" },
    { src = "https://github.com/romgrk/barbar.nvim" },
    { src = "https://github.com/famiu/bufdelete.nvim" },
    { src = "https://github.com/jiangmiao/auto-pairs" },
    { src = "https://github.com/NoahTheDuke/vim-just" },
    { src = "https://github.com/kylechui/nvim-surround" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
    { src = "https://github.com/sbdchd/neoformat" },
    { src = "https://github.com/fatih/vim-go" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
    { src = "https://github.com/mrcjkb/rustaceanvim" }
}, { load = true })

require('gitsigns').setup({})
require('mason').setup({})

require('blink.cmp').setup({
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
    keymap = {
        preset = "default",
        ["<C-space>"] = {},
        ["<C-p>"] = {},
        ["<S-Tab>"] = {},
        ['<Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then
                    return cmp.accept()
                else
                    return cmp.select_and_accept()
                end
            end,
            'snippet_forward',
            'fallback'
        },
        ["<C-k>"] = { "select_prev", "fallback" },
        ["<C-j>"] = { "select_next", "fallback" },
        -- ["<C-e>"] = { "hide" },
    },

    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
        keymap = {
            preset = 'inherit',
            ['<CR>'] = { 'accept_and_enter', 'fallback' },
        },
    },

    sources = { default = { "lsp" } }
})

require('techbase').setup({})

require 'nvim-web-devicons'.setup {
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
}


require 'barbar'.setup {}

local ts = require 'nvim-treesitter.configs'
ts.setup {
    ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "go", "cpp", "python", "javascript", "typescript", "html", "css", "bash", "json", "yaml", "toml", "dockerfile" },
    highlight = {enable = true},
    sync_install = false
}

require("codecompanion").setup({})
