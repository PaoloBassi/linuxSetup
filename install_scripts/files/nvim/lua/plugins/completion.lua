return {
    {
        "saghen/blink.cmp",
        dependencies = { "L3MON4D3/LuaSnip" },
        version = "*", -- uses pre-built Rust binaries from GitHub releases
        opts = {
            snippets = { preset = "luasnip" },
            keymap = {
                preset = "none",
                ["<C-Space>"] = { "show", "fallback" },
                ["<C-e>"]     = { "cancel", "fallback" },
                ["<CR>"]      = { "fallback" },
                ["<Tab>"]     = { "accept", "snippet_forward", "fallback" },
                ["<S-Tab>"]   = { "snippet_backward", "fallback" },
                ["<C-j>"]     = { "select_next", "fallback" },
                ["<C-k>"]     = { "select_prev", "fallback" },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
            },
            completion = {
                menu = {
                    draw = {
                        columns = {
                            { "label", "label_description", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
            },
        },
    },
}
