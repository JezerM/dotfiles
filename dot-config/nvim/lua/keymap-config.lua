vim.g.mapleader = ","

vim.keymap.set({ "n", "v" }, "<Leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<Leader>Y", "\"+Y", { desc = "Yank whole line" })

vim.keymap.set({ "n", "v" }, "<Leader>d", "\"_d", { desc = "Delete without yank" })

vim.keymap.set("t", "<C-Esc>", [[<C-\><C-n>]],
    { expr = false, noremap = true, silent = true })
