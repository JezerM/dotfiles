vim.g.db_ui_use_nerd_fonts = 1

vim.g.db_ui_icons = {
    expanded = {
        db = "▾ ",
        buffers = "▾ ",
        saved_queries = "▾ ",
        schemas = "▾ ",
        schema = "▾ 󰙅",
        tables = "▾ 󰓱",
        table = "▾ 󰓱",
    },
    collapsed = {
        db = "▸ ",
        buffers = "▸ ",
        saved_queries = "▸ ",
        schemas = "▸ ",
        schema = "▸ 󰙅",
        tables = "▸ 󰓱",
        table = "▸ 󰓱",
    },
    saved_query = "",
    new_query = "󰓰",
    tables = "󰓫",
    buffers = "﬘",
    add_connection = "󰆺",
    connection_ok = "✓",
    connection_error = "✕",
}
-- vim: shiftwidth=4 tabstop=4
