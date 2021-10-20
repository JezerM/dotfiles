set nocompatible 

" Plugins will be downloaded under the specified directory."
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.

" Lua
Plug 'neovim/nvim-lspconfig'
Plug 'onsails/lspkind-nvim'
Plug 'glepnir/lspsaga.nvim'
Plug 'ray-x/lsp_signature.nvim'

" Org
Plug 'vhyrro/neorg'

" Completion
"Plug 'hrsh7th/nvim-compe' " Now deprecated
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-calc'
Plug 'quangnguyen30192/cmp-nvim-ultisnips'

Plug 'windwp/nvim-autopairs'

Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yggdroot/indentline'
Plug 'myusuf3/numbers.vim'
Plug 'romkatv/powerlevel10k'

" Gruvbox
"Plug 'rktjmp/lush.nvim'
"Plug 'npxbr/gruvbox.nvim'
Plug 'morhetz/gruvbox'

Plug 'lervag/vimtex'
Plug 'mattn/emmet-vim'

" Smoother navigation
Plug 'psliwka/vim-smoothie'

" Snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'SirVer/ultisnips'

" Markdown
"Plug 'godlygeek/tabular'
"Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
Plug 'ellisonleao/glow.nvim', {'do': ':GlowInstall', 'branch': 'main'}

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Editor config
Plug 'editorconfig/editorconfig-vim'

" Lua colors
Plug 'folke/lsp-colors.nvim'
Plug 'norcalli/nvim-colorizer.lua'

" Treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update

" Prettier
Plug 'dense-analysis/ale'

" Ranger
Plug 'francoiscabrol/ranger.vim'
Plug 'rbgrouleff/bclose.vim'

" FZF
Plug 'junegunn/fzf', {'do': {-> fzf#install()}}
Plug 'junegunn/fzf.vim'
Plug 'ojroques/nvim-lspfuzzy'

" Telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'gbrlsnchs/telescope-lsp-handlers.nvim'

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
"Plug 'neoclide/coc.nvim', {'branch': 'release'}

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

language en_US.utf8
set spelllang=es,en_us

set shiftwidth=0
set tabstop=2
set linebreak
set autoindent
set smartindent
let g:suda_smart_edit = 1
set mouse=a
set termguicolors
set hidden

" IndentLine
set listchars=tab:\¦\ 
set list

let g:indentLine_setConceal = 0
let g:indentLine_concealcursor = 0
"let g:indentLine_fileTypeExclude = ['markdown']
set conceallevel=2
"let g:vim_markdown_conceal = 0

set guifont=MesloLGS\ NF:h12

let g:startify_fortune_use_unicode = 1
let g:smoothie_experimental_mappings = 1
let g:user_emmet_leader_key = '<leader>y'

" Latex
let g:tex_flavor='latex'
let g:vimtex_view_method='zathura'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'
let g:vimtex_syntax_conceal_default=1
set concealcursor="n-i"

" Ultisnips
let g:UltiSnipsSnippetDirectories = ['~/.config/nvim/UltiSnips', 'UltiSnips']
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="vertical"

" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_left_sep = "\ue0c6"
let g:airline_right_sep = "\ue0c7"

" Lua files

luafile ~/.config/nvim/plugins/compe.lua
luafile ~/.config/nvim/plugins/init.lua
luafile ~/.config/nvim/plugins/telescope.lua

let g:ale_linters_explicit = 1

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

set foldtext=MyFoldText()

function MyFoldText()
  let line = getline(v:foldstart)
  let folded_line_num = v:foldend - v:foldstart
  let sub = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
  return v:folddashes . sub . " (" . folded_line_num . " L) "
endfunction

let custom_header = systemlist('cat $HOME/.config/nvim/figlet.txt')

let g:startify_custom_header = custom_header

let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']

" Tabmove
function TabMove(str)
  let tabpage = tabpagenr()
  if tabpage == 0
        tabmove $
  elseif tabpage == tabpagenr('$')
        tabmove 0
  else
    tabmove a:str
  endif
endfunction

" Restore cursor position
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Highlight cursorline
augroup CursorLine
  au!
  au VimEnter,WinEnter,BufWinEnter * setlocal cursorline cursorcolumn
  au WinLeave * setlocal nocursorline nocursorcolumn
augroup END

" Documentation on hover
"augroup hover
  "autocmd!
  "autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
  "autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
  "autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
"augroup end

" Ranger
let g:ranger_map_keys = 0

tnoremap <Esc> <C-\><C-n>
map <silent> <A-z> :let &wrap = !&wrap<CR>

nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fk <cmd>lua require('telescope.builtin').treesitter()<cr>
nnoremap <leader>f  <cmd>lua require('telescope.builtin').builtin()<cr>

nnoremap <silent><S-C-PageUp> <cmd>tabmove -1<cr>
nnoremap <silent><S-C-PageDown> <cmd>tabmove +1<cr>

"" Gruvbox
let g:gruvbox_italic=1
let g:airline_theme = "gruvbox"
let g:gruvbox_contrast_dark = "medium"
set background=dark

" Transparent background
"autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE
"hi Normal ctermbg=NONE guibg=NONE

colorscheme gruvbox
