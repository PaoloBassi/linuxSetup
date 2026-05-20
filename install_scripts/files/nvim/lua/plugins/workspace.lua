return {
    -- Session management (replaces vim-workspace) -----------------------------
    {
        "folke/persistence.nvim",
        event = "BufReadPre",
        config = function()
            require("persistence").setup({
                dir     = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
                options = { "buffers", "curdir", "tabpages", "winsize" },
            })
            -- restore session on startup only when no file args (mirrors
            -- workspace_session_disable_on_args = 1)
            if vim.fn.argc() == 0 then
                require("persistence").load()
            end
        end,
    },

    -- Slint UI language (unchanged, works as vimscript plugin in neovim) ------
    { "slint-ui/vim-slint" },
}
