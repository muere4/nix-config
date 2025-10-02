{ config, lib, pkgs, ... }:

{
  imports = [
    ./git.nix
    ./podman.nix
  ];
}
