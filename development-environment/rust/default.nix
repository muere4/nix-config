{ pkgs
, utils
, extraLibs ? []
, ...
}:
{
  packages =
    with pkgs; [
      rustc
      rustfmt
      rust-analyzer  # LSP server para Neovim
      cargo
      cargo-edit
      clippy        # Linting para Rust
    ];
  imports = [];

  # Configuración de Emacs comentada - mantenida para referencia
  # emacsExtraPackages =
  #   (epkgs: with epkgs; [rustic cargo]);
  # emacsExtraConfig = builtins.readFile ./rust.el;

  # La configuración de Rust para Neovim se maneja en el módulo nvim
  # rust-analyzer se configura automáticamente con nvim-lspconfig
}
