require("helpers.keymaps")
SetKeyMap("<A-p>", ":Telescope find_files")

require("telescope").setup({
    defaults = {
        file_ignore_patterns = {
            "%.classpath",
            "%.factorypath",
            "%.project",
            "%.settings",
            "%.git/objects/.*",
            "%.git/subtree-cache/.*",
            "node_modules/.*",
            "svelte-kit/.*",
            "build/*",
            -- "target/*",
            -- "mod/*",
        },
        mappings = {
            i = {
                ["<A-j>"] = require("telescope.actions").move_selection_next,
                ["<A-k>"] = require("telescope.actions").move_selection_previous,
                -- ["<C-c>"] = "<Esc>",

                ["<A-l>"] = require("telescope.actions").select_default,
                ["<A-S-l>"] = require("telescope.actions").select_horizontal,
                ["<C-w>"] = function()
                    vim.api.nvim_input("<c-s-w>")
                end,
            },
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
        },
    },
})

pcall(require("telescope").load_extension, "fzf")
pcall(require("telescope").load_extension, "ui-select")
pcall(require("telescope").load_extension, "coc")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[s]earch [h]elp" })
vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[s]earch [k]eymaps" })
vim.keymap.set("n", "<a-p>", builtin.find_files, { desc = "[s]earch [f]iles" })
vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[s]earch [s]elect telescope" })
vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[s]earch current [w]ord" })
vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[s]earch by [g]rep" })
vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[s]earch [d]iagnostics" })
vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[s]earch [r]esume" })
vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[s]earch recent files ("." for repeat)' })
vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] find existing buffers" })

vim.keymap.set("n", "<leader>/", function()
    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = "[/] fuzzily search in current buffer" })

vim.keymap.set("n", "<leader>s/", function()
    builtin.live_grep({
        grep_open_files = true,
        prompt_title = "live grep in open files",
    })
end, { desc = "[s]earch [/] in open files" })

vim.keymap.set("n", "<leader>sn", function()
    builtin.find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "[s]earch [n]eovim files" })
SetKeyMap("<A-g><A-s>", ":Telescope git_status", {})
SetKeyMap("<A-g><A-c>", ":Telescope git_commits", {})
SetKeyMap("<A-g><A-b>", ":Telescope git_branches", {})
SetKeyMap("<A-g><A-r>", ":Telescope git_bcommits", {})
SetKeyMap("<A-g><A-f>", ":Telescope git_files", {})
SetKeyMap("<A-g><A-t>", ":Telescope git_stash", {})
