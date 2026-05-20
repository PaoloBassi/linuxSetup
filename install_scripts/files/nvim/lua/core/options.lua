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

vim.diagnostic.config({
    virtual_text   = { prefix = "●", spacing = 4 },
    signs          = true,
    underline      = true,
    severity_sort  = true,
    float          = { border = "rounded", source = true },
})

local undodir = vim.fn.expand("$HOME/.config/nvim/.undodir")
opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
