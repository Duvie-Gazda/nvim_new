require("helpers.keymaps")
-- Set up vim-dadbod-ui
vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui" -- Persistent database connections

-- Configure nvim-cmp to work with dadbod
local cmp = require("cmp")
cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    sources = cmp.config.sources({
        { name = "vim-dadbod-completion" },
    }, {
        { name = "buffer" },
    }),
})

SetKeyMap("<A-d><A-b>", ":DBUI")
