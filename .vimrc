" Auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Essentials
Plug 'tpope/vim-sensible'
Plug 'junegunn/vim-plug'

" File Explorer
Plug 'scrooloose/nerdtree'

" Status Line
Plug 'itchyny/lightline.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Fuzzy Finder (requires fzf installed via dot_manager or system)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Themes
Plug 'morhetz/gruvbox'

call plug#end()

" ==========================================
" General Settings
" ==========================================
set nocompatible            " Disable compatibility with vi which can cause unexpected issues.
filetype plugin indent on   " Allow auto-indenting depending on file type

set clipboard+=unnamedplus  " System clipboard integration
set number                  " Show line numbers
set relativenumber          " Show relative line numbers (great for motions)
set cursorline              " Highlight current line
set noswapfile              " Don't use swapfile
set nobackup                " Don't create backup files
set undodir=~/.vim/undodir
set undofile                " Persistent undo

" Search settings
set ignorecase              " Ignore case when searching...
set smartcase               " ...unless there is a capital letter in the query
set hlsearch                " Highlight search results
set incsearch               " Jump to results as you type

" Whitespace & Indentation
set tabstop=4               " 4 spaces for tabs
set shiftwidth=4
set expandtab               " Use spaces instead of tabs
set smartindent             " Smart indentation
set nowrap                  " Don't wrap lines

" ==========================================
" Theme & UI
" ==========================================
set background=dark
set termguicolors           " Enable true colors support
try
  colorscheme gruvbox
catch
  colorscheme default
endtry

" Statusline config (Lightline)
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" ==========================================
" Key Mappings
" ==========================================
let mapleader = ","

" Clear search highlighting with <leader><space>
nnoremap <leader><space> :nohlsearch<CR>

" NERDTree
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>N :NERDTreeFind<CR>

" FZF
nnoremap <leader>f :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>g :GFiles<CR>

" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l