---@module 'oil'
---@type oil.SetupOpts
return {
    columns = {
        "icon",
        "permissions",
        "size",
        "mtime",
    },
    keymaps = {
        ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-p>"] = { "actions.preview", opts = { split = "belowright" } },
        ["|"] = { "actions.parent", mode = "n" },   -- My '`' key in a US keyboard
        ["°"] = { "actions.open_cwd", mode = "n" }, -- My '~' key in a US keyboard
    },
    watch_for_changes = true,
    win_options = {
        signcolumn = "yes:2",
        cursorcolumn = false,
    },
    float = {
        preview_split = "right"
    }
}
