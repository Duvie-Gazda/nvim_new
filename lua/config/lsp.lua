-- vim.cmd([[
--   augroup CocAutoStart
--     " autocmd!
--     " autocmd FileType javascript,typescript,javascriptreact,typescriptreact,svelte CocStart
--     autocmd FileType sql,mysql,plsql CocStop
--     " autocmd BufEnter * if !index(['javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte'], &filetype) | silent! CocStop | endif
--   augroup END
-- ]])
--
-- vim.cmd([[
--   let g:coc_preferences_formatOnSaveFiletypes = ['javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte']
-- ]])
--

local cmp = require("cmp")

cmp.setup({
    snippet = {
        expand = function(args)
            require("luasnip").lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        ["<M-l>"] = cmp.mapping.confirm({ select = true }),
        ["<M-j>"] = cmp.mapping.select_next_item(),
        ["<M-k>"] = cmp.mapping.select_prev_item(),
        ["<C-Space>"] = cmp.mapping.complete(),
    }),
    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "buffer" },
        { name = "path" },
        { name = "cmp-dbee" }
    }),
})
-- require("cmp-dbee").setup({})

-- Filetype-specific setup for SQL
cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
    sources = cmp.config.sources({
        { name = "vim-dadbod-completion" },
        -- { name = "cmp-dbee" },
        -- { name = "nvim_lsp" },
        { name = "buffer" },
    }),
})


local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
    function(server_name) -- Default handler
        lspconfig[server_name].setup({
            capabilities = capabilities,
        })
    end,
    -- Example for custom server config
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
                Lua = {
                    diagnostics = { globals = { "vim" } },
                },
            },
        })
    end,
})

require("mason").setup()

require("mason-lspconfig").setup({
    ensure_installed = { "pyright", "rust_analyzer", "lua_ls" }, -- Add servers here
    automatic_installation = true,
})

require("mason-lspconfig").setup_handlers({
    function(server_name)
        lspconfig[server_name].setup({
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                -- Enable auto-format on save if the server supports it
                if client.server_capabilities.documentFormattingProvider then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end,
        })
    end,
})

-- new
-- Telescope Mappings
local builtin = require("telescope.builtin")
local filetype = vim.bo.filetype

local function use_coc()
    local coc_filetypes = { javascript = true, typescript = true, svelte = true }
    local filetype = vim.bo.filetype
    return coc_filetypes[filetype] == true
end

vim.keymap.set("n", "<M-s><M-r>", function()
    if use_coc() then
        vim.cmd("Telescope coc references")
        print("a")
    else
        print("b")
        builtin.lsp_references()
    end
    -- if filetype == "svelte" or filetype == "javascript" then
    -- else
    --vim.cmd("telescope coc references")
    --end
end, { desc = "Go to references" })

vim.keymap.set("n", "<M-s><M-d>", function()
    -- if use_coc() then
    --     vim.cmd("Telescope coc definitions")
    -- else
    builtin.lsp_definitions()
    -- end
end, { desc = "Go to definition" })



-- Show info or error (Alt-a Alt-a)
-- vim.keymap.set("n", "<M-a><M-a>", function()
--     if vim.fn.exists(":CocCommand") == 2 then
--         vim.cmd("CocCommand workspace.showDiagnostics")
--     else
--         vim.lsp.buf.hover()
--     end
-- end, { desc = "Show info or error" })

-- Go to next error (Alt-a Alt-e)
vim.keymap.set("n", "<M-a><M-e>", function()
    -- if use_coc() then
    --     vim.cmd("CocCommand diagnostic.next")
    -- else
    vim.diagnostic.goto_next()
    -- end
end, { desc = "Go to next error" })

-- Project diagnostics (Alt-Shift-e)
vim.keymap.set("n", "<M-E>", function()
    builtin.diagnostics()
end, { desc = "Show project diagnostics" })

-- Rename (Alt-a Alt-r)
vim.keymap.set("n", "<M-a><M-r>", function()
    -- if use_coc() then
    --     vim.cmd("CocCommand workspace.rename")
    -- else
    vim.lsp.buf.rename()
    -- end
end, { desc = "Rename symbol" })

-- Go to symbol in file (Alt-s Alt-s)
vim.keymap.set("n", "<M-s><M-s>", function()
    builtin.lsp_document_symbols()
end, { desc = "Go to symbol in file" })

-- Go to symbol in project (Alt-Shift-s Alt-Shift-s)
vim.keymap.set("n", "<M-S><M-S>", function()
    builtin.lsp_dynamic_workspace_symbols()
end, { desc = "Go to symbol in project" })


vim.keymap.set("n", "<M-A><M-A>", function()
    local virtual_text_enabled = vim.diagnostic.config().virtual_text
    vim.diagnostic.config({
        virtual_text = not virtual_text_enabled, -- Toggle the current state
    })

    vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = not virtual_text_enabled })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { underline = not virtual_text_enabled })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { underline = not virtual_text_enabled })
    vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { underline = not virtual_text_enabled })

    print("Inline errors " .. (not virtual_text_enabled and "enabled" or "disabled"))
end, { desc = "Toggle inline errors" })

-- vim.keymap.set("n", "<M-s><M-g>", "Telescope live_grep", {})


require("Comment").setup()
vim.keymap.set(
    "n",
    "<C-_>",
    "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "v",
    "<C-_>",
    "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { noremap = true, silent = true }
)
vim.keymap.set(
    "i",
    "<C-_>",
    "<esc><cmd>lua require('Comment.api').toggle.linewise()<CR>",
    { noremap = true, silent = true }
)

require('nvim-ts-autotag').setup({
    opts = {
        enable_close = true,          -- Auto close tags
        enable_rename = true,         -- Auto rename pairs of tags
        enable_close_on_slash = false -- Auto close on trailing </
    },
    per_filetype = {
        ["svelte"] = {
            enable_close = false,
            enable_rename = false,
        }
    }
})


SetKeyMapFunc("<A-a><A-a>", function()
    vim.lsp.buf.signature_help()
end, { desc = "Show function signature (LSP)" })

SetKeyMapFunc("<A-a><A-s>", function()
    -- vim.lsp.buf.hover()
    vim.lsp.buf.signature_help()
end, { desc = "Show function signature (LSP)" })


require('nvim-ts-autotag').setup()

-- Copilot keymap configuration
vim.keymap.set('i', '<A-Right>', function()
    return vim.fn['copilot#Accept']()
end, { noremap = true, expr = true, silent = true, desc = "Trigger Copilot completion" })
