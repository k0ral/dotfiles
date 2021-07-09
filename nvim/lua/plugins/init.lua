local cmd = vim.cmd
local fn = vim.fn

local install_path = fn.stdpath('data')..'/site/pack/paqs/start/paq-nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  cmd('!git clone --depth 1 https://github.com/savq/paq-nvim.git '..install_path)
end

require "paq" {
  "savq/paq-nvim";  -- Let Paq manage itself

  'andymass/vim-matchup';
  'fatih/vim-go';
  'hoob3rt/lualine.nvim';
  'junegunn/fzf';
  'junegunn/fzf.vim';
  'kyazdani42/nvim-web-devicons';
  'lervag/vimtex';
  'lewis6991/gitsigns.nvim';
  'luochen1990/rainbow';
  'mbbill/undotree';
  'mhinz/vim-startify';
  'neovim/nvim-lspconfig';
  'neovimhaskell/haskell-vim';
  'ntpeters/vim-better-whitespace';
  'nvim-lua/completion-nvim';
  'nvim-lua/popup.nvim';
  'nvim-lua/plenary.nvim';
  {'nvim-treesitter/nvim-treesitter', run = 'TSUpdate'};
  'marko-cerovac/material.nvim';
  'purescript-contrib/purescript-vim';
  'romgrk/barbar.nvim';
  'sbdchd/neoformat';
  'scrooloose/nerdcommenter';
  'tpope/vim-eunuch';
  'tpope/vim-surround';
  'vmchale/dhall-vim';
  'w0rp/ale';
}
