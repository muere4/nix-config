{utils, pkgs, ...}:
utils.env.packagesEnvironment (with pkgs; [
  # Herramientas básicas de línea de comandos
  htop
  tree
  unzip
  bat
  fastfetch
  ripgrep
  file
  curl
  wget
])
