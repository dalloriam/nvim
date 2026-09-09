 local M = {}

function M.setup()
  require('base16-colorscheme').setup({
    base00 = '#e1e7ea',
    base01 = '#d6dee1',
    base02 = '#cfd9de',
    base03 = '#78868c',
    base04 = '#505558',
    base05 = '#181a1b',
    base06 = '#181a1b',
    base07 = '#181a1b',
    base08 = '#fd4663',
    base09 = '#4a367d',
    base0A = '#384b94',
    base0B = '#348db2',
    base0C = '#3f2e6b',
    base0D = '#285c71',
    base0E = '#2a386f',
    base0F = '#384b94',
  })

  local hi = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
  end

  hi('TelescopeNormal',         { fg = '#181a1b',          bg = '#e1e7ea' })
  hi('TelescopeBorder',         { fg = '#78868c',             bg = '#e1e7ea' })
  hi('TelescopePromptNormal',   { fg = '#181a1b',          bg = '#e1e7ea' })
  hi('TelescopePromptBorder',   { fg = '#78868c',             bg = '#e1e7ea' })
  hi('TelescopePromptPrefix',   { fg = '#348db2',             bg = '#e1e7ea' })
  hi('TelescopePromptCounter',  { fg = '#505558',  bg = '#e1e7ea' })
  hi('TelescopePromptTitle',    { fg = '#e1e7ea',             bg = '#348db2' })
  hi('TelescopePreviewTitle',   { fg = '#e1e7ea',             bg = '#384b94' })
  hi('TelescopeResultsTitle',   { fg = '#e1e7ea',             bg = '#4a367d' })
  hi('TelescopeSelection',      { fg = '#181a1b',          bg = '#cfd9de' })
  hi('TelescopeSelectionCaret', { fg = '#348db2',             bg = '#cfd9de' })
  hi('TelescopeMatching',       { fg = '#348db2',             bold = true })
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
