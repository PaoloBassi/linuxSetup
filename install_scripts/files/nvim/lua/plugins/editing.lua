return {
    -- Surround (replaces vim-surround with native lua version) -----------------
    {
        "kylechui/nvim-surround",
        event  = "VeryLazy",
        config = function()
            require("nvim-surround").setup()
        end,
    },

    -- Comments (replaces vim-commentary, treesitter-aware) --------------------
    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end,
    },

    -- Auto pairs (new) --------------------------------------------------------
    {
        "windwp/nvim-autopairs",
        event  = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup({ check_ts = true })
            -- integrate with nvim-cmp
            local ok, cmp = pcall(require, "cmp")
            if ok then
                local cmp_autopairs = require("nvim-autopairs.completion.cmp")
                cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
            end
        end,
    },

    -- Better % for #ifdef/#endif and C++ templates (new) ----------------------
    {
        "andymass/vim-matchup",
        config = function()
            vim.g.matchup_matchparen_offscreen = { method = "popup" }
        end,
    },

    -- Make . repeat work with surround, commentary, etc. (new) ----------------
    { "tpope/vim-repeat" },

    -- Bracket pairs for navigation/operations (new) ---------------------------
    { "tpope/vim-unimpaired" },

    -- Unix file commands: :Rename, :Delete, :Move, :SudoWrite (unchanged) ----
    { "tpope/vim-eunuch" },

    -- EditorConfig: built-in in nvim 0.9+, plugin only for older versions -----
    { "editorconfig/editorconfig-vim", cond = vim.fn.has("nvim-0.9") == 0 },
}
