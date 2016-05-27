set ruler
set number
set title
set hlsearch
set autoindent
set tabstop=2
set shiftwidth=2
set expandtab
syntax on

execute pathogen#infect()
filetype plugin indent on

" for airline
set laststatus=2
let g:airline_theme='zenburn'

" vim theme
colo peachpuff

" for NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <F3>:NerdTreeToggle<CR>
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NerdTree.isTabTree()) | q | endif

" for syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
