{ config, lib, pkgs, ... }:
{
  imports = [
    ./microsoft-edge.nix
    # Aquí podés agregar otros navegadores:
    # ./brave.nix
    # ./vivaldi.nix
  ];
}
