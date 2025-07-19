" Configuración básica de Vim
let g:gitblame_enabled = 0
set termguicolors

" Configuración específica de filetype
augroup haskell_config
  autocmd!
  autocmd FileType haskell setlocal shiftwidth=2 tabstop=2 expandtab
  autocmd FileType haskell setlocal formatprg=fourmolu
augroup END

augroup rust_config
  autocmd!
  autocmd FileType rust setlocal shiftwidth=4 tabstop=4 expandtab
  autocmd FileType rust setlocal formatprg=rustfmt
augroup END

augroup nix_config
  autocmd!
  autocmd FileType nix setlocal shiftwidth=2 tabstop=2 expandtab
augroup END

" Configuración de clipboard
if has('unnamedplus')
  set clipboard=unnamedplus
endif
