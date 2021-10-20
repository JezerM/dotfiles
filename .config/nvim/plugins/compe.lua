--local function prequire(...)
    --local status, lib = pcall(require, ...)
    --if (status) then return lib end
    --return nil
--end

--local luasnip = prequire('luasnip')

vim.o.completeopt = "menu,menuone,noselect"

local cmp = require'cmp'
local lspkind = require'lspkind'

cmp.setup({
		snippet = {
			expand = function(args)
				vim.fn["UltiSnips#Anon"](args.body)
			end
		},
		mapping = {
			['<C-d>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.close(),
			['<CR>'] = cmp.mapping.confirm({
				select = true,
				behavior = cmp.ConfirmBehavior.Replace,
			}),
		},
		sources = {
			{ name = 'buffer' },
			{ name = 'calc' },
			{ name = 'ultisnips' },
			{ name = 'nvim_lua' },
			{ name = 'nvim_lsp' },
			{ name = 'path' },
		},
		completion = {
			keyword_length = 1,
		},
		formatting = {
			format = lspkind.cmp_format({with_text = true, menu = ({
				buffer = "[Buffer]",
				calc = "[Calc]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
			})}),
		},
		experimental = {
			native_menu = true,
			ghost_text = false,
		},
		preselect = true,
	})

--[[
   [require'compe'.setup {
	 [  enabled = true;
	 [  autocomplete = true;
	 [  debug = false;
	 [  min_length = 1;
	 [  preselect = 'enable';
	 [  throttle_time = 80;
	 [  source_timeout = 200;
	 [  incomplete_delay = 400;
	 [  max_abbr_width = 100;
	 [  max_kind_width = 100;
	 [  max_menu_width = 100;
	 [  documentation = true;
   [
	 [  source = {
	 [    path = true;
	 [    nvim_lsp = true;
	 [    nvim_lua = true;
	 [    buffer = true;
	 [    calc = true;
	 [    vsnip = false;
	 [    ultisnips = true;
	 [    snippets_nvim = true;
	 [    --spell = true;
	 [    --tags = true;
	 [    --treesitter = true;
	 [  };
   [}
   [
   [local t = function(str)
	 [  return vim.api.nvim_replace_termcodes(str, true, true, true)
   [end
   [
   [local check_back_space = function()
	 [    local col = vim.fn.col('.') - 1
	 [    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
	 [        return true
	 [    else
	 [        return false
	 [    end
   [end
   [
   [-- Use (s-)tab to:
   [--- move to prev/next item in completion menuone
   [--- jump to prev/next snippet's placeholder
   [_G.tab_complete = function()
	 [  if vim.fn.pumvisible() == 1 then
	 [    return t "<C-n>"
	 [  --elseif luasnip and luasnip.expand_or_jumpable() then
	 [      --return t "<Plug>luasnip-expand-or-jump"
	 [  elseif check_back_space() then
	 [    return t "<Tab>"
	 [  else
	 [    return vim.fn['compe#complete']()
	 [  end
   [end
   [_G.s_tab_complete = function()
	 [  if vim.fn.pumvisible() == 1 then
	 [    return t "<C-p>"
	 [  --elseif luasnip and luasnip.jumpable(-1) then
	 [      --return t "<Plug>luasnip-jump-prev"
	 [  else
	 [    return t "<S-Tab>"
	 [  end
   [end
	 ]]

--vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
--vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
