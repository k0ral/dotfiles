lua require("plugins")
lua require("main")

" Nix
au BufNewFile,BufRead *.nix set filetype=nix

" Python
au BufNewFile,BufRead *.py set shiftwidth=2

" Rust
au BufNewFile,BufRead *.rs set shiftwidth=2

" Commands
command! ConfigOpen edit $MYVIMRC
command! ConfigReload source $MYVIMRC
command! SurroundChange execute "normal cs" . input("Change surrounding characters from: ") . input("Change surrounding characters to: ")
command! SurroundDelete execute "normal ds" . input("Delete surrounding characters: ")
command! LspCodeAction lua vim.lsp.buf.code_action()
command! LspDefinition lua vim.lsp.buf.definition()
command! LspDocumentSymbol lua vim.lsp.buf.document_symbol()
command! LspHover lua vim.lsp.buf.hover()
command! LspImplementation lua vim.lsp.buf.implementation()
command! LspRename lua vim.lsp.buf.rename()
command! LspReferences lua vim.lsp.buf.references()
command! LspSignatureHelp lua vim.lsp.buf.signature_help()
command! LspTypeDefinition lua vim.lsp.buf.type_definition()
command! LspWorkspaceSymbol lua vim.lsp.buf.workspace_symbol()
