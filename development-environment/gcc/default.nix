{ pkgs
, utils
, ...}:
{
  packages =
    with pkgs; [
      gcc
      gnumake
      valgrind
      binutils
      elfutils
      gdb
      ctags
      ccls
      # Herramientas adicionales para C/C++ development con Neovim
      clang-tools  # Para clangd LSP server
      cppcheck     # Static analysis
      cmake        # Build system
    ];
  imports = [];

  # Configuración de Emacs comentada - mantenida para referencia
  # emacsExtraPackages = (epkgs: with epkgs; [ccls]);
  # emacsExtraConfig = ''
  #   (setq ccls-executable "${pkgs.ccls}/bin/ccls")
  # '';

  # Configuración para Neovim (se maneja en el módulo nvim)
  nvimExtraConfig = ''
    -- C/C++ LSP configuration
    -- ccls and clangd servers available
  '';
}
