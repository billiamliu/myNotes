syntax on            " syntax hilighting on

set shiftwidth=2     " shiftwidth (move text blocks with < and > in visual mode) set to 4.
set tabstop=2        " tabstop set to 4.
set ruler            " show ruler
set expandtab        " expand all tabs to spaces
" set nohlsearch       " no highlighted searches
set bs=2             " allow backspacing over everything in insert mode
set ai               " autoindenting always on
set relativenumber   " for faster navigation (default: set number)
set incsearch
set hlsearch

color onedark

execute pathogen#infect()
filetype plugin indent on

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" for syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checkers = ['eslint']

" for nerdtree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NerdTree.isTabTree()) | q | endif
silent! nmap <F2> :NERDTreeToggle<CR>
silent! map <F3> :NERDTreeFind<CR>

let g:NERDTreeMapActivateNode="<F3>"
let g:NERDTreeMapPreview="<F4>"

" for airline
set laststatus=2
let g:airline_theme='zenburn'
