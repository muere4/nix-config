{ config, pkgs, lib, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ]; # Solo en nixos

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      epiphany
      geary
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.appindicator
    ];
  };
}
