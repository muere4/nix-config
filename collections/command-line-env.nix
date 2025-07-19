{utils, pkgs, ...}:
utils.env.packagesEnvironment (with pkgs; [
    htop
    fastfetch
    ripgrep
    unzip
    renameutils
    rename
    cmatrix
    encfs #cifra carpetas
])
