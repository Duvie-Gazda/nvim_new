vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.have_nerd_font = false
vim.opt.number = true
vim.opt.mouse = "a"
vim.opt.showmode = false

vim.opt.laststatus = 0
vim.opt.showmode = false
vim.opt.ruler = false
vim.schedule(function()
    vim.opt.clipboard = "unnamedplus"
end)
vim.opt.undofile = true
vim.opt.breakindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10

vim.opt.tabstop = 4    -- Width of a tab character
vim.opt.shiftwidth = 4 -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true


require("autoclose").setup()
require("bufferline").setup({})
require("helpers.keymaps")
for i = 1, 9 do
    vim.api.nvim_set_keymap(
        "n",
        "<A-" .. i .. ">",
        "<Cmd>BufferLineGoToBuffer " .. i .. "<CR>",
        { noremap = true, silent = true }
    )
end

vim.keymap.set("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
SetKeyMap("<A-f>", ":let @+ = expand('%:p')", {})
-- Configure diagnostics
vim.diagnostic.config({
    virtual_text = false,     -- Disable inline error/warning text
    signs = false,            -- Remove signs from the left panel
    underline = true,         -- Enable underlining for errors/warnings
    update_in_insert = false, -- Do not show diagnostics while typing
    severity_sort = true,     -- Sort diagnostics by severity
})

-- Keymap for showing diagnostics or info
vim.keymap.set("n", "<M-a><M-a>", function()
    local opts = { focusable = false, scope = "cursor" }
    local diagnostics = vim.diagnostic.get(0, opts) -- Get diagnostics for the current cursor position

    if #diagnostics > 0 then
        vim.diagnostic.open_float(nil, opts) -- Show diagnostics in a floating window
    else
        vim.lsp.buf.hover()                  -- Show hover info if no diagnostics are present
    end
end, { desc = "Show error/warning or hover info" })
