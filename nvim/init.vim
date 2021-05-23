" {{{ Builtin options
set clipboard=unnamedplus
set cursorline
set expandtab
set foldmethod=marker
set hidden
set inccommand=split
set list
set listchars=tab:▸\ ,trail:·
set number
set pastetoggle=<F12>
set showmatch
set shiftwidth=2
set tabstop=2
set termguicolors
set undodir=~/.config/nvim/undodir
set undofile

let mapleader="\<SPACE>"
" }}}

" {{{ Plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'ap/vim-buftabline'
Plug 'chaoren/vim-motion'
Plug 'easymotion/vim-easymotion'
Plug 'cespare/vim-toml'
Plug 'inside/vim-search-pulse'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'lervag/vimtex'
Plug 'lifepillar/vim-solarized8'
Plug 'LnL7/vim-nix'
Plug 'luochen1990/rainbow'
Plug 'mbbill/undotree'
Plug 'mhinz/vim-startify'
Plug 'mhinz/vim-signify'
Plug 'neovimhaskell/haskell-vim'
Plug 'ntpeters/vim-better-whitespace'
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'}
Plug 'purescript-contrib/purescript-vim'
Plug 'RRethy/vim-illuminate'
Plug 'sbdchd/neoformat'
Plug 'scrooloose/nerdcommenter'
Plug 'tpope/vim-surround'
Plug 'vmchale/dhall-vim'
Plug 'w0rp/ale'
Plug 'whatyouhide/vim-gotham'
call plug#end()
" }}}

" EasyMotion
let g:EasyMotion_do_mapping = 0 " Disable default mappings
let g:EasyMotion_smartcase = 1
nmap s <Plug>(easymotion-overwin-f)

" Undotree
let g:undotree_SetFocusWhenToggle = 1
nmap <A-z> :UndotreeToggle<CR>

" Lightline
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'gotham',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'readonly', 'relativepath', 'modified' ] ]
  \ } }

" NERDCommenter
let g:NERDDefaultAlign = 'left'
let g:NERDSpaceDelims = 1

" Neoformat
let g:neoformat_nix_nixfmt = {
\ 'exe': 'nixfmt',
\ 'args': ['-w 120'],
\ 'stdin': 1,
\ 'valid_exit_codes': [0],
\ 'no_append': 1,
\ }

" Rainbow
let g:rainbow_active = 1

" Auto-pairs
let g:AutoPairsShortcutToggle = ''
let g:AutoPairsShortcutJump = ''



" Colorscheme
set background=dark
colorscheme gotham

" Better whitespace
let g:better_whitespace_enabled=0
let g:strip_only_modified_lines=1
let g:strip_whitespace_confirm=0
let g:strip_whitespace_on_save=1

" VimTeX
let g:tex_flavor = 'latex'

" {{{ Commands
command! ConfigOpen edit $MYVIMRC
command! ConfigReload source $MYVIMRC
command! SurroundChange execute "normal cs" . input("Change surrounding characters from: ") . input("Change surrounding characters to: ")
command! SurroundDelete execute "normal ds" . input("Delete surrounding characters: ")
" }}}

" {{{ Key bindings
nmap <C-b> :Buffers<CR>
imap <C-b> <C-o>:Buffers<CR>
nnoremap <C-c> <Esc>
inoremap <C-c> <Esc>
nmap <C-d> dw
imap <C-d> <C-o>dw
nnoremap <C-e> <End>
inoremap <C-e> <End>
nmap <C-f> :BLines<CR>
imap <C-f> <C-o>:BLines<CR>
nmap <C-h> :%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>
imap <C-h> <C-o>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>
nnoremap <C-m> %
" Breaks Enter key
"inoremap <C-m> <C-o>%
nmap <C-p> :Commands<CR>
nmap <C-q> :confirm qall<CR>
imap <C-q> <C-o>:confirm qall<CR>
nmap <C-s> :w<CR>
imap <C-s> <C-o>:w<CR>
vmap <C-s> <Esc>:w<CR>gv
nmap <C-t> :Files<CR>
imap <C-t> <C-o>:Files<CR>
nnoremap <C-v> P
inoremap <C-v> <C-o>P
nmap <C-w> :bdelete<CR>
imap <C-w> <C-o>:bdelete<CR>
nmap <C-y> :redo<CR>
imap <C-y> <C-o>:redo<CR>
nmap <C-z> :undo<CR>
imap <C-z> <C-o>:undo<CR>
nmap <C-Del> dw
imap <C-Del> <C-o>dw
nmap <C-PageDown> :bnext<CR>
imap <C-PageDown> <C-o>:bnext<CR>
vmap <C-PageDown> :bnext<CR>
nmap <C-PageUp> :bprev<CR>
imap <C-PageUp> <C-o>:bprev<CR>
vmap <C-PageUp> :bprev<CR>
inoremap <C-Down> <C-o>}
nnoremap <C-Down> }
vnoremap <C-Down> }
inoremap <C-Up> <C-o>{
nnoremap <C-Up> {
vnoremap <C-Up> {
inoremap <C-Left> <C-o>b
nnoremap <C-Left> b
inoremap <C-Right> <C-o>e
nnoremap <C-Right> e

nmap <A-Del> :delete<CR>
imap <A-Del> <C-o>:delete<CR>
noremap <A-Left> <Home>
inoremap <A-Left> <Home>
noremap <A-Right> <End>
inoremap <A-Right> <End>
nmap <A-c> <plug>NERDCommenterToggle
imap <A-c> <C-o><plug>NERDCommenterToggle
vmap <A-c> <plug>NERDCommenterToggle
nmap <A-h> :noh<CR>
imap <A-h> <C-o>:noh<CR>
nnoremap <A-n> *
inoremap <A-n> <C-o>*
nnoremap <A-p> #
inoremap <A-p> <C-o>#

inoremap <Tab> <C-o>>>
inoremap <S-Tab> <C-o><<
nnoremap <Tab> >>
nnoremap <S-Tab> <<

vnoremap < <gv
vnoremap > >gv
vnoremap y ygv
vnoremap y ygv
" }}}

