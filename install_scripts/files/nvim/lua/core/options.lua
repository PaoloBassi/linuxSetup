local opt = vim.opt

opt.encoding      = "UTF-8"
opt.number        = true
opt.relativenumber = true
opt.mouse         = "a"
opt.background    = "dark"
opt.hlsearch      = true
opt.expandtab     = true
opt.tabstop       = 4
opt.shiftwidth    = 4
opt.softtabstop   = 4
opt.showmatch     = true
opt.incsearch     = true
opt.autoindent    = true
opt.smartindent   = true
opt.hidden        = true
opt.termguicolors = true
opt.showmode      = false
opt.clipboard     = "unnamedplus"
opt.splitright    = true
opt.splitbelow    = true
opt.updatetime    = 300
opt.undofile      = true
opt.signcolumn    = "yes"

vim.diagnostic.config({
    virtual_text  = false,
    signs         = {
        text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.INFO]  = "●",
            [vim.diagnostic.severity.HINT]  = "◈",
        },
    },
    underline     = true,
    severity_sort = true,
    float         = { border = "rounded", source = true, focusable = false },
})

-- show diagnostic float in command area when cursor rests on a diagnostic line
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    end,
})

local undodir = vim.fn.expand("$HOME/.config/nvim/.undodir")
opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
