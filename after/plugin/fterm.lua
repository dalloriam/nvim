local fterm = require('FTerm')
fterm.setup {}

-- Just task runner support
function run_just(opts)
    fterm.scratch({ cmd = { "just", unpack(opts.fargs) }, auto_close = true })
end

-- Create a command that runs a given just task
vim.api.nvim_create_user_command('Just', run_just, { nargs = "+" })

-- Terminal Keymaps
 vim.keymap.set("n", "<leader>t", function()
  if vim.env.ZELLIJ_PANE_ID then
    vim.system({
      "zellij", "action", "new-pane", "-c",
      "--cwd", vim.loop.cwd(),
      "--", vim.env.SHELL
    }, { detach = true })
  else
    fterm.toggle()
  end
end)
