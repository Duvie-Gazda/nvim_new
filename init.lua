local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("lazy").setup({
    spec = {
        {
            "github/copilot.vim",
        },
        {
            "stevearc/oil.nvim",
            dependencies = { { "echasnovski/mini.icons", opts = {} } },
        },
        { "m4xshen/autoclose.nvim", },
        { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },

        -- Coc.nvim for Node.js files
        {
            "neoclide/coc.nvim",
            ft = { "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte" },
            branch = "release",
        },

        -- nvim-cmp for LSP integration
        {
            "hrsh7th/nvim-cmp",
            dependencies = {
                "hrsh7th/cmp-nvim-lsp",
                "hrsh7th/cmp-buffer",
                "hrsh7th/cmp-path",
                "hrsh7th/cmp-cmdline",
                "L3MON4D3/LuaSnip",
            },
        },

        -- Mason.nvim for managing LSP servers
        {
            "williamboman/mason.nvim",
        },

        -- Mason-LSPConfig bridge
        {
            "williamboman/mason-lspconfig.nvim",
            dependencies = { "neovim/nvim-lspconfig" },
        },

        -- LSPConfig for LSP server integration
        {
            "neovim/nvim-lspconfig",
        },



        {
            "nvim-telescope/telescope.nvim",
            dependencies = {
                { "nvim-lua/plenary.nvim" },                                    -- Required dependency
                { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, -- For native FZF support
                { "fannheyward/telescope-coc.nvim" },                           -- Telescope Coc integration
            },
        },
        {
            "tpope/vim-dadbod",
            dependencies = {
                "kristijanhusak/vim-dadbod-ui",
                "kristijanhusak/vim-dadbod-completion",
            },

        },
        {
            "olimorris/onedarkpro.nvim",
            config = function()
                priority = 1000 -- Ensure it loads first
                vim.cmd("colorscheme onedark")
            end,
        },

        -- },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            main = "nvim-treesitter.configs", -- Sets main module to use for opts
            opts = {
                ensure_installed = {
                    "bash",
                    "c",
                    "diff",
                    "html",
                    "lua",
                    "luadoc",
                    "markdown",
                    "markdown_inline",
                    "query",
                    "vim",
                    "vimdoc",
                },
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = { "ruby" },
                },
                indent = { enable = true, disable = { "ruby" } },
            },
        },
        {
            "numToStr/Comment.nvim",
        },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
    ui = { border = "rounded" }
})

require("config/init")
