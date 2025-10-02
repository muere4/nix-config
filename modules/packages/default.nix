{ config, lib, pkgs, ... }:

{
  imports = [
    ./obs.nix
    ./haruna.nix
  ];
}
