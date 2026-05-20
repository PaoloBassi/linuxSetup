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

-- show diagnostic float when cursor rests on a diagnostic line
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focus = false, scope = "line" })
    end,
})

-- highlight diagnostic lines via extmarks (linehl in signs config is unreliable in nvim 0.12)
local diag_line_ns = vim.api.nvim_create_namespace("diagnostic_line_hl")
local diag_line_groups = {
    [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
    [vim.diagnostic.severity.WARN]  = "DiagnosticLineWarn",
    [vim.diagnostic.severity.INFO]  = "DiagnosticLineInfo",
    [vim.diagnostic.severity.HINT]  = "DiagnosticLineHint",
}
local function apply_diag_line_hl(buf)
    if not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_clear_namespace(buf, diag_line_ns, 0, -1)
    for _, d in ipairs(vim.diagnostic.get(buf)) do
        local hl = diag_line_groups[d.severity]
        if hl then
            pcall(vim.api.nvim_buf_set_extmark, buf, diag_line_ns, d.lnum, 0, {
                line_hl_group = hl,
                priority      = 200,
            })
        end
    end
end
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "BufEnter" }, {
    callback = function(args)
        vim.schedule(function() apply_diag_line_hl(args.buf) end)
    end,
})

local undodir = vim.fn.expand("$HOME/.config/nvim/.undodir")
opt.undodir = undodir
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
