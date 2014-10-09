" Vim Settings - Dan Taylor
" Version: Feb. 3, 2014
"

" Basic Settings
"
let mapleader = ','
set nu
set ruler
set wrap!
set background=dark
set expandtab
set incsearch
set hlsearch
set shiftwidth=4
set tabstop=4
set foldmethod=syntax
syntax enable
colorscheme solarized

" Vundle Settings
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
Plugin 'git://git.wincent.com/command-t.git'
Bundle 'joonty/vim-phpqa.git'
Bundle 'plasticboy/vim-markdown'
call vundle#end()


" Pathogen settings
execute pathogen#infect()
filetype plugin indent on

" NERD Tree Settings
autocmd vimenter * if !argc() | NERDTree | endif

" Java & Maven Settings
autocmd Filetype java compiler mvn
autocmd Filetype pom compiler mvn
autocmd Filetype java no <F2> :make clean package<CR>
autocmd Filetype java no <S-F2> :make clean package site site:stage<CR>
autocmd Filetype java no <C-F2> :make clean<CR>
autocmd Filetype java no <F3> :make 
autocmd Filetype java no <S-F3> :make clean deploy site site:stage site:deploy<CR>
autocmd Filetype pom no <F2> :make clean package<CR>
autocmd Filetype pom no <S-F2> :make clean package site site:stage<CR>
autocmd Filetype pom no <C-F2> :make clean<CR>
autocmd Filetype pom no <F3> :make 
autocmd Filetype pom no <S-F3> :make clean deploy site site:stage site:deploy<CR>
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

" Key Mappings
"
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h
nnoremap <C-P> :tabprevious<CR>
nnoremap <C-N> :tabnew<CR>
nnoremap <C-x> :NERDTreeToggle<CR>
nnoremap <F10> :let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>
map <silent> <unique> <Leader>make :w<CR> :compiler eclim_mvn<CR> :make clean install<CR> :cw 4<CR>
map <silent> <unique> <Leader>root <Plug>RooterChangeToRootDirectory


" indentLine Configuration
"
let g:indentLine_color_term = 239
let g:indentLine_color_gui = '#09AA08'
let g:indentLine_char = '|'

" VIM Rooter
"
let g:rooter_patterns = ['pom.xml', '.git/']
let g:rooter_use_lcd = 1

" CtrlP
"
let g:ctrlp_map = '<leader>t'
" ignore directories
set wildignore +=*/build/**
let g:ctrlp_use_caching=0


" Define custom highlight groups
"

" ERROR / Warnings
hi User1 ctermbg=red ctermfg=black guibg=black guifg=red

" Attention
hi User2 ctermbg=black ctermfg=red guibg=red guifg=blue

" Normal
hi User3 ctermbg=black ctermfg=white guibg=blue guifg=green

" Status Line
"

" Status always visible
set laststatus=2
" Turn fugitive on
set statusline=%3*/%1*%{fugitive#statusline()}%3*
" Print the fugitive status.
" Move to the right side
set statusline+=\ \ \ \ \ \ \ \ %3*%f[%m%r]
set statusline+=\ \ \ \ \ \ \ \ \ \ \ \%{strftime(\"%B\ %d\ %Y@%H:%M:%S\")}
" TODO:  Colorize time & Shell & add to status line
set statusline+=%=
set statusline+=%2*%l(%c)/%L\ -\ %p%%%3*
set statusline+=\ \ \ \ \ \ \ \ \ \ \ \
set statusline+=%0*
