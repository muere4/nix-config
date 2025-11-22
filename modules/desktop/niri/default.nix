{ config, lib, pkgs, ... }:

{
  imports = [
    ./niri.nix
    #./kitty.nix
    ./rofi.nix
    ./mako.nix
    ./waybar.nix
    #./sddm.nix
  ];
}
