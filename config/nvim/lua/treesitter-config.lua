require("nvim-treesitter.configs").setup {
    modules = {},
    ensure_installed = { "lua", "c", "rust", "help", "javascript", "typescript" },
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- vim: shiftwidth=4 tabstop=4
