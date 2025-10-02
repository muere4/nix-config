{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    firefox
    vscode
    neofetch
    jetbrains.rider
    dbeaver-bin
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
