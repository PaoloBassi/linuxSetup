return {
    -- Status line (replaces lightline) ----------------------------------------
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
        config = function()
            local function diag_count(severity)
                return #vim.diagnostic.get(0, { severity = severity })
            end
            local function lsp_errors()
                local n = diag_count(vim.diagnostic.severity.ERROR)
                return n > 0 and ("✖ " .. n) or ""
            end
            local function lsp_warnings()
                local n = diag_count(vim.diagnostic.severity.WARN)
                return n > 0 and ("⚠ " .. n) or ""
            end

            require("lualine").setup({
                options = {
                    theme = require("catppuccin.utils.lualine")("mocha"),
                    component_separators = "|",
                    section_separators   = { left = "", right = "" },
                    globalstatus         = true,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "filename",
                            path    = 1,
                            symbols = { modified = " +", readonly = " ", unnamed = "[No Name]" },
                        },
                    },
                    lualine_x = { lsp_errors, lsp_warnings, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
            })
        end,
    },

    -- File tree (replaces NERDTree) --------------------------------------------
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.g.loaded_netrw       = 1
            vim.g.loaded_netrwPlugin = 1
            require("nvim-tree").setup({
                view = { width = 30, side = "left" },
                renderer = {
                    group_empty = true,
                    icons       = { show = { file = true, folder = true, git = true } },
                },
                filters  = { dotfiles = false },
                git      = { enable = true },
                actions  = { open_file = { quit_on_open = false } },
            })
        end,
    },

    -- Indent guides (new) ------------------------------------------------------
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        config = function()
            require("ibl").setup({
                indent = { char = "│" },
                scope  = { enabled = true },
            })
        end,
    },

    -- Smooth scrolling (replaces vim-smoothie) ---------------------------------
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup({ mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>" } })
        end,
    },

    -- Mark visualization (replaces vim-signature) ------------------------------
    {
        "chentoast/marks.nvim",
        config = function()
            require("marks").setup({ default_mappings = true })
        end,
    },

    -- Close buffer without destroying split (new) ------------------------------
    { "famiu/bufdelete.nvim" },

    -- Show available keybindings (new) -----------------------------------------
    {
        "folke/which-key.nvim",
        event  = "VeryLazy",
        config = function()
            require("which-key").setup()
        end,
    },

    -- Diagnostics list window (new) --------------------------------------------
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("trouble").setup()
        end,
    },

    -- Highlight other instances of word under cursor (replaces CursorHold autocmd)
    {
        "RRethy/vim-illuminate",
        config = function()
            require("illuminate").configure({
                providers = { "lsp", "treesitter", "regex" },
                delay     = 300,
            })
        end,
    },
}
