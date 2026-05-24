local map = vim.keymap.set

vim.g.mapleader = " "

-- Escape (mirrors kj remap + Esc disable)
map("i", "kj", "<Esc>")
map("v", "kj", "<Esc>")
map("c", "kj", "<C-C>")
map("i", "<Esc>", "<Nop>")

-- Window navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Copy to system clipboard
map("n", "<C-c>", '"+y')

-- Tabs
map("n", "<S-t>", ":tabnew<CR>")
map("n", "<S-j>", ":tabnext<CR>")
map("n", "<S-k>", ":tabprevious<CR>")
map("n", "<S-q>", ":tabclose<CR>")

-- File tree
map("n", ",",          ":NvimTreeToggle<CR>")
map("n", "<leader>n",  ":NvimTreeFindFile<CR>")

-- File search (mirrors <S-f>, <C-Left>, <C-Up>)
map("n", "<S-f>",    ":Telescope find_files<CR>")
map("n", "<C-Left>", ":vsplit<CR>:Telescope find_files<CR>")
map("n", "<C-Up>",   ":split<CR>:Telescope find_files<CR>")

-- Project-wide search (mirrors Ag/<C-g> and CtrlSF/<C-F>f)
map("n", "<C-g>",   ":Telescope live_grep<CR>")
map("n", "<C-p>",   ":Telescope grep_string<CR>")
map("n", "<C-F>f",  ":Telescope live_grep<CR>")
map("v", "<C-F>f",  ":Telescope grep_string<CR>")

-- Buffer picker (mirrors <leader>b, <leader>sp, <leader>vs)
map("n", "<leader>b",  ":Telescope buffers<CR>")
map("n", "<leader>sp", ":split<CR>:Telescope buffers<CR>")
map("n", "<leader>vs", ":vsplit<CR>:Telescope buffers<CR>")

-- Symbol outline (mirrors <C-t> Tagbar)
map("n", "<C-t>", ":AerialToggle<CR>")

-- Clear search highlight (new)
map("n", "<leader><space>", ":nohlsearch<CR>")

-- Close buffer without destroying split (new, requires bufdelete.nvim)
map("n", "<leader>q", ":Bdelete<CR>")

-- Quickfix navigation (new)
map("n", "]q", ":cnext<CR>")
map("n", "[q", ":cprev<CR>")

-- Diagnostics window (new)
map("n", "<leader>d", ":Trouble diagnostics toggle<CR>")

-- Mark recall (mirrors <leader>m → ')
map("n", "<leader>m", "'")
map("o", "<leader>m", "'")

-- LSP mappings defined in plugins/lsp.lua via on_attach
