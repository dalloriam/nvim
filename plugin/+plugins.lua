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
    { src = "https://github.com/famiu/bufdelete.nvim" },
    { src = "https://github.com/jiangmiao/auto-pairs" },
    { src = "https://github.com/NoahTheDuke/vim-just" },
    { src = "https://github.com/kylechui/nvim-surround" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/sbdchd/neoformat" },
    { src = "https://github.com/fatih/vim-go" },
    { src = "https://github.com/olimorris/codecompanion.nvim" },
    { src = "https://github.com/mrcjkb/rustaceanvim" },
    { src = "https://github.com/folke/trouble.nvim" },
    { src = "https://github.com/MeanderingProgrammer/render-markdown.nvim"},
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/kylechui/nvim-surround" },
    { src = "https://github.com/b0o/incline.nvim" },
    { src = "https://github.com/nvim-neotest/nvim-nio" },
    { src = "https://github.com/antoinemadec/FixCursorHold.nvim" },
    { src = "https://github.com/nvim-neotest/neotest" },
    { src = "https://github.com/orjangj/neotest-ctest" },
    { src = "https://github.com/mfussenegger/nvim-dap" },
    { src = "https://github.com/rcarriga/nvim-dap-ui" },
    { src = "https://github.com/SGauvin/ctest-telescope.nvim" },
    { src = "https://github.com/fredrikaverpil/neotest-golang" },
    { src = "https://github.com/leoluz/nvim-dap-go" },
    { src = "https://github.com/nvimdev/indentmini.nvim" }
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
        nerd_font_variant = "normal",
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        }
    },

    cmdline = {
      keymap = { preset = 'inherit' },
      completion = { menu = { auto_show = true } },
    },

    sources = { default = { "lsp", "path", "snippets", "buffer" } }
})

require('techbase').setup({})

require 'nvim-web-devicons'.setup {
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
}


local ts = require('nvim-treesitter')
ts.install({ "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "go", "cpp", "python", "javascript", "typescript", "html", "css", "bash", "json", "yaml", "toml", "dockerfile" })

require("codecompanion").setup({})
require("nvim-surround").setup({})

require("incline").setup({
  window = {
    margin = { vertical = 0, horizontal = 1 },
    padding = 1,
    placement = { horizontal = "right", vertical = "top" },
    width = "fit",
    winhighlight = {
      active = { Normal = "Normal" },
      inactive = { Normal = "NormalNC" },
    },
  },
  render = function(props)
    local devicons = require("nvim-web-devicons")
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end
    local ext = vim.fn.fnamemodify(filename, ":e")
    local icon, color = devicons.get_icon_color(filename, ext, { default = true })

    local modified = vim.bo[props.buf].modified and " ●" or ""

    return {
      { icon, guifg = color },       -- icon keeps its devicon color
      { " " .. filename },            -- filename inherits theme
      { modified, guifg = color },    -- optional: modified uses same color as icon
    }
  end,
})

require("indentmini").setup()

