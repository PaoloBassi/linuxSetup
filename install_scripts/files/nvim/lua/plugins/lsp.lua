-- nvim 0.11+ has native LSP config (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig is no longer needed.

local on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, silent = true }
    local map  = vim.keymap.set
    -- mirrors YCM mappings
    map("n", "<leader>]", vim.lsp.buf.definition,  opts)
    map("n", "<leader>p", vim.lsp.buf.references,  opts)
    map("n", "<leader>t", vim.lsp.buf.hover,        opts)
    map("n", "<leader>f", vim.lsp.buf.code_action,  opts)
    map("n", "<leader>r", vim.lsp.buf.rename,       opts)
    -- header/source switch via clangd (mirrors <leader>o → GoToAlternateFile)
    map("n", "<leader>o", function()
        vim.lsp.buf_request(0, "textDocument/switchSourceHeader",
            { uri = vim.uri_from_bufnr(0) },
            function(_, result)
                if result then vim.cmd("e " .. vim.uri_to_fname(result)) end
            end)
    end, opts)
end

-- native LSP config for clangd
vim.lsp.config("clangd", {
    cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--compile-commands-dir=build-Debug",
    },
    filetypes  = { "c", "cpp", "objc", "objcpp" },
    on_attach  = on_attach,
})

return {
    -- Mason: installs LSP binaries (clangd, etc.)
    {
        "williamboman/mason.nvim",
        build  = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },
    -- mason-lspconfig: bridges mason installs with vim.lsp.enable
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim" },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed   = { "clangd" },
                automatic_enable   = true,
            })
        end,
    },
}
