{utils, pkgs, ...}:
utils.env.packagesEnvironment (with pkgs; [
    htop
    fastfetch
    ripgrep
    unzip
    renameutils
    rename
    cmatrix
    ntfs3g
    fuse3
    fuse
])
