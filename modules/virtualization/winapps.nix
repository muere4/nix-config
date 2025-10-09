{ config, pkgs, lib, inputs, ... }:

let
  # Configuración del módulo - EDITAR AQUÍ
  enabledHosts = [ "nixi" ];  # Hosts donde se habilita WinApps
  userName = "muere";  # Usuario que usará WinApps

  # Detectar si está habilitado para este host
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Paquetes de WinApps a nivel de sistema
    environment.systemPackages = (with pkgs; [
      freerdp3
      dialog
      libnotify
      netcat-openbsd
      curl
      git
      iproute2
    ]) ++ [
      inputs.winapps.packages."${pkgs.system}".winapps
      inputs.winapps.packages."${pkgs.system}".winapps-launcher
    ];

    # Configuración de Home Manager
    home-manager.users.${userName} = { config, ... }: {
      # Paquetes específicos del usuario
      home.packages = [
        inputs.winapps.packages."${pkgs.system}".winapps
        inputs.winapps.packages."${pkgs.system}".winapps-launcher
      ] ++ (with pkgs; [
        freerdp3
      ]);

      # Crear el directorio de configuración si no existe
      home.activation.createWinAppsConfig = lib.mkAfter ''
        mkdir -p ${config.xdg.configHome}/winapps
      '';

      # Aliases útiles para WinApps
      programs.bash.shellAliases = {
        winapps-setup = "winapps-setup";
        winapps-manual = "winapps manual";
        winapps-start = "winapps-launcher &";
      };

      programs.zsh.shellAliases = {
        winapps-setup = "winapps-setup";
        winapps-manual = "winapps manual";
        winapps-start = "winapps-launcher &";
      };
    };

    # Nota: El usuario necesitará crear manualmente ~/.config/winapps/winapps.conf
    # con sus credenciales de Windows después de la instalación
  };
}
