-- Line numbering
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.number = true -- Show line numbers

-- Cursor
vim.opt.startofline = false -- Don't go to the start of the line when moving to another file
vim.opt.smartindent = true -- Auto-indent
vim.opt.cursorcolumn = false -- Don't highlight the current column
vim.opt.cursorline = true -- Highlight the current line

-- Search
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Do not ignore case with capitals
vim.opt.incsearch = true -- Incremental search

-- Formatting
vim.opt.tabstop = 4 -- Tab size
vim.opt.shiftwidth = 4 -- Size of an indent when using >, <, etc.
vim.opt.expandtab = true -- Use spaces instead of tabs

-- Sidescroll
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 3

-- status line
vim.opt.laststatus = 2 -- always show status line
vim.opt.showtabline = 0 -- always show tab line

-- mouse config
vim.opt.mouse = "a" -- mouse in all modes
vim.opt.mousemodel = "popup_setpos" -- use right-click as a menu

-- windows
vim.opt.winborder = "rounded"

-- Misc.
vim.opt.termguicolors = true -- True color support
vim.opt.swapfile = false -- Disable swap files
vim.cmd.filetype("plugin indent on") -- Enable filetype detection, plugins, and indentation

require("tokyonight").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})

local function clear_bg_highlights()
	local groups = {
		"Normal",
		"NormalNC",
		"NormalFloat",
		"FloatBorder",
		"SignColumn",
		"CursorLine",
		"CursorColumn",
		"LineNr",
		"CursorLineNr",
		"EndOfBuffer",
		"MsgArea",
		"WinSeparator",
		"Pmenu",
		"StatusLine",
		"StatusLineNC",
		"RenderMarkdownCode",
	}
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none" })
	end
end

-- Mix `fg` toward `bg` by `alpha` (1 = fg, 0 = bg). Used to fake "transparency"
-- for things (inlay hint text, diagnostic tints) that terminals can't blend for real.
local function blend(fg, bg, alpha)
	local fr, fg_g, fb = math.floor(fg / 65536) % 256, math.floor(fg / 256) % 256, fg % 256
	local br, bg_g, bb = math.floor(bg / 65536) % 256, math.floor(bg / 256) % 256, bg % 256
	local r = math.floor(fr * alpha + br * (1 - alpha))
	local g = math.floor(fg_g * alpha + bg_g * (1 - alpha))
	local b = math.floor(fb * alpha + bb * (1 - alpha))
	return string.format("#%02x%02x%02x", r, g, b)
end

-- tokyonight's `transparent = true` already clears Normal's bg by the time the
-- colorscheme command returns, so we can't read the blend target off the live
-- Normal highlight -- pull it straight from the theme's palette instead.
local function fade_highlights(style)
	local bg = require("tokyonight.colors").setup({ style = style }).bg
	bg = tonumber(bg:sub(2), 16)

	local inlay = vim.api.nvim_get_hl(0, { name = "LspInlayHint" })
	if inlay.fg then
		vim.api.nvim_set_hl(0, "LspInlayHint", { fg = blend(inlay.fg, bg, 0.55), bg = "none", italic = true })
	end

	-- Soften diagnostic virtual text backgrounds instead of removing them outright,
	-- keep the foreground text color as-is.
	for _, group in ipairs({
		"DiagnosticVirtualTextError",
		"DiagnosticVirtualTextWarn",
		"DiagnosticVirtualTextInfo",
		"DiagnosticVirtualTextHint",
	}) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		if hl.bg then
			vim.api.nvim_set_hl(0, group, { fg = hl.fg, bg = blend(hl.bg, bg, 0.35) })
		end
	end
end

if vim.o.background == "dark" then
	vim.cmd("colorscheme tokyonight-storm")
	-- vim.cmd("colorscheme dracula")
	fade_highlights("storm")
else
	vim.cmd("colorscheme tokyonight-day")
	-- vim.cmd("colorscheme gruvbox")
	fade_highlights("day")
end
clear_bg_highlights()

vim.api.nvim_create_autocmd({ "OptionSet" }, {
	pattern = { "background" },
	callback = function(ev)
		if vim.o.background == "dark" then
			vim.cmd("colorscheme tokyonight-storm")
			-- vim.cmd("colorscheme dracula")
			fade_highlights("storm")
		else
			vim.cmd("colorscheme tokyonight-day")
			-- vim.cmd("colorscheme gruvbox")
			fade_highlights("day")
		end
		clear_bg_highlights()
		-- force a full redraw:
		vim.cmd("mode")
	end,
})

vim.opt.exrc = true -- Enable reading local config files
vim.opt.secure = true -- Prevent unsafe commands in local configs

vim.opt.undofile = true

vim.o.shell = "/bin/bash" -- Running external commands through a non-POSIX shell can cause issues.
vim.o.shellcmdflag = "-c"
