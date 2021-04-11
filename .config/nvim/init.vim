set shiftwidth=2
set tabstop=2
set expandtab
set autoindent
set smartindent
let g:suda_smart_edit = 1
set mouse=a

tnoremap <Esc> <C-\><C-n>
map <silent> <A-z> :let &wrap = !&wrap<CR>
inoremap " ""<Left>
inoremap ' ''<Left>
inoremap ` ``<Left> 
inoremap ( ()<Left>
inoremap { {}<Left>
inoremap [ []<Left>
nnoremap <A-t> :NERDTreeToggle<CR>

" Airline
" let g:airline_theme="kolor"
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#fnamemod = ':t'

let g:airline_left_sep = "\uE0C6"
let g:airline_right_sep = "\uE0C7"

" Gruvbox
let g:gruvbox_italic=1
let g:airline_theme="gruvbox"
set termguicolors

" Aliases
command! YcmToggle let b:ycm_completing = !b:ycm_completing

" Open the existing NERDTree on each new tab.
" autocmd BufWinEnter * silent NERDTreeMirror

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" Plugins will be downloaded under the specified directory."
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes' |
      \ Plug 'morhetz/gruvbox'
Plug 'yggdroot/indentline'
Plug 'myusuf3/numbers.vim'
Plug 'romkatv/powerlevel10k'
Plug 'junegunn/fzf'
Plug 'leafgarland/typescript-vim'
Plug 'valloric/youcompleteme' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'lambdalisue/suda.vim'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree' |
      \ Plug 'Xuyuanp/nerdtree-git-plugin' |
      \ Plug 'ryanoasis/vim-devicons'
Plug 'scrooloose/nerdcommenter'
Plug 'lilydjwg/colorizer'
Plug 'arcticicestudio/nord-vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colorscheme gruvbox
