return {
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("toggleterm").setup({
                direction = "float",
                float_opts = { border = "curved", winblend = 3 },
            })
            vim.keymap.set({ "n", "t" }, "<leader>k", "<cmd>ToggleTerm<CR>", { noremap = true, silent = true })
        end,
    },
}
