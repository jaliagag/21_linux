set mouse=a
set number
set numberwidth=1
set clipboard=unnamed
syntax enable
set showcmd
set ruler
set encoding=utf-8
set sw=2
set laststatus=2


call plug#begin('~/.vim/plugged')

Plug 'morhetz/gruvbox'

" IDE
Plug 'easymotion/vim-easymotion'
Plug 'scrooloose/nerdtree'
Plug 'christoomey/vim-tmux-navigator'
Plug 'Shougo/deoplete.nvim'
Plug 'carlitux/deoplete-ternjs'
" con este plugin, podemos movernos entre los distintos terminales abiertos
" con control + h, j, k y l
Plug 'zchee/deoplete-jedi'
Plug 'ternjs/tern_for_vim', { 'do': 'npm install && npm install -g tern' }
Plug 'neomake/neomake', { 'on': 'Neomake' }
" Plug 'ludovicchabant/vim-gutentags'

call plug#end()

colorscheme gruvbox
let g:gruvbox_contrast_dark= "hard"
let g:deoplete#enable_at_startup = 1
let g:jsx_ext_required = 0
let NERDTreeQuitOnOpen=1
let g:python_host_prog = '/usr/bin/python2'
let g:gutentags_trace = 1
let g:python3_host_prog = 'usr/bin/python3'
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#enable_smart_case = 1
let g:deoplete#enable_camel_case = 1
let g:deoplete#enable_refresh_always = 1
let g:deoplete#max_abbr_width = 0
let g:deoplete#max_menu_width = 0
let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:tern_request_timeout = 1
let g:tern_request_timeout = 6000
let g:tern#command = ['tern']
let g:tern#arguments = [' — persistent']
let g:neomake_javascript_enabled_makers = ['eslint']

let mapleader=" " " cuando quiera usar la tecla leader, va a ser el espacio + otra tecla

nmap <Leader>s <Plug>(easymotion-s2)
" nmap indica que solo funciona en mdo normal - espacio + s inicia easymotion
" espacio s > introducir 2 letras > elegir la opción donde quiero ir
nmap <Leader>nt :NERDTreeFind<CR>
" los dos puntos abre la consola - :NERDTreeFind<CR> - cr es la tecla de enter
" dentro de nerdtree entro al menú con la opción 'm'

nmap <Leader>w :w<CR>
nmap <Leader>q :q<CR>o
