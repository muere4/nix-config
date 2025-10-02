{ config, lib, pkgs, ... }:

{
  imports = [
    #./git.nix
    ./git-extended.nix
    ./podman.nix
  ];
}
