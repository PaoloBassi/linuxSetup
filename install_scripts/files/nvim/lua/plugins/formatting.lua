return {
    {
        "stevearc/conform.nvim",
        event = "VeryLazy",
        config = function()
            require("conform").setup({
                formatters_by_ft = {
                    c   = { "clang_format" },
                    cpp = { "clang_format" },
                    lua = { "stylua" },
                },
            })
            vim.keymap.set({ "n", "v" }, "<leader>cf", function()
                require("conform").format({ async = true, lsp_format = "fallback" })
            end, { desc = "Format buffer" })
        end,
    },
}
