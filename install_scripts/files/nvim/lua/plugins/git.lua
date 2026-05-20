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
                    vim.keymap.set("n", "]h",         gs.next_hunk,  opts)
                    vim.keymap.set("n", "[h",         gs.prev_hunk,  opts)
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
}
