" This line should not be removed as it ensures that various options are
" properly set to work with the Vim-related packages available in Debian.
runtime! debian.vim

" Have Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Have Vim load indentation rules and plugins according to the detected filetype.
if has("autocmd")
  filetype plugin indent on
endif

" Set the commands to save in history default number is 20.
set history=1000

" Disable vi compatibility
set nocompatible

" Show matching brackets.
set showmatch

" Enable mouse usage (all modes)
set mouse=a

" Enable syntax highlighting
syntax on

" Enable type file detection.
filetype on

colors koehler
set background=dark

" Show line numbers
set number

" Show relative line numbers
set relativenumber

" when indenting with '>', use 4 spaces width
set tabstop=4

" On pressing tab, insert 4 spaces
set shiftwidth=4

" Use spaces instead of tabs
set expandtab

" Kills audio termain bell sounds
set visualbell

" Highlight the current line
set cursorline

" Ignore capital letters during search.
set ignorecase

" Override the ignorecase option if searching for capital letters.
set smartcase

" Incremental search
set incsearch

" Use highlighting when doing a search.
set hlsearch
