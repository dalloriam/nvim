-- Opening a multiplexer pane beside nvim (`:Claude`, harpoon commands, or any
-- plain tmux split) shrinks nvim's terminal, and nvim redistributes the lost
-- columns by squeezing the rightmost splits rather than scaling them all. The
-- space doesn't find its way back when the pane closes -- three even vsplits
-- come back as 66/28/104 -- so snapshot the layout whenever it settles and
-- replay it verbatim once the terminal returns to the size it was taken at.
local saved = {} -- [tabpage handle] = { cols, lines, cmd, wins }

-- VimResized fires while nvim is reflowing the splits itself; the WinResized
-- that follows in the same pass is that reflow, not the user resizing a split,
-- so it must not overwrite the snapshot we're trying to restore from.
local reflowing = false

local function win_ids()
    return table.concat(vim.api.nvim_tabpage_list_wins(0), ",")
end

local function snapshot()
    -- winrestcmd()/:resize are off-limits while the cmdline window is open.
    if vim.fn.getcmdwintype() ~= "" then
        return
    end
    saved[vim.api.nvim_get_current_tabpage()] = {
        cols = vim.o.columns,
        lines = vim.o.lines,
        cmd = vim.fn.winrestcmd(),
        wins = win_ids(),
    }
end

local function restore()
    local snap = saved[vim.api.nvim_get_current_tabpage()]
    if not snap or vim.fn.getcmdwintype() ~= "" then
        return
    end
    -- Only replay onto the exact terminal size and window set it came from;
    -- anything else and the recorded sizes wouldn't add up anyway.
    if snap.cols ~= vim.o.columns or snap.lines ~= vim.o.lines or snap.wins ~= win_ids() then
        return
    end
    vim.cmd(snap.cmd)
end

local group = vim.api.nvim_create_augroup("restore_split_sizes", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
    group = group,
    callback = function()
        reflowing = true
        restore()
    end,
})

vim.api.nvim_create_autocmd("WinResized", {
    group = group,
    callback = function()
        if reflowing then
            reflowing = false
            return
        end
        snapshot()
    end,
})

-- Layout changes settle after the event fires, hence the schedule.
vim.api.nvim_create_autocmd({ "VimEnter", "WinNew", "WinClosed", "TabEnter" }, {
    group = group,
    callback = function()
        vim.schedule(snapshot)
    end,
})

vim.api.nvim_create_autocmd("TabClosed", {
    group = group,
    callback = function()
        for tab in pairs(saved) do
            if not vim.api.nvim_tabpage_is_valid(tab) then
                saved[tab] = nil
            end
        end
    end,
})
