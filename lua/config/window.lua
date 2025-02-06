require("helpers.keymaps")

SetKeyMap("<C-s>", ":w")
SetKeyMap("<A-w>", ":bd")

local is_maximized = false
local original_height = vim.o.lines
local original_width = vim.o.columns

vim.keymap.set("n", "<A-d><A-s>", function()
    if is_maximized then
        -- Restore original dimensions
        vim.cmd("resize " .. original_height)
        vim.cmd("vertical resize " .. original_width)
        is_maximized = false
    else
        -- Maximize the current window
        original_height = vim.fn.winheight(0)
        original_width = vim.fn.winwidth(0)
        vim.cmd("resize | vertical resize")
        is_maximized = true
    end
end, { desc = "Toggle maximize current window" })
