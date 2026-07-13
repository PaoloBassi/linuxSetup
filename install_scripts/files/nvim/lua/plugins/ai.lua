return {
    -- Claude Code IDE integration (right-side toggleable terminal) ------------
    {
        "coder/claudecode.nvim",
        cmd = {
            "ClaudeCode",
            "ClaudeCodeFocus",
            "ClaudeCodeOpen",
            "ClaudeCodeClose",
            "ClaudeCodeSend",
        },
        keys = {
            { "<F2>", "<cmd>ClaudeCode<CR>", desc = "Toggle Claude Code" },
        },
        opts = {
            terminal = {
                split_side             = "right",
                split_width_percentage = 0.35,
            },
        },
        config = function(_, opts)
            require("claudecode").setup(opts)

            -- Auto-accept every diff Claude proposes: the review split still
            -- flashes open (required by the MCP protocol) but gets written
            -- and closed immediately, so the target file is just edited in
            -- place instead of waiting on manual :w / :q.
            vim.api.nvim_create_autocmd("User", {
                pattern = "ClaudeCodeDiffOpened",
                callback = function(event)
                    local win = event.data and event.data.diff_window
                    if win and vim.api.nvim_win_is_valid(win) then
                        vim.api.nvim_set_current_win(win)
                        vim.cmd("ClaudeCodeDiffAccept")
                    end
                end,
            })

            -- Claude's terminal auto-enters terminal-job mode (auto_insert),
            -- which swallows every keystroke, so <C-h/j/k/l> window nav and
            -- the close key need buffer-local terminal-mode maps to work
            -- from inside it too. <F2> mirrors the outside toggle key,
            -- unlike <leader>a whose "<space>a" would collide with normal
            -- typing to Claude.
            vim.api.nvim_create_autocmd("TermOpen", {
                callback = function(event)
                    vim.schedule(function()
                        local terminal = require("claudecode.terminal")
                        if terminal.get_active_terminal_bufnr() ~= event.buf then
                            return
                        end
                        local opts = { buffer = event.buf, silent = true }
                        for _, dir in ipairs({ "h", "j", "k", "l" }) do
                            vim.keymap.set("t", "<C-" .. dir .. ">", "<C-\\><C-n><C-w>" .. dir, opts)
                        end
                        vim.keymap.set("t", "<F2>", function()
                            terminal.simple_toggle()
                        end, opts)
                    end)
                end,
            })
        end,
    },
}
