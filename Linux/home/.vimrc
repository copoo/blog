if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
  set fileencodings=utf-8,latin1
endif

set ff=unix
set encoding=utf-8
set fenc=utf-8
set fencs=utf-8,usc-bom,euc-jp,gb18030,gb2312,cp936,gbk
set foldlevelstart=99
set nocompatible        " be iMproved
set bs=indent,eol,start " allow backspacing over everything in insert mode
set ai                  " always set autoindenting on
set viminfo='20,\"50    " read/write a .viminfo file, don't store more than 50 lines of registers
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set fdm=marker
set nocp incsearch
set cinoptions=0,p0,t0
set cinwords=if,else,while,do,for,switch,case
set formatoptions=tcqr
set invnumber
set expandtab

if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

if &term=="xterm"
  set t_Co=8
  set t_Sb=dm
  set t_Sf=dm
endif

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on    " required!

set tabstop=4
set shiftwidth=4
set expandtab

autocmd FileType sh setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType php setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType coffee,javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120
autocmd FileType python setlocal tabstop=4 shiftwidth=4 softtabstop=4 textwidth=120
autocmd FileType html,htmldjango,xhtml,haml setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=0
autocmd FileType sass,scss,css setlocal tabstop=2 shiftwidth=2 softtabstop=2 textwidth=120

set nu
set completeopt=longest,menu
set showcmd
set nobackup
set noswapfile
set ignorecase

let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1

"==================================
" Bundle vundle
"==================================
" git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
set nocompatible
filetype off
filetype plugin on

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'Align'
Bundle 'Markdown'
Bundle 'Markdown-syntax'
Bundle 'scrooloose/nerdtree'
nnoremap <silent> <F5> :NERDTree<CR>
"==================================

