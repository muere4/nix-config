{ config, lib, pkgs, ... }:

{
  imports = [
    ./libvirt.nix
    ./winapps.nix
  ];
}
