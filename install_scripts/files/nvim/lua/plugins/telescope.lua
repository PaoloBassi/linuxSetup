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
                    -- mirrors FZF_DEFAULT_OPTS: --height 60% --reverse --border
                    layout_strategy = "vertical",
                    layout_config   = { height = 0.6, preview_height = 0.4 },
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
                    find_files  = { hidden = true },
                    live_grep   = {
                        additional_args = { "--hidden" },
                        -- mirrors ctrlsf_position = 'right'
                        layout_config   = { preview_width = 0.5 },
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
