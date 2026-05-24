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
            -- blink.cmp handles auto_brackets natively
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

    -- Visual glow on undo/redo/yank/paste/search/comment/cursor (new) ----------
    {
        "y3owk1n/undo-glow.nvim",
        event = "VeryLazy",
        opts = {
            animation = {
                enabled      = true,
                duration     = 300,
                animation_type = "zoom",
                window_scoped = true,
            },
            -- dark muted variants of Catppuccin Mocha accent colors
            highlights = {
                undo    = { hl_color = { bg = "#693232" } },
                redo    = { hl_color = { bg = "#2F4640" } },
                yank    = { hl_color = { bg = "#7A683A" } },
                paste   = { hl_color = { bg = "#325B5B" } },
                search  = { hl_color = { bg = "#5C475C" } },
                comment = { hl_color = { bg = "#7A5A3D" } },
                cursor  = { hl_color = { bg = "#793D54" } },
            },
            priority = 2048 * 3,
        },
        keys = {
            { "u",     function() require("undo-glow").undo() end,        mode = "n", noremap = true },
            { "<C-r>", function() require("undo-glow").redo() end,        mode = "n", noremap = true },
            { "p",     function() require("undo-glow").paste_below() end, mode = "n", noremap = true },
            { "P",     function() require("undo-glow").paste_above() end, mode = "n", noremap = true },
            {
                "n",
                function() require("undo-glow").search_next({ animation = { animation_type = "zoom" } }) end,
                mode = "n", desc = "Search next with highlight", noremap = true,
            },
            {
                "N",
                function() require("undo-glow").search_prev({ animation = { animation_type = "zoom" } }) end,
                mode = "n", desc = "Search prev with highlight", noremap = true,
            },
            {
                "*",
                function() require("undo-glow").search_star({ animation = { animation_type = "zoom" } }) end,
                mode = "n", desc = "Search star with highlight", noremap = true,
            },
            {
                "#",
                function() require("undo-glow").search_hash({ animation = { animation_type = "zoom" } }) end,
                mode = "n", desc = "Search hash with highlight", noremap = true,
            },
            -- comment glow (wraps Comment.nvim's gc/gcc operators)
            {
                "gc",
                function()
                    local pos = vim.fn.getpos(".")
                    vim.schedule(function() vim.fn.setpos(".", pos) end)
                    return require("undo-glow").comment()
                end,
                mode = { "n", "x" }, expr = true, noremap = true,
            },
            {
                "gc",
                function() require("undo-glow").comment_textobject() end,
                mode = "o", noremap = true,
            },
            {
                "gcc",
                function() return require("undo-glow").comment_line() end,
                mode = "n", expr = true, noremap = true,
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("TextYankPost", {
                callback = function() require("undo-glow").yank() end,
            })
            -- beacon-like cursor highlight on significant jumps
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = function()
                    require("undo-glow").cursor_moved({ animation = { animation_type = "slide" } })
                end,
            })
            -- highlight cursor when re-focusing (tmux pane switch included)
            vim.api.nvim_create_autocmd("FocusGained", {
                callback = function()
                    local utils = require("undo-glow.utils")
                    local opts  = utils.merge_command_opts("UgCursor", { animation = { animation_type = "slide" } })
                    local pos   = utils.get_current_cursor_row()
                    require("undo-glow").highlight_region(vim.tbl_extend("force", opts, {
                        s_row = pos.s_row, s_col = pos.s_col,
                        e_row = pos.e_row, e_col = pos.e_col,
                        force_edge = true,
                    }))
                end,
            })
            -- highlight match when exiting / search cmdline
            vim.api.nvim_create_autocmd("CmdlineLeave", {
                callback = function()
                    require("undo-glow").search_cmd({ animation = { animation_type = "fade" } })
                end,
            })
        end,
    },
}
