require("helpers.keymaps")
-- Set up vim-dan
--
require("dbee").setup( --[[optional config]])

SetKeyMap("<A-d><A-b>", "<cmd>lua require('dbee').toggle()<CR>")
