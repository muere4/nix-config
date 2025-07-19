{ pkgs
, utils
, ...}:
{
  packages = with pkgs; [
    nix-prefetch-scripts
    nixd  # LSP server para Nix (reemplaza rnix-lsp)
    nixpkgs-fmt  # Formatter para Nix
  ];
  imports = [];

  # Configuración de Emacs comentada - mantenida para referencia
  # emacsExtraPackages = (epkgs: with epkgs; [nix-buffer nix-sandbox nix-mode]);
  # emacsExtraConfig = builtins.readFile ./nixdev.el;

  # La configuración de Nix para Neovim se maneja en el módulo nvim principal
  # nixd LSP se configura automáticamente
}
