{ config, lib, pkgs, ... }:

{
  imports = [
    #./git.nix
    ./git-extended.nix
    ./podman.nix
    ./dotnet.nix
    ./haskell.nix
    ./python.nix
    ./toolkit.nix
  ];
}
