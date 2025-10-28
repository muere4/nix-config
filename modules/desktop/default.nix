{ config, lib, pkgs, ... }:

{
  imports = [
    ./plasma.nix
    #./cosmic.nix
    #./gnome.nix
    ./browsers
  ];
}
