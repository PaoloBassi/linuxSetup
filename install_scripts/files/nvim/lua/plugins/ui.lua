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

            local palette = require("catppuccin.palettes").get_palette("mocha")

            local filename_pill = {
                "filename",
                path    = 1,
                symbols = { modified = " +", readonly = " ", unnamed = "[No Name]" },
                padding = 1,
                separator = { left = "", right = "" },
            }

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
                    lualine_x = { lsp_errors, lsp_warnings, "filetype" },
                    lualine_y = { "progress" },
                    lualine_z = { "location" },
                },
                winbar = {
                    lualine_c = {
                        vim.tbl_extend("force", filename_pill, {
                            color = { bg = palette.surface0, fg = palette.text, gui = "bold" },
                        }),
                    },
                },
                inactive_winbar = {
                    lualine_c = {
                        vim.tbl_extend("force", filename_pill, {
                            color = { bg = palette.mantle, fg = palette.overlay1 },
                        }),
                    },
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

    -- Colored active window separator (Catppuccin Mocha Mauve) ----------------
    {
        "nvim-zh/colorful-winsep.nvim",
        event = { "WinLeave" },
        opts = {
            highlight   = "#cba6f7",
            border      = "rounded",
            excluded_ft = { "TelescopePrompt", "NvimTree", "aerial", "toggleterm" },
        },
    },

    -- Window maximize/restore toggle ------------------------------------------
    {
        "szw/vim-maximizer",
        keys = {
            { "<leader>z", "<cmd>MaximizerToggle<CR>", desc = "Toggle maximize window" },
        },
    },

    -- Polish vim.ui.select / vim.ui.input with Telescope-style popups ---------
    {
        "stevearc/dressing.nvim",
        event  = "VeryLazy",
        config = function()
            require("dressing").setup()
        end,
    },

    -- Cursor smear trail with fire hazard preset -----------------------------
    {
        "sphamba/smear-cursor.nvim",
        opts = {
            stiffness              = 0.5,
            trailing_stiffness     = 0.5,
            matrix_pixel_threshold = 0.5,
        },
    },

    -- Dim inactive windows, complements colorful-winsep's active border -------
    {
        "levouh/tint.nvim",
        event = "WinNew",
        opts = {
            -- tint.nvim's own `tint` transform adds a fixed offset per RGB channel;
            -- once a channel clips at 0 it stops moving in lockstep with the others
            -- and the hue visibly shifts. A multiplicative scale never clips while
            -- darkening, so hue/saturation stay exactly identical, just dimmer.
            transforms = {
                function(r, g, b, _)
                    local factor = 0.45
                    -- rgb_to_hex packs r/g/b into a single int before formatting;
                    -- non-integer channels bleed across byte boundaries and corrupt
                    -- the colour, so floor each channel before returning it.
                    return math.floor(r * factor), math.floor(g * factor), math.floor(b * factor)
                end,
            },
            window_ignore_function = function(winid)
                local ft = vim.bo[vim.api.nvim_win_get_buf(winid)].filetype
                return vim.tbl_contains({ "NvimTree", "TelescopePrompt", "aerial", "toggleterm" }, ft)
            end,
        },
    },

    -- On-demand overlay showing keys as you press them (demos/pairing) --------
    {
        "nvzone/showkeys",
        cmd = "ShowkeysToggle",
        opts = { position = "bottom-right", maxkeys = 5 },
    },

    -- Enhanced UI: cmdline popup, notifications, LSP progress ----------------
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"]                = true,
                    },
                },
                presets = {
                    bottom_search         = true,
                    command_palette       = true,
                    long_message_to_split = true,
                    lsp_doc_border        = true,
                },
            })
        end,
    },
}
