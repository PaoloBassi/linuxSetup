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

            -- C++ standard only for cpp buffers: on .c files it errors and makes the analysis parse C as C++
            local function std(c_arg, cpp_arg)
                return function() return vim.bo.filetype == "cpp" and cpp_arg or c_arg end
            end

            -- mirrors ale_cpp_clangtidy_options / compile-commands-dir
            lint.linters.clangtidy.args = {
                "-p", "build-Debug",
                std("--extra-arg=-std=gnu17", "--extra-arg=-std=c++17"),
                "--extra-arg=-Wall",
                "--extra-arg=-Wextra",
                -- default checks only when the project has no .clang-tidy (otherwise "no checks enabled")
                function()
                    local found = vim.fs.find(".clang-tidy", { upward = true, path = vim.fn.expand("%:p:h") })
                    return "--checks=" .. (#found == 0 and "clang-analyzer-*,bugprone-*" or "")
                end,
            }

            lint.linters.cppcheck.args = {
                "--enable=all",
                std("--std=c11", "--std=c++17"),
                std("--language=c", "--language=c++"),
                "--suppress=missingIncludeSystem",
                "--quiet",
                "--inline-suppr",
                -- overriding args drops nvim-lint's default template, which its parser relies on
                "--template={file}:{line}:{column}: [{id}] {severity}: {message}",
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
