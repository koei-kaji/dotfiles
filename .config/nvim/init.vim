" set options
set shell=/bin/zsh
set shiftwidth=4
set tabstop=4
set expandtab
set textwidth=0
set autoindent
set hlsearch
set clipboard=unnamed
set number
set scrolloff=999

syntax on

" map
inoremap <silent> jj <ESC>
nnoremap j gj
nnoremap k gk
nnoremap H ^
nnoremap L $

packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'neoclide/coc.nvim', {'branch': 'release'}
call jetpack#end()

if exists('g:vscode')
    xmap gc     <Plug>VSCodeCommentary
    nmap gc     <Plug>VSCodeCommentary
    omap gc     <Plug>VSCodeCommentary
    nmap gcc    <Plug>VSCodeCommentaryLine
else
    " do something
endif
