 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#1d1c21',
    base01 = '#302f37',
    base02 = '#2b2a32',
    base03 = '#686676',
    base04 = '#b0afb6',
    base05 = '#f2f2f3',
    base06 = '#f2f2f3',
    base07 = '#f2f2f3',
    base08 = '#fd4663',
    base09 = '#ad85a7',
    base0A = '#9f81b1',
    base0B = '#938bc1',
    base0C = '#d0afcb',
    base0D = '#b2acd3',
    base0E = '#c3afd0',
    base0F = '#dccde4',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#f2f2f3',          bg = '#1d1c21' })
  hi('TelescopeBorder',         { fg = '#686676',             bg = '#1d1c21' })
  hi('TelescopePromptNormal',   { fg = '#f2f2f3',          bg = '#1d1c21' })
  hi('TelescopePromptBorder',   { fg = '#686676',             bg = '#1d1c21' })
  hi('TelescopePromptPrefix',   { fg = '#938bc1',             bg = '#1d1c21' })
  hi('TelescopePromptCounter',  { fg = '#b0afb6',  bg = '#1d1c21' })
  hi('TelescopePromptTitle',    { fg = '#1d1c21',             bg = '#938bc1' })
  hi('TelescopePreviewTitle',   { fg = '#1d1c21',             bg = '#9f81b1' })
  hi('TelescopeResultsTitle',   { fg = '#1d1c21',             bg = '#ad85a7' })
  hi('TelescopeSelection',      { fg = '#f2f2f3',          bg = '#2b2a32' })
  hi('TelescopeSelectionCaret', { fg = '#938bc1',             bg = '#2b2a32' })
  hi('TelescopeMatching',       { fg = '#938bc1',             bold = true })
end

-- Register a signal handler for SIGUSR1 (matugen updates).
-- The handler re-requires this module, which re-runs the code below, so the
-- previous handle is stopped first; otherwise handlers double on every signal.
if _G.__matugen_signal then
  _G.__matugen_signal:stop()
  _G.__matugen_signal:close()
end

local signal = vim.uv.new_signal()
_G.__matugen_signal = signal
signal:start(
  'sigusr1',
  vim.schedule_wrap(function()
    package.loaded['matugen'] = nil
    require('matugen').setup()
  end)
)

return M
