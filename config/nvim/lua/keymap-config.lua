vim.g.mapleader = ","

vim.keymap.set("n", "<Leader>y", "\"+y")
vim.keymap.set("v", "<Leader>y", "\"+y")
vim.keymap.set("n", "<Leader>Y", "\"+Y")

vim.keymap.set("n", "<Leader>d", "\"_d")
vim.keymap.set("v", "<Leader>d", "\"_d")

vim.keymap.set("t", "<C-Esc>", [[<C-\><C-n>]],
    { expr = false, noremap = true, silent = true })
