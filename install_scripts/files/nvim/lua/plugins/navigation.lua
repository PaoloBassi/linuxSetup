return {
    -- Motion (replaces vim-easymotion) ----------------------------------------
    {
        "smoka7/hop.nvim",
        version = "*",
        config = function()
            local hop = require("hop")
            hop.setup({ keys = "etovxqpdygfblzhckisuran" })

            local map = vim.keymap.set
            -- mirrors easymotion-overwin-f2
            map({ "n", "v" }, "f", function() hop.hint_char2() end)
            -- mirrors easymotion-bd-jk / overwin-line
            map({ "n", "v" }, "<Leader>j", function() hop.hint_lines() end)
            -- / kept as native search (unlike easymotion override in vimrc)
            -- use <leader>/ for hop pattern search
            map("n", "<leader>/", function() hop.hint_patterns() end)
        end,
    },

    -- Symbol outline (replaces tagbar, uses LSP + treesitter) ----------------
    {
        "stevearc/aerial.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("aerial").setup({
                layout = {
                    max_width        = { 40, 0.2 },
                    min_width        = 20,
                    default_direction = "right",
                },
                -- jump between symbols with { }
                on_attach = function(bufnr)
                    vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
                    vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
                end,
                -- show in lualine (already wired via lualine section)
                show_guides = true,
            })
        end,
    },

    -- Ctags fallback (unchanged, still useful for projects without LSP) -------
    {
        "ludovicchabant/vim-gutentags",
        config = function()
            vim.g.gutentags_add_default_project_roots = 0
            vim.g.gutentags_project_root              = { ".git" }
            vim.g.gutentags_cache_dir                 = vim.fn.expand("~/.cache/vim/ctags/")
            vim.g.gutentags_generate_on_new           = 1
            vim.g.gutentags_generate_on_missing       = 1
            vim.g.gutentags_generate_on_write         = 1
            vim.g.gutentags_generate_on_empty_buffer  = 0
            vim.g.gutentags_ctags_extra_args          = { "--tag-relative=yes", "--fields=+ailmnS" }
        end,
    },
}
