return {
    -- Gutter signs and hunk operations (replaces vim-gitgutter) ---------------
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add          = { text = "│" },
                    change       = { text = "│" },
                    delete       = { text = "_" },
                    topdelete    = { text = "‾" },
                    changedelete = { text = "~" },
                },
                on_attach = function(bufnr)
                    local gs   = package.loaded.gitsigns
                    local opts = { buffer = bufnr }
                    vim.keymap.set("n", "]c",         gs.next_hunk,  opts)
                    vim.keymap.set("n", "[c",         gs.prev_hunk,  opts)
                    vim.keymap.set("n", "<leader>hs", gs.stage_hunk, opts)
                    vim.keymap.set("n", "<leader>hr", gs.reset_hunk, opts)
                    vim.keymap.set("n", "<leader>hp", gs.preview_hunk, opts)
                    vim.keymap.set("n", "<leader>hb", function()
                        gs.blame_line({ full = true })
                    end, opts)
                end,
            })
        end,
    },

    -- Git commands in vim (unchanged, works natively in neovim) ---------------
    { "tpope/vim-fugitive" },

    -- Git log for selected code -----------------------------------------------
    {
        "niuiic/git-log.nvim",
        dependencies = { "niuiic/omega.nvim" },
        keys = {
            {
                "<leader>l",
                function() require("git-log").check_log() end,
                mode = "v",
                desc = "Git log for selection",
            },
        },
    },

    -- Full-screen git diff and file history viewer ---------------------------
    {
        "sindrets/diffview.nvim",
        keys = {
            { "<leader>gd", "<cmd>DiffviewOpen<CR>",        desc = "Open diffview" },
            { "<leader>gh", "<cmd>DiffviewFileHistory<CR>", desc = "File history" },
            { "<leader>gD", "<cmd>DiffviewClose<CR>",       desc = "Close diffview" },
        },
    },
}
