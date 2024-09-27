require "paq" {
	"savq/paq-nvim",
    {
        "catppuccin/nvim", 
    },
	"nvim-lua/plenary.nvim", -- telescope dependency
	"nvim-telescope/telescope.nvim", -- fuzzy finding & file switcher
	'kosayoda/nvim-lightbulb', -- display a lightbulb when code actions are available
    'williamboman/mason.nvim', -- LSP Installer
    "williamboman/mason-lspconfig.nvim",
	'neovim/nvim-lspconfig', -- LSP helper
	'nvim-treesitter/nvim-treesitter', -- better syntax highlighting
	'hrsh7th/nvim-cmp', -- LSP autocompletion
	'tamton-aquib/staline.nvim',
	'kyazdani42/nvim-web-devicons', -- file icons
	'ms-jpq/chadtree', -- file tree
	'rust-lang/rust.vim', -- rust tools
	'nvim-lua/lsp_extensions.nvim', -- inlay hints for rust
	'jiangmiao/auto-pairs', -- auto-close bracket pairs
	'romgrk/barbar.nvim', -- tab bar
	'sbdchd/neoformat', -- non-rust auto-formatting (mainly for clang-format)
	'NoahTheDuke/vim-just', -- casey/just support
	'lewis6991/gitsigns.nvim', -- git gutter signs
	'famiu/bufdelete.nvim', -- Buffer delete without screwing up window layout
	'numtostr/FTerm.nvim', -- floating terminal
    'github/copilot.vim', -- github copilot
    'lukas-reineke/indent-blankline.nvim', -- indent lines
    'kylechui/nvim-surround', -- surround
    'NeogitOrg/neogit', -- git
    'sindrets/diffview.nvim', -- git diffs
    'theprimeagen/harpoon', -- file management
    'folke/trouble.nvim', -- error lens
    'hrsh7th/cmp-nvim-lsp',
    {
        'kepano/flexoki-neovim', 
        as = 'flexoki',
    } -- theme
}
