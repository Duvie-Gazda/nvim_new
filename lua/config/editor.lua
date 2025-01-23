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
SetKeyMap("<C-z>", ":u", {})
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

-- Pair
--require('nvim-treesitter.configs').setup()
-- local rainbow_delimiters = require('rainbow-delimiters')
-- vim.g.rainbow_delimiters = {
--     strategy = {
--         [''] = rainbow_delimiters.strategy['global'],
--         html = rainbow_delimiters.strategy['disabled'], -- Disable for HTML
--     },
--     query = {
--         [''] = 'rainbow-delimiters',
--         lua = 'rainbow-blocks', -- Example for Lua
--     },
--     highlight = {
--         'RainbowDelimiterYellow',
--         'RainbowDelimiterBlue',
--         'RainbowDelimiterPurple',
--         'RainbowDelimiterCyan',
--     }
-- }
--
vim.cmd([[
  highlight MatchParen guibg=#3b4252 guifg=NONE ctermbg=8 ctermfg=NONE
]])

vim.cmd([[
  highlight rainbowcol1 guibg=#282c34 guifg=NONE
  highlight rainbowcol2 guibg=#3b4252 guifg=NONE
  highlight rainbowcol3 guibg=#434c5e guifg=NONE
  highlight rainbowcol4 guibg=#4c566a guifg=NONE
  highlight rainbowcol5 guibg=#5e81ac guifg=NONE
  highlight rainbowcol6 guibg=#8fbcbb guifg=NONE
  highlight rainbowcol7 guibg=#88c0d0 guifg=NONE
]])

require('gitblame').setup {
    --Note how the `gitblame_` prefix is omitted in `setup`
    -- enabled = false,
    enabled = true,                                   -- if you want to enable the plugin
    -- message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    message_template = "<author>: <date>, <summary>", -- template for the blame message, check the Message template section for more options
    date_format = "%r",                               -- template for the date, check Date format section for more options
    virtual_text_column = 1,                          -- virtual text start column, check Start virtual text at column section for more options
}

-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-S-[>', "<Esc>:execute 'normal! <<'<CR>i", { noremap = true, silent = true })

-- Add tab mapping (Alt-Shift
-- vim.keymap.set({ 'n', 'i', 'v' }, '<C-S-]>', "<Esc>:execute 'normal! >><'<CR>i", { noremap = true, silent = true })
-- SetKeyMap("<M-{>", ":execute 'normal! <<'", {})
-- SetKeyMap("<M-}>", ":execute 'normal! >>'", {})
--
-- -- Remove tab mapping (Alt-Shift-[)
vim.keymap.set({ 'n', 'i', 'v' }, '<M-{>', function()
    if vim.fn.mode() == 'v' then
        vim.cmd('normal! <gv')
    else
        vim.cmd('normal! <<')
    end
end, { noremap = true, silent = true })

-- Add tab mapping (Alt-Shift-])
vim.keymap.set({ 'n', 'i', 'v' }, '<M-}>', function()
    if vim.fn.mode() == 'v' then
        vim.cmd('normal! >gv')
    else
        vim.cmd('normal! >>')
    end
end, { noremap = true, silent = true })
