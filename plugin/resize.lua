-- Opening a multiplexer pane beside nvim (`:Claude`, harpoon commands, or any
-- plain tmux split) shrinks nvim's terminal, and nvim takes the lost columns
-- out of the rightmost splits rather than scaling them all -- so the new pane
-- looks like it's sitting on top of nvim's last split, and three even vsplits
-- come back as 66/28/104 once it closes. Instead, snapshot the layout whenever
-- it settles and, on every terminal resize, scale that snapshot to the new
-- size the way the multiplexer scales its own panes. Scaling is always done
-- from the snapshot (not the current, already-scaled layout), so there's no
-- rounding drift and the original layout comes back exactly.
local saved = {} -- [tabpage handle] = { cols, rows, wins, splits }

-- VimResized fires while nvim is reflowing the splits itself; the WinResized
-- that follows in the same pass is that reflow, not the user resizing a split,
-- so it must not overwrite the snapshot we're trying to restore from.
local reflowing = false

-- Floats sit on top of the layout rather than taking part in it, and plugins
-- like incline open/close theirs with `noautocmd` (no WinNew/WinClosed to
-- re-snapshot on), so they'd make the window set look changed when it isn't.
local function split_wins()
    return vim.tbl_filter(function(win)
        return vim.api.nvim_win_get_config(win).relative == ""
    end, vim.api.nvim_tabpage_list_wins(0))
end

local function win_ids()
    return table.concat(split_wins(), ",")
end

local function snapshot()
    -- Window resizing is off-limits while the cmdline window is open.
    if vim.fn.getcmdwintype() ~= "" then
        return
    end
    local splits = {}
    for _, win in ipairs(split_wins()) do
        local pos = vim.api.nvim_win_get_position(win)
        splits[#splits + 1] = {
            win = win,
            row = pos[1],
            col = pos[2],
            width = vim.api.nvim_win_get_width(win),
            height = vim.api.nvim_win_get_height(win),
        }
    end
    saved[vim.api.nvim_get_current_tabpage()] = {
        cols = vim.o.columns,
        rows = vim.o.lines - vim.o.cmdheight,
        wins = win_ids(),
        splits = splits,
    }
end

-- Scaling each window's size independently drifts, because the one-cell
-- separators (and statuslines) between windows don't scale. Scale the
-- separator positions instead: windows that shared an edge still share it
-- afterwards, every separator stays one cell wide, and a factor of 1 gives
-- back the snapshot exactly.
local function restore()
    local snap = saved[vim.api.nvim_get_current_tabpage()]
    if not snap or vim.fn.getcmdwintype() ~= "" then
        return
    end
    -- The recorded geometry only means anything for the window set it came from.
    if snap.wins ~= win_ids() then
        return
    end

    local fx = vim.o.columns / snap.cols
    local fy = (vim.o.lines - vim.o.cmdheight) / snap.rows
    local function at(pos, f)
        return math.floor(pos * f + 0.5)
    end

    -- Resizing one window can nudge a neighbour that was already set; a
    -- second pass settles it (winrestcmd() replays its commands twice too).
    for _ = 1, 2 do
        for _, s in ipairs(snap.splits) do
            local left = s.col == 0 and 0 or at(s.col - 1, fx) + 1
            local top = s.row == 0 and 0 or at(s.row - 1, fy) + 1
            vim.api.nvim_win_set_width(s.win, math.max(1, at(s.col + s.width, fx) - left))
            vim.api.nvim_win_set_height(s.win, math.max(1, at(s.row + s.height, fy) - top))
        end
    end
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
