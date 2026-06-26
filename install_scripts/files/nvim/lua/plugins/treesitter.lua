-- nvim-treesitter was rewritten: no more require("nvim-treesitter.configs").setup().
-- Highlight is now enabled automatically by neovim when parsers are installed.
-- nvim-treesitter only manages parser installation.

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build        = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
        config = function()
            require("nvim-treesitter").setup()

            -- install parsers not bundled with nvim (deferred to avoid blocking startup)
            vim.defer_fn(function()
                local install = require("nvim-treesitter.install")
                for _, lang in ipairs({
                    "c", "cpp", "lua", "bash", "python",
                    "cmake", "make", "json", "yaml", "toml", "markdown",
                }) do
                    pcall(install.install, lang, { skip_if_installed = true })
                end
            end, 200)
        end,
    },
    -- text objects for function/class selections and jumps
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require("nvim-treesitter-textobjects").setup({
                select = { lookahead = true },
                move   = { set_jumps = true },
            })

            -- select text objects: af/if for functions, ac/ic for classes
            local select = require("nvim-treesitter-textobjects.select")
            for lhs, query in pairs({
                ["af"] = "@function.outer", ["if"] = "@function.inner",
                ["ac"] = "@class.outer",    ["ic"] = "@class.inner",
                ["aa"] = "@parameter.outer",["ia"] = "@parameter.inner",
            }) do
                vim.keymap.set({ "x", "o" }, lhs, function()
                    select.select_textobject(query, "textobjects")
                end)
            end

            -- move between functions/classes
            local move = require("nvim-treesitter-textobjects.move")
            vim.keymap.set("n", "]f", function() move.goto_next_start("@function.outer", "textobjects") end)
            vim.keymap.set("n", "[f", function() move.goto_previous_start("@function.outer", "textobjects") end)
            vim.keymap.set("n", "]c", function() move.goto_next_start("@class.outer", "textobjects") end)
            vim.keymap.set("n", "[c", function() move.goto_previous_start("@class.outer", "textobjects") end)
        end,
    },

    -- Sticky context header: shows current function/class while scrolling -----
    {
        "nvim-treesitter/nvim-treesitter-context",
        config = function()
            require("treesitter-context").setup({ max_lines = 3 })
        end,
    },

    -- Colored matching brackets/delimiters ------------------------------------
    { "HiPhish/rainbow-delimiters.nvim" },
}
