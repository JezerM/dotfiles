vim.cmd.language("en_US.UTF-8")

vim.opt.spelllang = { "es", "en_us" }

vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.scrolloff = 4

vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.laststatus = 3

-- Undo
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

-- Timeout
vim.opt.timeout = true
vim.opt.timeoutlen = 300

-- Search
vim.opt.incsearch = true
vim.opt.hlsearch = false

-- Tabs
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

-- Indent
vim.opt.linebreak = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.listchars = {
    --eol = "↲",
    tab = "▸ ",
    trail = "·"
}
vim.opt.list = true

vim.g.suda_smart_edit = 1
vim.g.mkdp_open_to_the_world = 1

-- Conceal and IndentLine
vim.opt.conceallevel = 2
vim.opt.concealcursor = ""

-- Latex
vim.g.tex_flavor = "latex"
if (vim.fn.has("linux")) then
    vim.g.vimtex_view_method = "zathura"
elseif (vim.fn.has("mac")) then
    vim.g.vimtex_view_method = "skim"
end
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = "abdmg"

-- UltiSnips
vim.g.UltiSnipsSnippetDirectories = {"config/nvim/UltiSnips/", "UltiSnips"}
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
vim.g.UltiSnipsEditSplit = "vertical"

-- Gruvbox
vim.g.gruvbox_italic = 1
vim.g.airline_theme = "gruvbox"
vim.g.gruvbox_contrast_dark = "medium"
vim.opt.background = "dark"

-- Gruvbox material
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "original"
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_sign_column_background = "none"
vim.g.gruvbox_material_menu_selection_background = "blue"
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.g.gruvbox_material_diagnostic_text_highlight = 0

-- Everforest
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


--local sign_icons = { Error = " ", Warn = " ", Hint = "󰌶 ", Info = " " }
local sign_numhl = { Error = "TSDanger", Warn = "TSWarning", Hint = "TSTodo", Info = "TSNote" }
for type, numhl in pairs(sign_numhl) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = "", texthl = hl, numhl = numhl })
end

-- vim: shiftwidth=4 tabstop=4
