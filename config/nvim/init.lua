-- This file can be loaded by calling `lua require("plugins")` from your init.vim

local vim = vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn"t have https://github.com/neovim/neovim/pull/12632 merged
--vim._update_package_paths()

require("packer").startup(function()
  local use = use
  -- Packer can manage itself
  use "wbthomason/packer.nvim"
  use "dstein64/vim-startuptime"

  -- Lua
  use "neovim/nvim-lspconfig"
  use "onsails/lspkind-nvim"
  use "ray-x/lsp_signature.nvim"
  use "windwp/nvim-autopairs"
  use "arkav/lualine-lsp-progress"
  use "b0o/schemastore.nvim"

  -- Completion
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-calc"
  use "f3fora/cmp-spell"
  use "ray-x/cmp-treesitter"
  use "quangnguyen30192/cmp-nvim-ultisnips"

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = function() require("nvim-treesitter.install").update({ with_sync = true }) end,
  }
  use { "folke/twilight.nvim", config = function() require("twilight").setup { } end }
  use "sunjon/shade.nvim"

  -- Themes
  --use "vim-airline/vim-airline"
  --use "vim-airline/vim-airline-themes"
  --use "morhetz/gruvbox"
  use "ellisonleao/gruvbox.nvim"
  use "sainnhe/gruvbox-material"
  use "sainnhe/everforest"
  use "yggdroot/indentline"
  use "myusuf3/numbers.vim"
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "nvim-tree/nvim-web-devicons", opt = true }
  }

  -- Lua colors
  use "folke/lsp-colors.nvim"
  use "norcalli/nvim-colorizer.lua"
  use "uga-rosa/ccc.nvim"

  -- Snippets
  use "SirVer/ultisnips"
  use "mattn/emmet-vim"

  -- Markdown
  use { "iamcco/markdown-preview.nvim", run = "cd app && npm install" }
  use { "ellisonleao/glow.nvim", run = ":GlowInstall", branch = "main" }

  -- LaTex
  use "lervag/vimtex"

  -- Git
  --use "airblade/vim-gitgutter"
  use "tpope/vim-fugitive"
  use "lewis6991/gitsigns.nvim"

  -- Editor config
  use "editorconfig/editorconfig-vim"

  -- FZF
  use { "junegunn/fzf", run = function() vim.fn["fzf#install"]() end }
  use "junegunn/fzf.vim"
  use "ojroques/nvim-lspfuzzy"

  -- Telescope
  use "nvim-lua/popup.nvim"
  use {
    "nvim-telescope/telescope.nvim",
    requires = { {"nvim-lua/plenary.nvim"} }
  }
  use "xiyaowong/telescope-emoji.nvim"
  use "AckslD/nvim-neoclip.lua"
  use "nvim-telescope/telescope-packer.nvim"
  use "nvim-telescope/telescope-ui-select.nvim"

  -- Syntax
  use "leafOfTree/vim-vue-plugin"
  use "sheerun/vim-polyglot"
  use "folke/todo-comments.nvim"
  --use "leafgarland/typescript-vim"
  use {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
  }

  -- Utils
  use "lambdalisue/suda.vim"
  use "tmhedberg/simpylfold"
  use "scrooloose/nerdcommenter"
  use "mhinz/vim-startify"

end)

--vim.call("colorscheme gruvbox")

local cmd = vim.cmd

--vim.opt.language = "en_US.utf8"
cmd "language en_US.UTF-8"
vim.opt.spelllang = { "es", "en_us" }

vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"

-- Searc
--vim.opt.ignorecase = true
--vim.opt.smartcase = true

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

-- Conceal and IndentLine
vim.g.indentLine_setConceal = 0
vim.g.indentLine_concealcursor = 0
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

-- Powerline
vim.g.airline_powerline_fonts = 1
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g["airline#extensions#tabline#formatter"] = "default"
vim.g["airline#extensions#tabline#fnamemod"] = ":t"
vim.g.airline_left_sep = "\u{e0c6}"
vim.g.airline_right_sep = "\u{e0c7}"

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
vim.g.gruvbox_material_sign_column_background = "grey"
vim.g.gruvbox_material_menu_selection_background = "blue"
vim.g.gruvbox_material_ui_contrast = "high"
vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
vim.g.gruvbox_material_statusline_style = "original"
vim.g.gruvbox_material_diagnostic_text_highlight = 1

cmd[[
function! s:gruvbox_material_custom() abort
  " Link a highlight group to a predefined highlight group.
  " See `colors/gruvbox-material.vim` for all predefined highlight groups.
  highlight! link TelescopeSelection OrangeBold
  highlight! link TelescopeSelectionCaret Red
  highlight! link TelescopePromptPrefix Red
  highlight! link CursorLineNr YellowSign
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END
]]

-- Everforest
vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = 1

-- Folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
--cmd "set foldexpr=nvim_treesitter#foldexpr()"

-- Startify
local custom_header = vim.fn["systemlist"]("cat $HOME/.config/nvim/figlet.txt")
vim.g.startify_custom_header = custom_header

-- Restore cursor position

cmd[[
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
]]
cmd[[
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
  au WinLeave * setlocal nocursorline nocursorcolumn
augroup END
]]

vim.api.nvim_set_keymap("n", "<leader>ff",
  [[<Cmd>lua require('telescope.builtin').find_files()<CR>]],
  { expr = false, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg",
  [[<Cmd>lua require('telescope.builtin').live_grep()<CR>]],
  { expr = false, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fb",
  [[<Cmd>lua require('telescope.builtin').buffers()<CR>]],
  { expr = false, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fk",
  [[<Cmd>lua require('telescope.builtin').treesitter()<CR>]],
  { expr = false, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fh",
  [[<Cmd>lua require('telescope.builtin').help_tags()<CR>]],
  { expr = false, noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>f ",
  [[<Cmd>lua require('telescope.builtin').builtin()<CR>]],
  { expr = false, noremap = true, silent = true })

cmd "colorscheme gruvbox-material"

-- Lua plugins

require("completion")
require("lsp-config")
require("general-config")
require("telescope-config")
require("lualine-config")
