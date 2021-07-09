local cmd = vim.cmd
local fn = vim.fn
local global = vim.g
local map = vim.api.nvim_set_keymap
local opt = vim.opt

-- General options
opt.clipboard = 'unnamedplus'
opt.completeopt = {'menuone', 'noinsert', 'noselect'}
opt.cursorline = true
opt.expandtab = true
opt.foldmethod = 'marker'
opt.guifont = 'FiraCode Nerd Font:h18'
opt.hidden = true
opt.inccommand = 'split'
opt.list = true
opt.listchars = 'tab:▸ ,trail:·'
opt.number = true
opt.pastetoggle = '<F12>'
opt.showmatch = true
opt.shiftwidth = 2
opt.showmode = false
opt.shortmess = opt.shortmess + { c = true }
opt.smartindent = true
opt.tabstop = 2
opt.termguicolors = true
opt.undodir = '/home/koral/.config/nvim/undodir'
opt.undofile = true

global.mapleader = '<Space>'
global.maplocalleader = ','

-- Colorscheme
opt.background = 'dark'
global.material_italic_comments = true
global.material_style = 'deep ocean'
require('material').set()


--
-- Plugin specific
--

-- ALE
global.ale_sign_error = '✘'
global.ale_sign_warning = '⚠'

-- Better whitespace
global.better_whitespace_enabled = false
global.strip_only_modified_lines = true
global.strip_whitespace_confirm = false
global.strip_whitespace_on_save = true

-- Git signs
require('gitsigns').setup()

-- LSP
local lsp = require('lspconfig')
lsp.gopls.setup {
  on_attach = require('completion').on_attach
}
lsp.pyls.setup {
  cmd = { "python-language-server" };
  root_dir = lsp.util.root_pattern('.git', fn.getcwd());
  on_attach = require('completion').on_attach
}
lsp.rls.setup {
  on_attach = require('completion').on_attach
}
lsp.rnix.setup {
  on_attach = require('completion').on_attach
}

-- Lualine
require('lualine').setup {
  options = { theme = 'material-nvim' },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {
      { 'diagnostics', sources = {"nvim_lsp"}, symbols = {error = ' ', warn = ' ', info = ' ', hint = ' '} },
      'encoding',
      'fileoformat',
      'filetype'
    },
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  extensions = {'fzf', 'quickfix'}
}

-- Neoformat
global.neoformat_nix_nixfmt = {
  exe = 'nixfmt';
  args = {'-w 120'};
  stdin = true;
  valid_exit_codes = {0};
  no_append = true;
}

-- NERDCommenter
global.NERDDefaultAlign = 'left'
global.NERDSpaceDelims = true

-- Rainbow
global.rainbow_active = true

-- Tree-sitter
require('nvim-treesitter.configs').setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = false,
  },
  ensure_installed = {
    "dockerfile",
    "fish",
    "go",
    "html",
    "java",
    "json",
    "lua",
    "nix",
    "r",
    "python",
    "rust",
    "toml",
    "yaml",
  },
}

-- Undotree
global.undotree_SetFocusWhenToggle = true
map('n', '<A-z>', ':UndotreeToggle<CR>', { noremap = true })

--
-- Language-specific
--

--  Haskell
global.haskell_indent_disable = true

-- Go
global.go_def_mapping_enabled = false

-- TeX
global.tex_flavor = 'latex'

--
-- Key bindings
--
map('n', '<C-b>', ':Buffers<CR>', {})
map('i', '<C-b>', '<C-o>:Buffers<CR>', {})
map('n', '<C-c>', '<Esc>', { noremap = true })
map('i', '<C-c>', '<Esc>', { noremap = true })
map('n', '<C-d>', 'dw', {})
map('i', '<C-d>', '<C-o>dw', {})
map('n', '<C-e>', '<End>', { noremap = true })
map('i', '<C-e>', '<End>', { noremap = true })
map('n', '<C-f>', ':BLines<CR>', {})
map('i', '<C-f>', '<C-o>:BLines<CR>', {})
map('n', '<C-h>', ':%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>', {})
map('i', '<C-h>', '<C-o>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>', {})
map('n', '<C-m>', '%', { noremap = true })
-- Breaks Enter key
-- map('i', '<C-m>', '<C-o>%', { noremap = true })
map('n', '<C-p>', ':Commands<CR>', {})
map('n', '<C-q>', ':confirm qall<CR>', {})
map('i', '<C-q>', '<C-o>:confirm qall<CR>', {})
map('n', '<C-s>', ':w<CR>', {})
map('i', '<C-s>', '<C-o>:w<CR>', {})
map('v', '<C-s>', '<Esc>:w<CR>gv', {})
map('n', '<C-t>', ':Files<CR>', {})
map('i', '<C-t>', '<C-o>:Files<CR>', {})
map('n', '<C-v>', 'P', { noremap = true })
map('i', '<C-v>', '<C-o>P', { noremap = true })
map('n', '<C-w>', ':bdelete<CR>', {})
map('i', '<C-w>', '<C-o>:bdelete<CR>', {})
map('n', '<C-y>', ':redo<CR>', {})
map('i', '<C-y>', '<C-o>:redo<CR>', {})
map('n', '<C-z>', ':undo<CR>', {})
map('i', '<C-z>', '<C-o>:undo<CR>', {})
map('n', '<C-Del>', 'dw', {})
map('i', '<C-Del>', '<C-o>dw', {})
map('n', '<C-PageDown>', ':bnext<CR>', {})
map('i', '<C-PageDown>', '<C-o>:bnext<CR>', {})
map('v', '<C-PageDown>', ':bnext<CR>', {})
map('n', '<C-PageUp>', ':bprev<CR>', {})
map('i', '<C-PageUp>', '<C-o>:bprev<CR>', {})
map('v', '<C-PageUp>', ':bprev<CR>', {})
map('i', '<C-Down>', '<C-o>}', { noremap = true })
map('n', '<C-Down>', '}', { noremap = true })
map('v', '<C-Down>', '}', { noremap = true })
map('i', '<C-Up>', '<C-o>{', { noremap = true })
map('n', '<C-Up>', '{', { noremap = true })
map('v', '<C-Up>', '{', { noremap = true })
map('i', '<C-Left>', '<C-o>b', { noremap = true })
map('n', '<C-Left>', 'b', { noremap = true })
map('i', '<C-Right>', '<C-o>e', { noremap = true })
map('n', '<C-Right>', 'e', { noremap = true })

map('n', '<A-Del>', ':delete<CR>', {})
map('i', '<A-Del>', '<C-o>:delete<CR>', {})
map('', '<A-Left>', '<Home>', { noremap = true })
map('i', '<A-Left>', '<Home>', { noremap = true })
map('', '<A-Right>', '<End>', { noremap = true })
map('i', '<A-Right>', '<End>', { noremap = true })
map('n', '<A-c>', '<plug>NERDCommenterToggle', {})
map('i', '<A-c>', '<C-o><plug>NERDCommenterToggle', {})
map('v', '<A-c>', '<plug>NERDCommenterToggle', {})
map('n', '<A-h>', ':noh<CR>', {})
map('i', '<A-h>', '<C-o>:noh<CR>', {})
map('n', '<A-n>', '*', { noremap = true })
map('i', '<A-n>', '<C-o>*', { noremap = true })
map('n', '<A-p>', '#', { noremap = true })
map('i', '<A-p>', '<C-o>#', { noremap = true })

map('i', '<Tab>', 'pumvisible() ? "<C-n>" : "<C-o>>>"', { noremap = true, expr = true })
map('i', '<S-Tab>', 'pumvisible() ? "<C-p>" : "<C-o><<"', { noremap = true, expr = true })
map('n', '<Tab>', '>>', { noremap = true })
map('n', '<S-Tab>', '<<', { noremap = true })

map('n', '<F5>', '<Plug>(lcn-menu)', {})

-- map('n', '<Space>', '@=(foldlevel('.')?'za':"\<Space>")<CR>', { noremap = true, silent = true })
-- map('v', '<Space>', 'zf', { noremap = true })

map('v', '<', '<gv', { noremap = true })
map('v', '>', '>gv', { noremap = true })
map('v', 'y', 'ygv', { noremap = true })
map('v', 'y', 'ygv', { noremap = true })
