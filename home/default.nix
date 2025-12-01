{ config, pkgs, ... }:

{

  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    fastfetch
    discord
    kdePackages.kdenlive
    vlc
    vlc-bittorrent
    firefox
    kdePackages.arianna
  ];

   xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "firefox.desktop" ];
          "x-scheme-handler/http" = [ "firefox.desktop" ];
          "x-scheme-handler/https" = [ "firefox.desktop" ];
          "x-scheme-handler/about" = [ "firefox.desktop" ];
          "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        };
      };


  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixi";
    };
  };
}
