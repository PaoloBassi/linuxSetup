return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            local lint = require("lint")

            -- mirrors ALE: cppcheck + clangtidy only (no clangd, handled by LSP)
            lint.linters_by_ft = {
                c   = { "cppcheck", "clangtidy" },
                cpp = { "cppcheck", "clangtidy" },
            }

            -- mirrors ale_cpp_clangtidy_options / compile-commands-dir
            lint.linters.clangtidy.args = {
                "-p", "build-Debug",
                "--extra-arg=-std=c++17",
                "--extra-arg=-Wall",
                "--extra-arg=-Wextra",
            }

            lint.linters.cppcheck.args = {
                "--enable=all",
                "--std=c++17",
                "--suppress=missingIncludeSystem",
                "--quiet",
                "--inline-suppr",
            }

            -- mirrors ale_lint_on_save and ale_lint_on_enter
            vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
                callback = function()
                    lint.try_lint()
                end,
            })
        end,
    },
}
