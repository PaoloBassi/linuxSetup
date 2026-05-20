return {
    {
        "catppuccin/nvim",
        name     = "catppuccin",
        priority = 1000,
        config = function()
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    nvimtree    = true,
                    telescope   = { enabled = true },
                    treesitter  = true,
                    trouble     = true,
                    gitsigns    = true,
                    which_key   = true,
                    aerial      = true,
                    cmp         = true,
                    hop         = true,
                    indent_blankline = { enabled = true },
                    native_lsp  = {
                        enabled = true,
                        underlines = {
                            errors      = { "underline" },
                            hints       = { "underline" },
                            warnings    = { "underline" },
                            information = { "underline" },
                        },
                    },
                    illuminate  = { enabled = true },
                    lualine     = {},   -- true would crash utils/lualine.lua:55 (tries overrides.all on boolean)
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
            -- mirror vimrc custom highlights
            vim.api.nvim_set_hl(0, "Search", { bold = true, italic = true, underline = true, fg = "lightblue" })
            vim.api.nvim_set_hl(0, "String", { fg = "#87afff" })
            -- diagnostic line background tints (catppuccin-mocha base: #1e1e2e)
            vim.api.nvim_set_hl(0, "DiagnosticLineError", { bg = "#4a1e28" })
            vim.api.nvim_set_hl(0, "DiagnosticLineWarn",  { bg = "#4a3816" })
            vim.api.nvim_set_hl(0, "DiagnosticLineInfo",  { bg = "#1e304a" })
            vim.api.nvim_set_hl(0, "DiagnosticLineHint",  { bg = "#1e4a30" })
        end,
    },
    -- alternative colorschemes (kept as in current setup)
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "fcpg/vim-fahrenheit",      lazy = true },
}
