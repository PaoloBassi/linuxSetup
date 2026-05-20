return {
    {
        "nvim-treesitter/nvim-treesitter",
        build        = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter.configs").setup({
                -- replaces vim-polyglot + vim-cpp-enhanced-highlight
                ensure_installed = {
                    "c", "cpp", "lua", "vim", "vimdoc",
                    "bash", "python", "cmake", "make",
                    "json", "yaml", "toml", "markdown",
                },
                highlight = {
                    enable                            = true,
                    -- disable regex-based highlighting for supported languages
                    additional_vim_regex_highlighting = false,
                },
                indent = { enable = true },
                -- text objects for C++ functions and classes
                textobjects = {
                    select = {
                        enable    = true,
                        lookahead = true,
                        keymaps   = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                        },
                    },
                    move = {
                        enable     = true,
                        set_jumps  = true,
                        goto_next_start     = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
                        goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
                    },
                },
            })
        end,
    },
}
