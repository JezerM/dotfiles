-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local vim = vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
-- Only if your version of Neovim doesn't have https://github.com/neovim/neovim/pull/12632 merged
--vim._update_package_paths()

require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Lua
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind-nvim'
  use 'glepnir/lspsaga.nvim'
  use 'hrsh7th/nvim-compe'

  use 'tpope/vim-sensible'

  -- Themes
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'
  use 'morhetz/gruvbox'
  use 'romkatv/powerlevel10k'

  -- Emmets and those things
  use 'lervag/vimtex'
  use 'mattn/emmet-vim'

  -- Git
  use 'airblade/vim-gitgutter'
  use 'tpope/vim-fugitive'

  -- Telescope
  use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.vim'
  use 'nvim-telescope/telescope.nvim'

  use 'lambdalisue/suda.vim'
  use 'sheerun/vim-polyglot'
  use 'tmhedberg/simpylfold'
  use 'scrooloose/nerdcommenter'

end)

--vim.call("colorscheme gruvbox")

local cmd = vim.cmd
cmd 'colorscheme gruvbox'

vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.linebreak = true
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.mouse = "a"

vim.g.suda_smart_edit = 1

-- Powerline
cmd [[let g:airline#extensions#tabline#enabled = 1]]
cmd [[let g:airline#extensions#tabline#formatter = "default"]]
vim.g.airline_powerline_fonts = 1

-- Gruvbox
vim.g.gruvbox_italic = 1
vim.g.airline_theme = "gruvbox"

-- Folding
vim.opt.foldmethod = "syntax"

