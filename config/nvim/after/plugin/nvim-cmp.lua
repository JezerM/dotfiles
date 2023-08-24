vim.o.completeopt = "menu,menuone,noselect"

local cmp = require "cmp"
local lspkind = require "lspkind"

cmp.setup({
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
        format = lspkind.cmp_format({
            mode = "symbol_text",
            preset = "default",
        }),
    },
    window = {
        completion = cmp.config.window.bordered({
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder,CursorLine:DiffText',
        }),
        documentation = cmp.config.window.bordered({
            winhighlight = 'NormalFloat:NormalFloat,FloatBorder:FloatBorder',
        }),
    },
    view = {
        entries = "custom"
    },
    experimental = {
        ghost_text = true,
    },
})

local cmp_autopairs = require('nvim-autopairs.completion.cmp')

require('nvim-autopairs').setup()

cmp.event:on( 'confirm_done', cmp_autopairs.on_confirm_done({
    map_char = { tex = '{' }
}))

-- vim: shiftwidth=4 tabstop=4
