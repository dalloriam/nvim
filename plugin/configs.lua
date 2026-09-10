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
-- The statusline is the only divider between stacked splits, and its highlights
-- are cleared for transparency below -- draw it as a rule so hsplits stay distinct.
vim.opt.fillchars:append({ stl = "─", stlnc = "─" })
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

	-- Dim the base diagnostic colors (used by signs, underlines' sp fallback,
	-- floating windows, etc). Error is toned down more than Warn so red -- which
	-- reads hotter than orange to begin with -- doesn't end up louder overall.
	local base_alphas = {
		DiagnosticError = 0.75,
		DiagnosticWarn = 0.85,
		DiagnosticInfo = 0.9,
		DiagnosticHint = 0.9,
	}
	for group, alpha in pairs(base_alphas) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		if hl.fg then
			vim.api.nvim_set_hl(0, group, { fg = blend(hl.fg, bg, alpha) })
		end
	end

	-- Same treatment for the squiggly underlines (their color lives in `sp`).
	local underline_alphas = {
		DiagnosticUnderlineError = 0.55,
		DiagnosticUnderlineWarn = 0.65,
		DiagnosticUnderlineInfo = 0.7,
		DiagnosticUnderlineHint = 0.7,
	}
	for group, alpha in pairs(underline_alphas) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		if hl.sp then
			hl.sp = blend(hl.sp, bg, alpha)
			hl.link = nil
			vim.api.nvim_set_hl(0, group, hl)
		end
	end

	-- Soften diagnostic virtual text foreground (Error dimmed more than Warn)
	-- and always drop the background tint entirely.
	local vt_alphas = {
		DiagnosticVirtualTextError = 0.55,
		DiagnosticVirtualTextWarn = 0.65,
		DiagnosticVirtualTextInfo = 0.7,
		DiagnosticVirtualTextHint = 0.7,
	}
	for group, alpha in pairs(vt_alphas) do
		local hl = vim.api.nvim_get_hl(0, { name = group })
		if hl.fg then
			vim.api.nvim_set_hl(0, group, { fg = blend(hl.fg, bg, alpha), bg = "none" })
		end
	end
end

-- tokyonight draws inline `code` as blue on terminal_black, which is ~3.5:1 in
-- storm and ~1.7:1 in day. Move it onto the subtler bg_dark box, and darken the
-- blue in day since nothing in that palette clears 4.5:1 as-is.
local function readable_inline_code(style)
	local c = require("tokyonight.colors").setup({ style = style })
	local fg = c.blue
	if style == "day" then
		fg = blend(tonumber(fg:sub(2), 16), 0, 0.7)
	end
	vim.api.nvim_set_hl(0, "@markup.raw.markdown_inline", { fg = fg, bg = c.bg_dark })
end

if vim.o.background == "dark" then
	vim.cmd("colorscheme tokyonight-storm")
	-- vim.cmd("colorscheme dracula")
	fade_highlights("storm")
	readable_inline_code("storm")
else
	vim.cmd("colorscheme tokyonight-day")
	-- vim.cmd("colorscheme gruvbox")
	fade_highlights("day")
	readable_inline_code("day")
end
clear_bg_highlights()

vim.api.nvim_create_autocmd({ "OptionSet" }, {
	pattern = { "background" },
	callback = function(ev)
		if vim.o.background == "dark" then
			vim.cmd("colorscheme tokyonight-storm")
			-- vim.cmd("colorscheme dracula")
			fade_highlights("storm")
			readable_inline_code("storm")
		else
			vim.cmd("colorscheme tokyonight-day")
			-- vim.cmd("colorscheme gruvbox")
			fade_highlights("day")
			readable_inline_code("day")
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
