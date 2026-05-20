return {
    {
        "nvim-telescope/telescope.nvim",
        branch       = "0.1.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            local telescope = require("telescope")
            local actions   = require("telescope.actions")

            telescope.setup({
                defaults = {
                    layout_strategy = "vertical",
                    layout_config   = { height = 0.6, preview_height = 0.4, prompt_position = "bottom" },
                    border          = true,
                    -- disable treesitter preview highlighting (ft_to_lang removed in nvim 0.12)
                    preview = { treesitter = false },
                    -- mirror zshrc fzf bindings: ctrl-j/k for navigation, esc to close
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<Esc>"] = actions.close,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                    -- focus on result after selection (mirrors ctrlsf_auto_focus)
                    selection_strategy = "reset",
                },
                pickers = {
                    find_files  = {
                        hidden          = true,
                        layout_strategy = "vertical",
                        layout_config   = { vertical = { height = 0.95, preview_height = 0.55, prompt_position = "bottom" } },
                    },
                    live_grep   = {
                        additional_args = { "--hidden" },
                        layout_strategy = "vertical",
                        layout_config   = { vertical = { height = 0.95, preview_height = 0.55, prompt_position = "bottom" } },
                    },
                    grep_string = {
                        layout_strategy = "vertical",
                        layout_config   = { vertical = { height = 0.95, preview_height = 0.55, prompt_position = "bottom" } },
                    },
                    buffers     = {
                        sort_mru          = true,
                        ignore_current_buffer = true,
                    },
                },
            })

            telescope.load_extension("fzf")
        end,
    },
}
