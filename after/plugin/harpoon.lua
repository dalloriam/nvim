local harpoon = require('harpoon')
local fterm = require('FTerm')
local dap = require('dap')


local function centered_xy(width_pct, height_pct)
  -- width_pct/height_pct are strings like "90%"
  local w = tonumber(width_pct:match("^(%d+)%s*%%$"))
  local h = tonumber(height_pct:match("^(%d+)%s*%%$"))
  if not w or not h then
    return nil, nil
  end
  return string.format("%d%%", math.floor((100 - w) / 2)),
         string.format("%d%%", math.floor((100 - h) / 2))
end

harpoon.setup({
  settings = { save_on_toggle = true },
  cmd = {
    select = function(list_item, list, option)
      local cmd = list_item.value

      if not vim.env.ZELLIJ_PANE_ID then
        return fterm.scratch({ cmd = cmd, auto_close = true })
      end

      local cols = vim.o.columns
      local float = cols < 200

      local args = { "run", "--name", cmd }

      if false then
        local width, height = "90%", "80%"
        local x, y = centered_xy(width, height)

        vim.list_extend(args, { "--floating", "--width", width, "--height", height })
        if x and y then
          vim.list_extend(args, { "--x", x, "--y", y })
        end
      else
        vim.list_extend(args, { "--direction", "right" })
      end

      vim.list_extend(args, { "--", "sh", "-lc", cmd })
      vim.system(vim.list_extend({ "zellij" }, args), { detach = true })
    end,
  },
})


vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    { desc = "Open harpoon window" })

vim.keymap.set("n", "<leader>u", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<leader>i", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<leader>o", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<leader>p", function() harpoon:list():select(4) end)

vim.keymap.set("n", "<C-d>", function() harpoon.ui:toggle_quick_menu(harpoon:list("cmd")) end)
vim.keymap.set("n", "<leader>n", function() harpoon:list("cmd"):select(1) end)
vim.keymap.set("n", "<leader>m", function() harpoon:list("cmd"):select(2) end)
vim.keymap.set("n", "<leader>,", function() harpoon:list("cmd"):select(3) end)
vim.keymap.set("n", "<leader>.", function() harpoon:list("cmd"):select(4) end)
