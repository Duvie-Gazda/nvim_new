require("oil").setup({
	options = {
		columns = { "icon", "size" },
	},
	keymaps = {
		["<A-l>"] = "actions.select", -- Alt+l to select a file
		["<A-a>"] = "actions.preview",
		["<A-h>"] = "actions.parent",
		["<C-s>"] = function() -- Ct l+s to save without confirming
			require("oil").save({ confirm = false }) -- Save action without confirmation
		end,
         ['yp'] = {
                    desc = 'Copy filepath to system clipboard',
                    callback = function ()
                        require('oil.actions').copy_entry_path.callback()
                        vim.fn.setreg("+", vim.fn.getreg(vim.v.register))
                    end,
                },
	},
})

vim.keymap.set("n", "<A-e><A-f>", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })

