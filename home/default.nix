{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    firefox
    fastfetch
    discord
    kdePackages.kdenlive
  ];


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
