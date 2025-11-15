{ config, lib, pkgs, ... }:

{
  imports = [
    ./ssh.nix
    ./samba.nix
  ];
}
