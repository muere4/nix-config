{ config, lib, pkgs, ... }:

{
  imports = [
    ./general-games.nix
    ./steam.nix
  ];
}
