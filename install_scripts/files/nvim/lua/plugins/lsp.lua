return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "clangd" },
                automatic_installation = true,
            })

            local on_attach = function(_, bufnr)
                local opts = { buffer = bufnr, silent = true }
                local map  = vim.keymap.set
                -- mirrors YCM mappings
                map("n", "<leader>]", vim.lsp.buf.definition,    opts)
                map("n", "<leader>p", vim.lsp.buf.references,    opts)
                map("n", "<leader>t", vim.lsp.buf.hover,         opts)
                map("n", "<leader>f", vim.lsp.buf.code_action,   opts)
                map("n", "<leader>r", vim.lsp.buf.rename,        opts)
                -- header/source switch (mirrors <leader>o → GoToAlternateFile)
                map("n", "<leader>o", ":ClangdSwitchSourceHeader<CR>", opts)
            end

            require("lspconfig").clangd.setup({
                on_attach = on_attach,
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--function-arg-placeholders",
                    "--compile-commands-dir=build-Debug",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
            })
        end,
    },
}
