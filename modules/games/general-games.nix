{ config, pkgs, lib, ... }:

let
  # Configuración del módulo
  enabledHosts = [ "nixi" ];
  userName = "muere";

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {

    programs.gamemode.enable = true;

    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      lunar-client
    ];


  };
}
