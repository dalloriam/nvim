local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

-- For keybinds
local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- dependencies
require "paq" {
	"savq/paq-nvim",
    "catppuccin/nvim",
	"nvim-lua/plenary.nvim", -- telescope dependency
	"nvim-telescope/telescope.nvim", -- fuzzy finding & file switcher
	'kosayoda/nvim-lightbulb', -- display a lightbulb when code actions are available
	'neovim/nvim-lspconfig', -- LSP helper
	'nvim-treesitter/nvim-treesitter', -- better syntax highlighting
	'hrsh7th/nvim-compe', -- LSP autocompletion
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
}

-- misc editor settings
opt.relativenumber = true
opt.number = true
opt.termguicolors = true
opt.startofline = false
opt.ignorecase = true
opt.smartcase = true -- Do not ignore case with capitals
opt.smartindent = true -- Auto-indent
opt.sidescroll=1
opt.sidescrolloff=3
opt.tabstop=4
opt.shiftwidth=4
opt.expandtab=true

-- color scheme
require("catppuccin").setup({
    flavour = "latte",
    background = {
        light = "latte",
        dark = "mocha",
    },
})
vim.cmd.colorscheme "catppuccin-latte"


-- cursor columns
opt.cursorcolumn = false
opt.cursorline = true

-- status line
opt.laststatus=2
opt.showtabline=2

-- mouse config
opt.mouse = "a" -- mouse in all modes
opt.mousemodel = "popup_setpos" -- use right-click as a menu

-- autoformat
cmd 'augroup fmt'
  cmd 'autocmd!'
  cmd 'autocmd BufWritePre * undojoin | Neoformat'
cmd 'augroup END'

-- rust
-- g.rustfmt_autosave = 1 -- Format on save
require'lsp_extensions'.inlay_hints{
	highlight = "Comment",
	prefix = " > ",
	aligned = false,
	only_current_line = false,
	enabled = { "ChainingHint" }
}

--inlay hints
vim.cmd [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }]]

-- tree-sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = "all", highlight = {enable = true}, sync_install = false}

-- LSP
local lsp = require('lspconfig')
lsp.rust_analyzer.setup{}
lsp.clangd.setup{
    single_file_support = false
}
lsp.pyright.setup{}

-- nvim-compe (autocomplete)
vim.o.completeopt = "menuone,noselect"
require'compe'.setup {
    enabled = true;
    autocomplete = true;
    debug = false;
    min_length = 1;
    preselect = 'enable';
    throttle_time = 100;
    source_timeout = 200;
    resolve_timeout = 800;
    incomplete_delay = 400;
    max_abbr_width = 100;
    max_kind_width = 100;
    max_menu_width = 100;
    documentation = {
      border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
      winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
      max_width = 120,
      min_width = 60,
      max_height = math.floor(vim.o.lines * 0.3),
      min_height = 1,
    };

    source = {
      path = true;
      buffer = true;
      calc = true;
      nvim_lsp = true;
      nvim_lua = true;
      vsnip = true;
      ultisnips = true;
      luasnip = true;
    };
  }

  local t = function(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
  end

  local check_back_space = function()
      local col = vim.fn.col('.') - 1
      if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
          return true
      else
          return false
      end
  end

  -- Use (s-)tab to:
  --- move to prev/next item in completion menuone
  --- jump to prev/next snippet's placeholder
  _G.tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-n>"
    elseif check_back_space() then
      return t "<Tab>"
    else
      return vim.fn['compe#complete']()
    end
  end
  _G.s_tab_complete = function()
    if vim.fn.pumvisible() == 1 then
      return t "<C-p>"
    else
      return t "<S-Tab>"
    end
  end

  vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
  vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

-- lightbulb (code actions)
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]


-- file icons
require'nvim-web-devicons'.setup {
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true;
   }

-- git
require 'gitsigns'.setup{}

-- status bar
require('staline').setup{}

-- floating terminal
require('FTerm').setup{}

-- keybinds
g.mapleader = ','

-- telescope
map('n', '<C-p>', '<cmd>Telescope find_files<cr>')
map('n', '<C-f>', '<cmd>Telescope live_grep<cr>')
map('n', '<C-b>', '<cmd>Telescope lsp_definitions<cr>')

-- tab controls
map('n', 'gt', '<cmd>BufferNext<cr>')
map('n', 'gT', '<cmd>BufferPrevious<cr>')

-- buffers
map('n', '<C-w>', '<cmd>Bdelete<cr>')
map('n', '<C-l>', '<cmd>winc l<cr>')
map('n', '<C-h>', '<cmd>winc h<cr>')
map('n', '<C-j>', '<cmd>winc j<cr>')
map('n', '<C-k>', '<cmd>winc k<cr>')

-- terminal mode
map('t', '<Esc>', '<C-\\><C-n>')
map('n', '<leader>t', '<cmd>lua require(\'FTerm\').toggle()<cr>')

-- misc
map('n', '<C-n>', '<cmd>CHADopen<cr>') -- toggle CHADtree
map('n', '<leader><Space>', '<cmd>noh<cr>') -- clear search highlights
