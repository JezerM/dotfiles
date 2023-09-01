require("nvim-treesitter.configs").setup {
    modules = {},
    ensure_installed = { "lua", "c", "rust", "javascript", "typescript" },
    ignore_install = {},
    sync_install = false,
    auto_install = true,
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
    indent = {
        enable = true,
    }
}

-- vim: shiftwidth=4 tabstop=4
