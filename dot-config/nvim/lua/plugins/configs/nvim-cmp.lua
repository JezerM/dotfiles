vim.o.completeopt = "menu,menuone,noselect"

local cmp = require "cmp"
local lspkind = require "lspkind"

local function from_rgb_to_hex(color_line)
    local rgb_colors = {}
    local is_rgba = false

    -- Try to detect RGB before RGBA
    -- rgb(255, 255, 255)
    local rgb = color_line:match '^rgb%(%d+%%?,%s?%d+%%?,%s?%d+%%?%)$'
    if not rgb then
        rgb = color_line:match '^rgb%(%d+%%?,%s?%d+%%?,%s?%d+%%?%)$'
        is_rgba = true
    end
    if not rgb then
        return color_line
    end
    -- Remove the "rgb(", ");" and leave only the numbers before
    -- splitting the string
    for _, color_part in ipairs(
        vim.split(
            is_rgba and rgb:gsub('rgba%(', ''):gsub('%);?', '')
            or rgb:gsub('rgb%(', ''):gsub('%);?', ''),
            ','
        )
    ) do
        rgb_colors[#rgb_colors + 1] = tonumber(color_part)
    end
    local hex_color = '#' .. string.format('%02X%02X%02X', rgb_colors[1], rgb_colors[2], rgb_colors[3])
    return hex_color
end

local options = {
    snippet = {
        expand = function(args)
            vim.fn["UltiSnips#Anon"](args.body)
        end
    },
    mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Replace,
        }),
    }),
    sources = cmp.config.sources({
        --{ name = 'cmp_tabnine' },
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
        { name = 'ultisnips' },
        { name = 'calc' },
        { name = 'path' },
        { name = 'spell' },
        { name = 'buffer' },
        --{ name = 'treesitter' },
    }),
    completion = {
        keyword_length = 1,
        autocomplete = { require("cmp.types").cmp.TriggerEvent.TextChanged },
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            local item = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(item.kind, "%s", { trimempty = true })

            item.kind = " " .. (strings[1] or "") .. " "
            item.menu = "    (" .. (strings[2] or "") .. ")"

            if entry.source.name == "calc" then
                item.kind = "󰃬"
            end

            local entryItem = entry:get_completion_item()
            local color = entryItem.documentation
            if color and type(color) == "string" then
                local hex = from_rgb_to_hex(color)
                if hex:match "^#%x%x%x%x%x%x$" then
                    local hl = "hex-" .. hex:sub(2)

                    if #vim.api.nvim_get_hl(0, { name = hl }) == 0 then
                        vim.api.nvim_set_hl(0, hl, { fg = hex })
                    end

                    item.kind = " 󱓻 "
                    item.kind_hl_group = hl
                    item.menu_hl_group = hl
                end
            end

            return item
        end
    },
    window = {
        completion = cmp.config.window.bordered({
            col_offset = -5,
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:DiffText',
            border = "rounded"
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
            border = "rounded",
        }),
    },
    view = {
        entries = "custom"
    },
    experimental = {
        ghost_text = true,
    },
}

return options
-- vim: shiftwidth=4 tabstop=4
