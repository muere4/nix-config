{ config, lib, pkgs, ... }:
{
  imports = [
    ./microsoft-edge.nix
    #./firefox.nix
    # Aquí podés agregar otros navegadores:
    # ./brave.nix
    # ./vivaldi.nix
  ];
}
