require'lsp_extensions'.inlay_hints{
	highlight = "Comment",
	prefix = " > ",
	aligned = false,
	only_current_line = false,
	enabled = { "ChainingHint" }
}

vim.cmd [[autocmd InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs :lua require'lsp_extensions'.inlay_hints{ prefix = ' » ', highlight = "NonText", enabled = {"ChainingHint"} }]]

-- tree-sitter
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = "all", highlight = {enable = true}, sync_install = false}

-- LSP
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "pyright", "clangd", "denols", "gopls", "tsserver", "svelte"},
}

local lsp = require('lspconfig')
lsp.rust_analyzer.setup{}
lsp.clangd.setup{
    single_file_support = false
}
lsp.pyright.setup{}
lsp.svelte.setup{}
lsp.denols.setup{}
lsp.tsserver.setup{}
lsp.gopls.setup{}

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

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

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
