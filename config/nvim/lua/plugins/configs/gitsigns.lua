local gitsigns = require("gitsigns")

vim.keymap.set("n", "<leader>hs", function() gitsigns.stage_hunk() end,
    { desc = "Stage hunk" })
vim.keymap.set("n", "<leader>hr", function() gitsigns.reset_hunk() end,
    { desc = "Reset hunk" })
vim.keymap.set("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Stage hunk" })
vim.keymap.set("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end,
    { desc = "Reset hunk" })

vim.keymap.set("n", "<leader>hN", function() gitsigns.prev_hunk() end,
    { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>hn", function() gitsigns.next_hunk() end,
    { desc = "Undo stage hunk" })

vim.keymap.set("n", "<leader>hu", function() gitsigns.undo_stage_hunk() end,
    { desc = "Undo stage hunk" })
vim.keymap.set("n", "<leader>hp", function() gitsigns.preview_hunk() end,
    { desc = "Preview hunk" })
vim.keymap.set("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end,
    { desc = "Blame line" })

vim.keymap.set("n", "<leader>hS", function() gitsigns.stage_buffer() end,
    { desc = "Stage buffer" })
vim.keymap.set("n", "<leader>hR", function() gitsigns.reset_buffer() end,
    { desc = "Reset buffer" })

return {
    word_diff = false,
    current_line_blame = true,
}
-- vim: shiftwidth=4 tabstop=4
