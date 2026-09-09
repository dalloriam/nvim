-- Spawns terminal panes through whichever multiplexer nvim is running under
-- (zellij or tmux), so plugin code doesn't need to branch on its own.
local M = {}

function M.is_zellij()
    return vim.env.ZELLIJ_PANE_ID ~= nil
end

function M.is_tmux()
    return vim.env.TMUX ~= nil
end

function M.active()
    return M.is_zellij() or M.is_tmux()
end

-- Wrap a shell command string so the pane it runs in doesn't just vanish
-- when the command finishes (both tmux and zellij close panes as soon as
-- their child process exits). After `cmd` exits:
--   <Enter>  reruns the command
--   <Esc>    drops to an interactive shell in the pane
--   <C-c>    sends SIGINT while we're waiting on input, which (uncaught)
--            kills this wrapper script and lets the pane close as usual
function M.rerunnable(cmd)
    return string.format([[
while true; do
  %s
  status=$?
  printf '\n[harpoon] exited (%%d) \xe2\x80\x94 <Enter> rerun, <Esc> shell, <C-c> close\n' "$status"
  while true; do
    IFS= read -rsn1 key
    if [ -z "$key" ]; then
      break
    elif [ "$key" = "$(printf '\033')" ]; then
      exec "${SHELL:-bash}"
    fi
  done
done
]], cmd)
end

-- Run `cmd` (a list, e.g. {"claude", "--foo"}) in a new pane/window.
-- opts:
--   cwd       working directory (default: vim.loop.cwd())
--   name      pane title (zellij only; tmux has no per-pane title for this)
--   floating  open as a floating pane (zellij only; tmux always splits)
--   width, height  size when floating, e.g. "90%"
--   direction "right" (default) or "down" when not floating
function M.spawn(cmd, opts)
    opts = opts or {}
    local cwd = opts.cwd or vim.loop.cwd()

    if M.is_zellij() then
        local args = { "zellij", "action", "new-pane", "--cwd", cwd }
        if opts.name then
            vim.list_extend(args, { "--name", opts.name })
        end
        if opts.floating then
            vim.list_extend(args, {
                "--floating",
                "--width", opts.width or "90%",
                "--height", opts.height or "80%",
            })
        else
            vim.list_extend(args, { "--direction", opts.direction or "right" })
        end
        vim.list_extend(args, { "--" })
        vim.list_extend(args, cmd)
        vim.system(args, { detach = true })
        return
    end

    if M.is_tmux() then
        local flag = (opts.direction == "down") and "-v" or "-h"
        local args = { "tmux", "split-window", flag, "-c", cwd, "--" }
        vim.list_extend(args, cmd)
        vim.system(args, { detach = true })
        return
    end

    error("multiplexer.spawn called outside zellij/tmux")
end

return M
