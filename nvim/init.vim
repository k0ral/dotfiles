" {{{ Builtin options
set expandtab
set gdefault
set hidden
set inccommand=split
set list
set number
set showmatch
set tabstop=2
set termguicolors
set undodir=~/.config/nvim/undodir
set undofile

let mapleader="\<SPACE>"
" }}}

" {{{ Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'chaoren/vim-motion'
Plug 'Chiel92/vim-autoformat'
Plug 'easymotion/vim-easymotion'
Plug 'inside/vim-search-pulse'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'luochen1990/rainbow'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
Plug 'neovimhaskell/haskell-vim'
Plug 'LnL7/vim-nix'
Plug 'RRethy/vim-illuminate'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vmchale/dhall-vim'
Plug 'w0rp/ale'
call plug#end()
" }}}

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f)

" Undotree
let g:undotree_SetFocusWhenToggle = 1
nmap <A-z> :UndotreeToggle<CR>

" Airline
let g:airline#extensions#tabline#enabled = 1

" NERDCommenter
let g:NERDDefaultAlign = 'left'

" Autoformat
autocmd BufWrite *.hs :Autoformat
" Don't automatically indent on save, since vim's autoindent for haskell is buggy
autocmd FileType haskell let b:autoformat_autoindent=0

" Rainbow
let g:rainbow_active = 1

" Auto-pairs
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''

" {{{ Commands
command! ConfigOpen edit $MYVIMRC
command! ConfigReload source $MYVIMRC
" }}}

" {{{ Key bindings
nmap <C-b> :Buffers<CR>
nmap <C-d> dw
imap <C-d> <C-o>dw
nnoremap <C-e> <End>
inoremap <C-e> <End>
nnoremap <C-f> /
nmap <C-h> :%s//g<Left><Left>
nnoremap <C-m> %
nmap <C-p> :Commands<CR>
nmap <C-q> :confirm qall<CR>
nmap <C-s> :w<CR>
imap <C-s> <C-o>:w<CR>
nmap <C-t> :Files<CR>
imap <C-t> <C-o>:Files<CR>
nmap <C-w> :bdelete<CR>
imap <C-w> <C-o>:bdelete<CR>
nmap <C-y> :redo<CR>
imap <C-y> <C-o>:redo<CR>
nmap <C-z> :undo<CR>
imap <C-z> <C-o>:undo<CR>
nmap <C-Del> dw
nmap <C-PageDown> :bnext<CR>
imap <C-PageDown> <C-o>:bnext<CR>
nmap <C-PageUp> :bprev<CR>
imap <C-PageUp> <C-o>:bprev<CR>

nmap <A-Del> :delete<CR>
noremap <A-Left> <Home>
noremap <A-Right> <End>
map <A-c> <plug>NERDCommenterToggle
nnoremap <A-n> *
nnoremap <A-p> #

nnoremap ; :
" }}}

