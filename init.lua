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
        -- { "nvim-treesitter/nvim-treesitter-context", },
        -- },
        {
            "nvim-treesitter/nvim-treesitter",
            build = ":TSUpdate",
            main = "nvim-treesitter.configs", -- Sets main module to use for opts
            config = function()
                require("nvim-treesitter.configs").setup({
                    highlight = { enable = true }, -- Enable syntax highlighting
                    rainbow = {
                        enable = true,
                        extended_mode = true,  -- Also colorize non-bracket delimiters
                        max_file_lines = 1000, -- Limit to smaller files
                    },
                })
            end,
            -- {
            --     "p00f/nvim-ts-rainbow",
            --     dependencies = { "nvim-treesitter/nvim-treesitter" },
            -- },
            -- opts = {
            --     ensure_installed = {
            --         "bash",
            --         "c",
            --         "diff",
            --         "html",
            --         "lua",
            --         "luadoc",
            --         "markdown",
            --         "markdown_inline",
            --         "query",
            --         "vim",
            --         "vimdoc",
            --     },
            --     auto_install = true,
            --     highlight = {
            --         enable = true,
            --         additional_vim_regex_highlighting = { "ruby" },
            --     },
            --     indent = { enable = true, disable = { "ruby" } },
            --     rainbow = {
            --         enable = true,
            --         extended_mode = true,
            --         max_file_lines = 1000,
            --     },
            --     autotag = {
            --         enable = true,
            --     },
            -- },
        },
        {
            "windwp/nvim-ts-autotag",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("nvim-ts-autotag").setup({
                    -- Enable auto renaming for HTML tags
                    filetypes = { "html", "xml", "tsx", "jsx", "hbs", "handlebars" },
                })
            end,
        },
        {
            "andymass/vim-matchup",
            config = function()
                vim.g.matchup_matchparen_enabled = 1
                vim.g.matchup_matchparen_offscreen = {}
            end,
        },
        {
            "numToStr/Comment.nvim",
        },
        { 'nvim-telescope/telescope-ui-select.nvim' },
        { -- Autoformat
            "stevearc/conform.nvim",
            event = { "BufWritePre" },
            cmd = { "ConformInfo" },
            keys = {
                {
                    "<leader>f",
                    function()
                        require("conform").format({ async = true, lsp_format = "fallback" })
                    end,
                    mode = "",
                    desc = "[F]ormat buffer",
                },
            },
            opts = {
                notify_on_error = false,
                format_on_save = function(bufnr)
                    local disable_filetypes = { c = true, cpp = true }
                    local lsp_format_opt
                    if disable_filetypes[vim.bo[bufnr].filetype] then
                        lsp_format_opt = "never"
                    else
                        lsp_format_opt = "fallback"
                    end
                    return {
                        timeout_ms = 500,
                        lsp_format = lsp_format_opt,
                    }
                end,
                formatters_by_ft = {
                    lua = { "stylua" },
                },
            },
        },
        {
            'windwp/nvim-ts-autotag',
            requires = { 'nvim-treesitter/nvim-treesitter' },
        },
        {
            "HiPhish/rainbow-delimiters.nvim",
            config = function()
                local rainbow_delimiters = require('rainbow-delimiters')
                vim.g.rainbow_delimiters = {
                    strategy = {
                        [''] = rainbow_delimiters.strategy['global'],
                        html = rainbow_delimiters.strategy.disabled, -- Disable for HTML
                    },
                    query = {
                        [''] = 'rainbow-delimiters',
                        lua = 'rainbow-blocks', -- Example for Lua
                    },
                    highlight = {
                        'RainbowDelimiterRed',
                        'RainbowDelimiterYellow',
                        'RainbowDelimiterBlue',
                        'RainbowDelimiterOrange',
                        'RainbowDelimiterGreen',
                        'RainbowDelimiterViolet',
                        'RainbowDelimiterCyan',
                    },
                }
            end
        },
        { 'f-person/git-blame.nvim' },
        { 'nvim-treesitter/nvim-treesitter-context', },
    },
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
    ui = { border = "rounded" }
})

require("config/init")
require('treesitter-context').setup({
    mode = 'topline',
    line_numbers = true,
    max_lines = 8,
})
