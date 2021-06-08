set nocompatible 

" Plugins will be downloaded under the specified directory."
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.

" Lua
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'glepnir/lspsaga.nvim'

Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'yggdroot/indentline'
Plug 'myusuf3/numbers.vim'
Plug 'romkatv/powerlevel10k'

Plug 'lervag/vimtex'
Plug 'mattn/emmet-vim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Lua colors
Plug 'folke/lsp-colors.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" FZF
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'ojroques/nvim-lspfuzzy'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'leafgarland/typescript-vim'
"Plug 'valloric/youcompleteme' | " Compile it with './install.py --all' in ycm path
      "\ Plug 'rdnetto/ycm-generator'
Plug 'lambdalisue/suda.vim'
Plug 'scrooloose/nerdtree' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin' |
      \ Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'arcticicestudio/nord-vim'
Plug 'tmhedberg/simpylfold'
Plug 'sheerun/vim-polyglot'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

language en_US.utf8

colorscheme gruvbox

set shiftwidth=2
set tabstop=2
set linebreak
set expandtab
set autoindent
set smartindent
let g:suda_smart_edit = 1
set mouse=a

tnoremap <Esc> <C-\><C-n>
map <silent> <A-z> :let &wrap = !&wrap<CR>
nnoremap <silent> <A-t> :NERDTreeToggle<CR>

"nnoremap <silent> k gk
"nnoremap <silent> j gj
"nnoremap <silent> <Down> gj
"nnoremap <silent> <Up> gk
"nnoremap <silent> 0 g0
"nnoremap <silent> $ g$

nnoremap <silent> <C-f> :Files<CR>
nnoremap <silent>K :Lspsaga hover_doc<CR>

let g:startify_fortune_use_unicode = 1

" Airline
"let g:airline_theme="kolor"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

"let g:airline_left_sep = "\uE0C6"
"let g:airline_right_sep = "\uE0C7"

"" Gruvbox
let g:gruvbox_italic=1
let g:airline_theme = "gruvbox"
set termguicolors

" Aliases
command! YcmToggle let b:ycm_completing = !b:ycm_completing

set foldmethod=syntax
set foldtext=MyFoldText()
function MyFoldText()
  let line = getline(v:foldstart)
  let folded_line_num = v:foldend - v:foldstart
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return v:folddashes . sub . " (" . folded_line_num . " L) "
endfunction

" Transparent background
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
"hi Normal guibg=NONE ctermbg=NONE

" Restore cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * silent NERDTreeMirror

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

let custom_header = systemlist('cat $HOME/.config/nvim/figlet.txt')

let g:startify_custom_header = custom_header

" Lua
lua require('lspfuzzy').setup {}
lua require('lspconfig').clangd.setup{}
lua require('lspkind').init()
lua require('lspsaga').init_lsp_saga()
lua require('colorizer').setup()
lua require('telescope').setup()
