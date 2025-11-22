{ config, lib, pkgs, ... }:

{
  imports = [
    #./plasma.nix
    #./niri
    #./cosmic.nix
    ./gnome.nix
    ./browsers
  ];
}
