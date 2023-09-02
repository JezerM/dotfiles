local cmp = require("cmp")
local cmp_autopairs = require("nvim-autopairs.completion.cmp")

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({
    map_char = { tex = "{" }
}))

return { }
-- vim: shiftwidth=4 tabstop=4
