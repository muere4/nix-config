{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    firefox
    vscode
    neofetch
  ];

  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -la";
      ".." = "cd ..";
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos";
    };
  };
}
