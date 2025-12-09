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
    # Paquetes a nivel de sistema
    environment.systemPackages = with pkgs; [
      dbeaver-bin
      devenv
    ];

    nix.settings.trusted-users = [ "root" "muere" ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes específicos del usuario
      home.packages = with pkgs; [
        dbeaver-bin
        yaak
      ];
    };
  };
}
