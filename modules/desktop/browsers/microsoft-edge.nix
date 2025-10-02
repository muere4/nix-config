{ config, pkgs, lib, ... }:

let
  enabledHosts = [ "nixi" ];
  enabled = builtins.elem config.networking.hostName enabledHosts;
in
{
  config = lib.mkIf enabled {
    # Instalar a nivel de sistema
    environment.systemPackages = with pkgs; [
      microsoft-edge
    ];

    # Variables de entorno para Wayland
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    # Configuración por usuario con Home Manager
    home-manager.users.muere = {
      home.packages = with pkgs; [
        microsoft-edge
      ];

      # Alias útiles
      programs.bash.shellAliases = {
        edge = "microsoft-edge";
      };

      # Archivos XDG
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "text/html" = [ "microsoft-edge.desktop" ];
          "x-scheme-handler/http" = [ "microsoft-edge.desktop" ];
          "x-scheme-handler/https" = [ "microsoft-edge.desktop" ];
          "x-scheme-handler/about" = [ "microsoft-edge.desktop" ];
          "x-scheme-handler/unknown" = [ "microsoft-edge.desktop" ];
        };
      };
    };
  };
}
